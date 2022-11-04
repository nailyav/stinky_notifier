import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifier/src/application/fetch_products.dart';
import 'package:notifier/src/ui/products_table.dart';
import 'package:notifier/src/ui/settings_page.dart';

import 'edit_page.dart';


class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(fetchProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('StinkyPoop'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.settings,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) => const SettingsPage()),
                ),
              );
            }
          ),
        ],
      ),
      body: Center(
        child:
          FutureBuilder<List<dynamic>>(
              future: products,
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasData) {
                  final data = snapshot.data as List;
                  return getTable(data, ref);
                }
                return const CircularProgressIndicator();
              }
          ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Edit'),
        icon: const Icon(
          Icons.edit,
          size: 24.0,
        ),
        onPressed: () {
          products.then((data) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EditPage(data)),
            );
          });
        },
      )
    );
  }
}
