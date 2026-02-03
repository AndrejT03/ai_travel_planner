import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/auth/login_screen.dart';

class AuthGate extends StatelessWidget {
  final Widget child;

  const AuthGate({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isLoggedIn) return const LoginScreen();
    return child;
  }
}