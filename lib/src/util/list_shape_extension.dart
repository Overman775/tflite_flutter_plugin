extension ListShape on List {
  List reshape(List<int> shape) {
    var dims = shape.length;
    var numElements = 1;
    for (var i = 0; i < dims; i++) {
      numElements *= shape[i];
    }

    if (numElements != computeNumElements) {
      throw ArgumentError(
          'Total elements mismatch expected: $numElements elements for shape: $shape but found $computeNumElements');
    }
    var reshapedList = flatten<dynamic>();
    for (var i = dims - 1; i > 0; i--) {
      var temp = [];
      for (var start = 0;
          start + shape[i] <= reshapedList.length;
          start += shape[i]) {
        temp.add(reshapedList.sublist(start, start + shape[i]));
      }
      reshapedList = temp;
    }
    return reshapedList;
  }

  List<int> get shape {
    if (isEmpty) {
      return [];
    }
    var list = this as dynamic;
    var shape = <int>[];
    while (list is List) {
      shape.add((list as List).length);
      list = list.elementAt(0);
    }
    return shape;
  }

  List<T> flatten<T>() {
    var flat = <T>[];
    forEach((e) {
      if (e is Iterable<T>) {
        flat.addAll(e);
      } else if (e is T) {
        flat.add(e);
      } else {
        // Error with typing
      }
    });
    return flat;
  }

  int get computeNumElements {
    var n = 1;
    for (var i = 0; i < shape.length; i++) {
      n *= shape[i];
    }
    return n;
  }
}
