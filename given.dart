import 'package:meta/meta.dart';

class Validation {
  final List<dynamic> validators;

  Validation({@required this.validators});

  void add(dynamic f) {
    print('Hello from add');
  }

  double remove() {
    print('Hello from remove');
  }
}
