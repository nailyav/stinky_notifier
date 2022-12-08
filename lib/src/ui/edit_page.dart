import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import 'package:notifier/src/application/fetch_products.dart';
import '../application/edit_products.dart';
import '../models/product_model.dart';
import 'edit_products_table.dart';

final productNameProvider = StateProvider<String>((ref) => "");
final dateProvider = StateProvider<String>((ref) => DateFormat('dd/MM/yyyy').format(DateTime.now()));

class EditPage extends ConsumerWidget {
  const EditPage({super.key});

  int getId(List list) {
    int id = 1;
    while (list.map((e) => e.id).contains(id)) {
      id++;
    }
    return id;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = ref.watch(editProductsProvider);
    final products = ref.watch(fetchProductsProvider);
    edit.then((value) => print("edit: ${value.length}"));
    products.then((value) => print("edit: ${value.length}"));
    final format = DateFormat("yyyy-MM-dd");

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => {
            Navigator.of(context).pop(),
            products.then((value) =>  ref.read(editProductsProvider.notifier).writeProducts(value),)
          }
        ),
        title: const Center(
          child: Text('Edit'),
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(
                Icons.check,
              ),
              onPressed: () {
                edit.then((data) => ref.read(fetchProductsProvider.notifier).confirmEdit(data));
              }),
        ],
      ),
      body: Center(
        child: getEditTable(ref),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add', style: Theme.of(context).textTheme.button),
        icon: Icon(
          Icons.add,
          size: 24.0,
          color: Theme.of(context).colorScheme.onPrimary
        ),
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Add new product', style: Theme.of(context).textTheme.headline6),
            content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter product name',
                ),
                onChanged: (text) {
                  ref.read(productNameProvider.notifier).state = text;
                },
              ),
              DateTimeField(
                format: format,
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                      context: context,
                      firstDate: DateTime(2022),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2033));
                },
                validator: (date) => date == null ? 'Invalid date' : null,
                initialValue: DateTime.now(),
                onChanged: (date) {
                  ref.read(dateProvider.notifier).state = DateFormat('dd/MM/yyyy').format(date!);
                },
                onSaved: (date) {
                  ref.read(dateProvider.notifier).state = DateFormat('dd/MM/yyyy').format(date!);
                },
              ),
            ]),
            actions: <Widget>[
              TextButton(
                onPressed: () => {
                  Navigator.pop(context),
                },
                // TODO сбросить editProducts при отмене сохраниения при возвращении на home page
                child: Text('Cancel', style: Theme.of(context).textTheme.button),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.pop(context),
                  edit.then((data) => ref.read(editProductsProvider.notifier).addProductJson(
                      Product(
                          getId(data),
                          ref.watch(productNameProvider.notifier).state,
                          ref.watch(dateProvider.notifier).state)
                  )),
                // ref.read(productNameProvider.notifier).state = '',
                },
                child: Text('Add', style: Theme.of(context).textTheme.button),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
