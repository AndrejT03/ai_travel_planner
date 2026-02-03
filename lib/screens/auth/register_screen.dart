import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/glass.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullName = TextEditingController();
  final _username = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _fullName.dispose();
    _username.dispose();
    _address.dispose();
    _phone.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await context.read<AuthProvider>().register(
        email: _email.text.trim(),
        password: _pass.text,
        fullName: _fullName.text.trim(),
        username: _username.text.trim(),
        address: _address.text.trim(),
        phone: _phone.text.trim(),
      );
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1476514525535-07fb3b4ae5f1?q=80&w=2070&auto=format&fit=crop',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Glass(
                blur: 15,
                opacity: 0.2,
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Join AI Travel Planner',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildTextField(_fullName, 'Full Name', Icons.person),
                      const SizedBox(height: 12),
                      _buildTextField(_username, 'Username', Icons.alternate_email),
                      const SizedBox(height: 12),
                      _buildTextField(_address, 'Address', Icons.location_on),
                      const SizedBox(height: 12),
                      _buildTextField(_phone, 'Phone', Icons.phone),
                      const SizedBox(height: 12),
                      _buildTextField(_email, 'Email', Icons.email),
                      const SizedBox(height: 12),
                      _buildTextField(_pass, 'Password', Icons.lock, obscure: true),

                      const SizedBox(height: 20),

                      if (_error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            _error!,
                            style: const TextStyle(color: Colors.redAccent),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF66B7FF),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _loading
                              ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                          )
                              : const Text(
                              'Register',
                              style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
