import 'package:flutter/material.dart';

import 'infrastructure/queries.dart';
import 'operations.dart';

class Home extends StatelessWidget {
  const Home({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    performoperations();

    return Container();
  }
}
