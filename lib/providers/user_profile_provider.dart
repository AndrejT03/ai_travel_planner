import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../services/user_profile_repository.dart';
import 'auth_provider.dart';

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository();
});

final userProfileStreamProvider = StreamProvider<UserProfile?>((ref) {
  final auth = ref.watch(authProvider);
  final uid = auth.uid;
  if (uid == null) return const Stream.empty();

  final repo = ref.watch(userProfileRepositoryProvider);
  return repo.streamProfile(uid);
});

final userProfileControllerProvider = Provider((ref) => UserProfileController(ref));

class UserProfileController {
  final Ref _ref;
  UserProfileController(this._ref);

  Future<void> update({
    required String fullName,
    required String username,
    required String address,
    required String phone,
    required String email,
  }) async {
    final auth = _ref.read(authProvider);
    final uid = auth.uid;
    if (uid == null) return;

    final repo = _ref.read(userProfileRepositoryProvider);
    await repo.updateProfile(uid, {
      'fullName': fullName,
      'username': username,
      'address': address,
      'phone': phone,
      'email': email,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}