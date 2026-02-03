import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/day_plan.dart';

class LibraryRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<DayPlan>> streamUserPlans(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('plans')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return DayPlan.fromMap(data);
      }).toList();
    });
  }

  Future<void> addPlan(String uid, DayPlan plan) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('plans')
        .doc(plan.id)
        .set(plan.toMap());
  }

  Future<void> removePlan(String uid, String planId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('plans')
        .doc(planId)
        .delete();
  }

  Stream<List<DayPlan>> streamUserFavorites(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return DayPlan.fromMap(data);
      }).toList();
    });
  }

  Future<void> addFavorite(String uid, DayPlan plan) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(plan.id)
        .set(plan.toMap());
  }

  Future<void> removeFavorite(String uid, String planId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('favorites')
        .doc(planId)
        .delete();
  }
}