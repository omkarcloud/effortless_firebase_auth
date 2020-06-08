import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'api.dart';

class OrderApi {
  final order = Api('order');
  Random random = new Random();

  Future<DocumentReference> placeOrder(DocumentReference pid,
      DocumentReference sid, DocumentReference cid, int quantity) async {
    int randomNumber = random.nextInt(9999) + 1000;
    final Map<String, dynamic> data = {
      "sid": sid,
      "cid": cid,
      "pid": pid,
      "quantity": quantity,
      'status': 'incompleted',
      'code': randomNumber
    };

    return await order.addDocument(data);
  }

  Future<List<Map<String, dynamic>>> getOrderOfSeller(
      DocumentReference sid) async {
    final docs = await order.ref.where('sid', isEqualTo: sid).getDocuments();
    return Api.getData(Api.withId(docs.documents));
  }

  Future<List<Map<String, dynamic>>> getOrderOfCustomer(
      DocumentReference cid) async {
    final docs = await order.ref.where('cid', isEqualTo: cid).getDocuments();
    return Api.getData(Api.withId(docs.documents));
  }

  Future<void> fulfillOrder(DocumentReference oid) async {
    await order.updateDocument({'status': 'completed'}, oid.documentID);
  }

  Future<void> cancelOrder(DocumentReference oid, String reason) async {
    await order.updateDocument({
      'status': 'cancelled',
      'reason': reason,
    }, oid.documentID);
  }
}
