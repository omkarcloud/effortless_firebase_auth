class Facebook {
  Facebook();

  bool perform() {
    print('Hello from perform');
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is Facebook;
  }

  @override
  String toString() {
    return 'Facebook {}';
  }
}
