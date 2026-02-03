import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class UserProfileRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<UserProfile?> streamProfile(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UserProfile.fromMap(doc.id, doc.data()!);
    });
  }

  Future<void> updateProfile(String uid, Map<String, dynamic> data) {
    return _db.collection('users').doc(uid).set(
      data,
      SetOptions(merge: true),
    );
  }
}