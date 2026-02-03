import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/glass.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await context.read<AuthProvider>().login(_email.text.trim(), _pass.text);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=2021&auto=format&fit=crop',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.5)),

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
                      const Icon(Icons.travel_explore, size: 60, color: Color(0xFF66B7FF)),
                      const SizedBox(height: 16),
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 30),

                      _buildTextField(_email, 'Email', Icons.email),
                      const SizedBox(height: 16),
                      _buildTextField(_pass, 'Password', Icons.lock, obscure: true),

                      const SizedBox(height: 24),
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
                              : const Text('Login', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),

                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => context.push('/register'),
                        child: const Text(
                          "Don't have an account? Sign up",
                          style: TextStyle(color: Colors.white70),
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