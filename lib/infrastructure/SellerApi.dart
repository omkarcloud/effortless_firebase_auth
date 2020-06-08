import 'api.dart';

class SellerApi {
  final seller = Api('seller');
  Future<List<Map<String, dynamic>>> getallCatSeller(String cat) async {
    // query.getDocuments();
    final docs = await seller.ref
        .where('categories', arrayContainsAny: [cat]).getDocuments();

    return Api.getData(Api.withId(docs.documents));
  }
}

List<Map<String, dynamic>> allsellers = [
  {
    'name': 'Ratu',
    "phone": "999",
    "categories": ['milk', 'pulses']
  },
  {
    'name': 'Ram',
    "phone": "888",
    "categories": ['groceries']
  },
  {
    'name': 'Chandra',
    "phone": "777",
    "categories": ['milk']
  },
];
