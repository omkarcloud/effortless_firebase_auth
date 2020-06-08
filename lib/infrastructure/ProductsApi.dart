import 'package:cloud_firestore/cloud_firestore.dart';

import 'api.dart';

class ProductApi {
  final product = Api('product');
  //  GET by category await ProductApi().getProducts('groceries')
  Future<List<Map<String, dynamic>>> getProducts(String category,
      {DocumentReference sid, String subcategory}) async {
    var query = product.ref.where('category', isEqualTo: category);

    if (subcategory != null)
      query = query.where('subcategory', isEqualTo: subcategory);

    if (sid != null) query = query.where('sid', isEqualTo: sid);

    final docs = await query.getDocuments();

    return Api.getData(Api.withId(docs.documents));
  }
}

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
