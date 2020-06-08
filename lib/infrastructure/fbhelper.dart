import 'package:cloud_firestore/cloud_firestore.dart';

void logDocs(QuerySnapshot docs) {
  if (docs.documents.isEmpty) {
    print('Documents are Empty');
    return;
  }
  docs.documents.forEach((doc) {
    print(doc.data);
  });
}
