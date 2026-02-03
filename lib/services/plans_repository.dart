import 'package:cloud_firestore/cloud_firestore.dart';

class PlansRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> streamUserPlans(String uid) {
    return _db.collection('users').doc(uid).collection('plans').snapshots().map((snap) {
      return snap.docs.map((d) => {'id': d.id, ...d.data()}).toList();
    });
  }

  Future<String> createPlan(String uid, Map<String, dynamic> data) async {
    final doc = await _db.collection('users').doc(uid).collection('plans').add(data);
    return doc.id;
  }

  Future<void> updatePlan(String uid, String planId, Map<String, dynamic> data) {
    return _db.collection('users').doc(uid).collection('plans').doc(planId).set(
      data,
      SetOptions(merge: true),
    );
  }

  Future<void> deletePlan(String uid, String planId) {
    return _db.collection('users').doc(uid).collection('plans').doc(planId).delete();
  }
}