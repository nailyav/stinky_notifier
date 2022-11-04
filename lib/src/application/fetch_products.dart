import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifier/src/models/product_model.dart';
import 'package:path_provider/path_provider.dart';


class FetchProducts extends Notifier<Future<List>>{
  
  List products = [];

  Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    return '$path/products.json';
  }

  Future<File> getLocalFile() async {
    File file = File(await getLocalPath());
    return file;
  }

  // // initial id = 0, set first unused id
  // Product setId(Product newProduct) {
  //   int id = 1;
  //   while ((products.singleWhere((e) => e.id == id,
  //       orElse: () => false)) != false) {
  //     id++;
  //   }
  //   newProduct.id = id;
  //   return newProduct;
  // }

  Future<List> writeProductJson(Product newProduct) async {
    final file = await getLocalFile();
    // newProduct = setId(newProduct);
    products.add(newProduct);
    products.map((element) => element.toJson()).toList();
    file.writeAsStringSync(json.encode(products));

    return products;
  }

  Future<List> writeListJson(List list) async {
    final file = await getLocalFile();
    file.writeAsStringSync(json.encode(list));

    return list;
  }

  @override
  Future<List> build() {
    // return writeListJson(products);
    Product p = Product(0, 'milk', '10.01.22');
    return writeProductJson(p);
  }

  // void addProduct(Product product) {
  //   state = writeProductJson(product);
  // }

  void removeProduct(int id) async {
    final product = products.singleWhere((element) =>
    element.id == id, orElse: () {
      return null;
    });
    product.isFavourite = false;
    products.removeWhere((element) => element.id == id);
    state = writeListJson(products);
  }

  void confirmEdit(List list) {
    products = list;
    state = writeListJson(products);
  }
}

final fetchProductsProvider = NotifierProvider<FetchProducts, Future<List>>(() {
  return FetchProducts();
});