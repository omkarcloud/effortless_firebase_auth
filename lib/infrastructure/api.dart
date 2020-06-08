import 'package:cloud_firestore/cloud_firestore.dart';

class Api {
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

  Api(this.path) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments();
  }

  Future<void> deleteCollection() async {
    final docs = (await getDataCollection()).documents;
    await Future.forEach(docs, (element) => element.reference.delete());
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  static List<DocumentSnapshot> withId(List<DocumentSnapshot> docs) {
    return docs.map(withIdSingle).toList();
  }

  static DocumentSnapshot withIdSingle(DocumentSnapshot doc) {
    doc.data['id'] = doc.reference;
    return doc;
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }

  static DocumentSnapshot _getFirstDocFromList(QuerySnapshot querySnapshot) =>
      querySnapshot.documents.first;

  Future<DocumentSnapshot> getFirstDocument() async {
    return _getFirstDocFromList(await ref.limit(1).getDocuments());
  }

  Future<Map<String, dynamic>> getFirstDocumentData(
      {bool withID = true}) async {
    final doc = (await getFirstDocument());
    if (withID) withIdSingle(doc);
    return doc.data;
  }

  Future<void> removeDocument(String id) {
    return ref.document(id).delete();
  }

  Future<DocumentReference> addDocument(Map<String, dynamic> data) {
    return ref.add(data);
  }

  Future<void> updateDocument(Map<String, dynamic> data, String id) {
    return ref.document(id).updateData(data);
  }

  static List<Map<String, dynamic>> getData(List<DocumentSnapshot> docs) =>
      docs.map((e) => e.data).toList();
}
