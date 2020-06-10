import 'package:allsirsa/infrastructure/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


import 'package:allsirsa/infrastructure/CategoryApi.dart';
import 'package:allsirsa/infrastructure/CustomerApi.dart';
import 'package:allsirsa/infrastructure/OrderApi.dart';
import 'package:allsirsa/infrastructure/ProductsApi.dart';
import 'package:allsirsa/infrastructure/SellerApi.dart';
import 'package:rx_store_ds/rx_store_ds.dart';

// Set up apis
final sellerapi = SellerApi();
final customerapi = CustomerApi();
final orderapi = OrderApi();
final productapi = ProductApi();
final categoryapi = CategoryApi();

performoperations() async {
  // -------------Customer Dash------------------
  // final createdCustomer = await createCustomer();

  // Get categories
  final categories = await categoryapi.serveCategories();
  // Get Sellers of Category
  final sellerdata = await sellerapi.getallCatSeller(categories.first);

  // User select Seller
  final selectedSeller = sellerdata.first;

  // User gets  selected seller products
  final productdata = await productapi.getProducts(
    categories.first,
    sid: selectedSeller['id'],
  );

  // Get User details for placing order
  final customerdata = await customerapi.customer.getFirstDocumentData();

  // User places order
  // await placeOrder(productdata.first, selectedSeller, customerdata);

  // Just for logging in case
  saveMultiple({
    'categories': categories,
    'sellerdata': selectedSeller,
    'productdata': productdata,
    'customerdata': customerdata,
  });

  logStore();
  // -------------Seller Dash------------------

  // Get sellers order
  final sellerorder =
      (await orderapi.getOrderOfSeller(selectedSeller['id'])).first;

  //  Sellers fulfill order
  await orderapi.fulfillOrder(sellerorder['id']);

  //  Sellers cancel order
  await orderapi.cancelOrder(sellerorder['id'], 'notavailable');
}

Future<DocumentSnapshot> createCustomer() async {
  final customer = await CustomerApi().createCustomer('Ram', '11 Street');
  return ((await customer.get()));
}

Future placeOrder(Map<String, dynamic> productdata,
    Map<String, dynamic> sellerdata, Map<String, dynamic> customerdata) async {
  final docref = await orderapi.placeOrder(
      productdata['id'], sellerdata['id'], customerdata['id'], 2);
  return Api.withIdSingle(await docref.get());
}
