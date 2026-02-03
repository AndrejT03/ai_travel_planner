import 'package:cloud_firestore/cloud_firestore.dart';

class TemplatesRepository {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> streamTemplates() {
    return db.collection('explore_templates').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<void> upsertTemplate(String id, Map<String, dynamic> data) {
    return db.collection('explore_templates').doc(id).set(
      data,
      SetOptions(merge: true),
    );
  }
}