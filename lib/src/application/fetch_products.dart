import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class FetchProducts extends Notifier<Future<List>> {
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

  Future<List> writeListJson(List list) async {
    final file = await getLocalFile();
    file.writeAsStringSync(json.encode(list));

    return list;
  }

  @override
  Future<List> build() {
    return writeListJson(products);
  }

  void confirmEdit(List list) {
    products = list;
    state = writeListJson(products);
  }
}

final fetchProductsProvider = NotifierProvider<FetchProducts, Future<List>>(() {
  return FetchProducts();
});
