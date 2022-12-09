import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:notifier/src/application/providers.dart';
import 'package:notifier/src/models/product_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test/test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


class IdListener extends Mock {
  void call(int? previous, int value);
}

class Listener extends Mock {
  void call(String? previous, String value);
}

void sqfliteTestInit() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
}

void main() {
  Product productModel;
  setUp(() {
    productModel = Product(0, 'milk', '07/12/2022');
  });

  WidgetsFlutterBinding.ensureInitialized();

  group('[Product Model]', () {
    test('[Model] Check individual values', () async {
      productModel = Product(
          0,
          'milk',
          '07/12/2022'
      );
      expect(productModel.name, 'milk');
      expect(productModel.id, 0);
      expect(productModel.date, '07/12/2022');
    });
  });

  sqfliteTestInit();
  group('[Providers]', () {
    test('[Initial id = 0]', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final listener = IdListener();
      container.listen<int>(
        idProvider,
        listener,
        fireImmediately: true,
      );
      verify(listener(null, 0)).called(1);
      verifyNoMoreInteractions(listener);

      final controller = container.read(idProvider.notifier);
      expect(controller.state, 0);
    });

    test('[Product name provider saves state]', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final listener = Listener();
      container.listen<String>(
        productNameProvider,
        listener,
        fireImmediately: true,
      );
      verify(listener(null, '')).called(1);
      verifyNoMoreInteractions(listener);

      final controller = container.read(productNameProvider.notifier);
      expect(controller.state, '');

      controller.state = 'milk';
      expect(controller.state, 'milk');
    });

    test('[Date provider saves state]', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final listener = Listener();
      container.listen<String>(
        productNameProvider,
        listener,
        fireImmediately: true,
      );
      verify(listener(null, '')).called(1);
      verifyNoMoreInteractions(listener);

      final controller = container.read(dateProvider.notifier);
      expect(controller.state, DateFormat('dd/MM/yyyy').format(DateTime.now()));
    });

    test('Database check', () async {
      var db = await openDatabase(inMemoryDatabasePath);
      await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY,
        name TEXT, 
        date TEXT
      )
      ''');
      await db.insert('products', <String, Object?>{'name': 'milk', 'date': '17/12/2022'});
      await db.insert('products', <String, Object?>{'name': 'fish soup', 'date': '12/12/2022'});

      var result = await db.query('products');
      expect(result, [
        {'id': 1, 'name': 'milk', 'date': '17/12/2022'},
        {'id': 2, 'name': 'fish soup', 'date': '12/12/2022'}
      ]);
      await db.close();
    });
  });
}