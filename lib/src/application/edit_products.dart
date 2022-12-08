import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

import 'package:notifier/src/models/product_model.dart';

class EditProducts extends Notifier<Future<List>> {
  List products = [];

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
    // final directory = await getApplicationDocumentsDirectory();
    // final String path = directory.path;
    // return '$path/products.json';
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/products.json');
    // File file = File(await getLocalPath());
    // return file;
  }

  Future<List> writeJson(List list) async {
    final file = await localFile;
    file.writeAsStringSync(json.encode(list));
    return list;
  }

  Future<void> addProductJson(Product product) async {
    products.add(product);
    state = writeJson(products);
  }

  // Future<void> removeProductJson(int id) async {
  //   products.removeAt(id);
  //   state = writeJson(products);
  // }

  Future<void> writeProducts(List list) async {
    products = list;
    state = writeJson(products);
  }

  @override
  Future<List> build() {
    return writeJson(products);
  }
}

final editProductsProvider = NotifierProvider<EditProducts, Future<List>>(() {
  return EditProducts();
});
