import 'package:cloud_firestore/cloud_firestore.dart';

import 'api.dart';

class CustomerApi {
  final customer = Api('customer');
  Future<DocumentReference> createCustomer(String name, String address) async {
    final Map<String, dynamic> data = {
      'name': name,
      'address': address,
      'cart': [],
    };

    return await customer.addDocument(data);
  }

  Future<void> saveToCart(
    DocumentReference cid,
    List<DocumentReference> pid,
  ) async {
    await cid.updateData({'cart': FieldValue.arrayUnion(pid)});
  }

  Future<void> removeFromCart(
    DocumentReference cid,
    List<DocumentReference> pid,
  ) async {
    await cid.updateData({'cart': FieldValue.arrayRemove(pid)});
  }

  Future<void> getCartProducts(
    DocumentReference cid,
    List<DocumentReference> pid,
  ) async {
    final List<DocumentReference> products = (await cid.get()).data['cart'];
    final List<DocumentSnapshot> docs = [];

    await Future.forEach(products, (element) async {
      docs.add(await element.get());
    });

    return Api.getData(Api.withId(docs));
  }
}
