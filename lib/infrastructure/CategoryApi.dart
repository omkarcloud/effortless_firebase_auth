import 'package:allsirsa/infrastructure/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryApi {
  final category = Api('category');
  Future<List<String>> serveCategories() async {
    final categorydata = (await category.getFirstDocument()).data;
    final cats = (categorydata['categories'] as List)
        .map((e) => e['name'] as String)
        .toList();
    // print(cats);
    return cats;
  }

  // Future<void> addCategories(List<Map<String, dynamic>> cats) async {
  //   final catdoc = await category.getFirstDocument();
  //   final oldcats = catdoc.data['categories'] as List;
  //   final allcats = [...cats, ...oldcats];

  //   return catdoc.reference.updateData({'categories': allcats});
  // }
}

List<Map<String, dynamic>> cats = [
  {'name': "groceries"},
  {'name': "milk"},
];

main(List<String> args) {
  print({'name': "groceries"} == {'name': "groceries"});
}
