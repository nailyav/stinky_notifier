import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifier/src/models/product_model.dart';


class EditProducts extends Notifier<List>{

  List products = [];

  // initial id = 0, set first unused id
  Product setId(Product newProduct) {
    int id = 1;
    while ((products.singleWhere((it) => it.id == id,
        orElse: () => false)) != false) {
      id++;
    }
    newProduct.id = id;
    return newProduct;
  }

  List addProduct(Product newProduct) {
    products.add(setId(newProduct));
    return products;
  }

  List removeProduct(int id) {
    products.removeWhere((element) => element.id == id);
    return products;
  }

  void updateList(List list) {
    products = list;
    state = products;
  }

  @override
  List build() {
    return products;
  }

  void addProductState(Product product) {
    state = addProduct(product);
  }

  void removeProductState(int id) async {
    state = removeProduct(id);
  }
}

final editProductsProvider = NotifierProvider<EditProducts, List>(() {
  return EditProducts();
});