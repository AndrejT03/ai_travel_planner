import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_profile_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _fullName = TextEditingController();
  final _username = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();

  bool _filledOnce = false;
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _fullName.dispose();
    _username.dispose();
    _address.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      await ref.read(userProfileControllerProvider).update(
        fullName: _fullName.text.trim(),
        username: _username.text.trim(),
        address: _address.text.trim(),
        phone: _phone.text.trim(),
        email: _email.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileStreamProvider);

    profileAsync.whenData((profile) {
      if (profile == null || _filledOnce) return;
      _filledOnce = true;
      _fullName.text = profile.fullName;
      _username.text = profile.username;
      _address.text = profile.address;
      _phone.text = profile.phone;
      _email.text = profile.email;
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Personal Info')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _field(_fullName, 'Full name'),
          const SizedBox(height: 12),
          _field(_username, 'Username'),
          const SizedBox(height: 12),
          _field(_address, 'Address'),
          const SizedBox(height: 12),
          _field(_phone, 'Phone'),
          const SizedBox(height: 12),
          _field(_email, 'Email'),
          const SizedBox(height: 16),
          if (_error != null) Text(_error!, style: const TextStyle(color: Colors.redAccent)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _saving ? null : _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF66B7FF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(_saving ? 'Saving...' : 'Save'),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController c, String label) {
    return TextField(
      controller: c,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}