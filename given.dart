import 'package:flutter/material.dart';

class Validation extends StatefulWidget {
   final List<dynamic> validators;

   Validation({@required this.validators, Key key}) : super(key : key);

   void add(dynamic f){
      print('Hello from add');
   }

   double remove(){
      print('Hello from remove');
   }

   @override
   _ValidationState createState(){
      return _ValidationState();
   }

}

class _ValidationState extends State<Validation> {

   @override
   Widget build(BuildContext context){
      return Container(child: Text("Hello from Validation"),);
   }

}
