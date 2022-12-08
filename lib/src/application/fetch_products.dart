import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:notifier/src/models/product_model.dart';

class FetchProducts extends Notifier<Future<List>> {

  Future<Database> get database async{
    return openDatabase(
      join(await getDatabasesPath(), 'products.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE products(id INTEGER PRIMARY KEY, name TEXT, date TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertProduct(Product product) async {
    final db = await database;
    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Product>> getProducts() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('products');

    return List.generate(maps.length, (i) {
      return Product(
        maps[i]['id'],
        maps[i]['name'],
        maps[i]['date'],
      );
    });
  }

  Future<void> updateProduct(Product product) async {
    final db = await database;

    await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<void> deleteProduct(int id) async {
    final db = await database;

    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List> build() async {
    return getProducts();
  }

  Future<void> confirmEdit(List list) async {
    final products = await getProducts();
    for (Product product in products){
      if (!list.contains(product)){
        deleteProduct(product.id);
      }
    }
    for (Product product in list){
      insertProduct(product);
    }
    state = getProducts();
  }
}

final fetchProductsProvider = NotifierProvider<FetchProducts, Future<List>>(() {
  return FetchProducts();
});
