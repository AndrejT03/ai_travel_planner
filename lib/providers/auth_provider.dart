import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((ref) {
  return AuthProvider(AuthService());
});

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  StreamSubscription<User?>? _sub;
  User? _user;

  AuthProvider(this._authService) {
    _sub = _authService.authStateChanges().listen((u) {
      _user = u;
      notifyListeners();
    });
  }

  User? get user => _user;
  String? get uid => _user?.uid;
  bool get isLoggedIn => _user != null;

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String username,
    required String address,
    required String phone,
  }) async {
    final cred = await _authService.register(email: email, password: password);
    final uid = cred.user!.uid;

    await _db.collection('users').doc(uid).set({
      'fullName': fullName,
      'username': username,
      'address': address,
      'phone': phone,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> login(String email, String password) async {
    await _authService.login(email: email, password: password);
  }

  Future<void> logout() => _authService.logout();

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}