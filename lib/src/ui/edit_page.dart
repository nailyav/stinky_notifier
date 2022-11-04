import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifier/src/application/fetch_products.dart';

import '../models/product_model.dart';
import 'edit_products_table.dart';


final productNameProvider = StateProvider<String>((ref) => "");
final dateProvider = StateProvider<String>((ref) => "");

class EditPage extends ConsumerWidget {
  const EditPage(this.products, {super.key});

  final List products;

  int getId(List list) {
    int id = 1;
    while ((list.singleWhere((e) => e.id == id,
        orElse: () => false)) != false) {
      id++;
    }
    return id;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List edit = products;

    return Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Edit'),
          ),
          actions: <Widget>[
            IconButton(
                icon: const Icon(
                  Icons.check,
                ),
                onPressed: () {
                  ref.read(fetchProductsProvider.notifier).confirmEdit(edit);
                  ref.read(fetchProductsProvider).then((data){print(data);});
                }
            ),
          ],
        ),
        body: Center(
          child: getEditTable(ref),
        ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add'),
        icon: const Icon(
          Icons.add,
          size: 24.0,
        ),
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Add new product'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter product name',
                ),
                onChanged: (text) {
                  ref.read(productNameProvider.notifier).state = text;
                },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Enter expiration date',
                  ),
                  onChanged: (text) {
                    ref.read(dateProvider.notifier).state = text;
                  },
                ),
              ]
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => {
                  Navigator.pop(context),
                },
                // TODO make the table recompile when added new product
                // TODO сбросить editProducts при отмене сохраниения при возвращении на home page
                // TODO первая добавленная штука сохраняется в main products почему?
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.pop(context),

                  edit.add(Product(
                      getId(edit), ref.watch(productNameProvider.notifier).state, ref.watch(dateProvider.notifier).state)),
                  // build(context, ref),
                },
                child: const Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
