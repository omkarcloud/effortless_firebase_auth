import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_helpers/firestore_helpers.dart';

import 'infrastructure/queries.dart';

List<Map<String, dynamic>> allsellers = [
  {
    'name': 'Ratu',
    "phone": "999",
    "catedories": ['milk', 'pulses']
  },
  {
    'name': 'Ram',
    "phone": "888",
    "catedories": ['groceries']
  },
  {
    'name': 'Chandra',
    "phone": "777",
    "catedories": ['milk']
  },
];

// Some have categories and some not

List<Map<String, dynamic>> allproduct = [
  {
    'name': 'Chips',
    "price": 5,
    "category": 'groceries',
    "subcategory": "packed",
  },
  {
    'name': 'Milk',
    "price": 5,
    "category": 'milk',
  },
  {
    'name': 'Atta',
    "price": 5,
    "category": 'groceries',
    "subcategory": "fresh",
  },
];

var sellers = Api('sellers');
var products = Api('products');

Future<QuerySnapshot> getProducts() async {
  return await products.getDataCollection();
}

Future<QuerySnapshot> getSpecificProducts(
    String category, String subcategory) async {
  return products.ref
      .where('sid', isEqualTo: 'ObolIcnaBIWC7sl2rgudA')
      .where('category', isEqualTo: category)
      .where('subcategory', isEqualTo: subcategory)
      .getDocuments();
}

Future<DocumentReference> addProducts(product) {
  return products.addDocument(product);
}

performoperations() async {
  // final seller = await getFirstSeller();
  // await products.deleteCollection();

  // allproduct.forEach((e) {
  //   e['sid'] = seller.documentID;
  // });

  // await Future.forEach(allproduct, (element) => addProducts(element));
  (await getallCatSeller('groceries'));
  // await getallCatSeller('pulses');

  // print(seller.data);
}

createProduct() {}

Future<DocumentSnapshot> getFirstSeller() async {
  final docs =
      await sellers.ref.where('name', isEqualTo: 'Ratu').getDocuments();
  final firstseller = docs.documents.first;
  return firstseller;
}

Future getallCatSeller(String cat) async {
  // query.getDocuments();
  final docs =
      await sellers.ref.where('catedories', arrayContains: cat).getDocuments();
  logDocs(docs);
  final firstseller = docs.documents.first.data;
  return firstseller;
}

void logDocs(QuerySnapshot docs) {
  if (docs.documents.isEmpty) {
    print('Documents are Empty');
    return;
  }
  docs.documents.forEach((doc) {
    print(doc.data);
  });
}

Future addSellers() async {
  allsellers.forEach((data) async {
    final doc = await sellers.addDocument(data);
    print('doc is $doc');
  });
}

Future deleteSellers() async {
  allsellers.forEach((element) async {
    final docs = await sellers.getDataCollection();
    docs.documents.forEach((doc) async {
      await doc.reference.delete();
      print('Deleted $doc');
    });
  });
}
