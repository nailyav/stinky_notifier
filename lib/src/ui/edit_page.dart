import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:notifier/src/application/fetch_products.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import '../models/product_model.dart';
import 'edit_products_table.dart';

final productNameProvider = StateProvider<String>((ref) => "");
final dateProvider = StateProvider<String>((ref) => DateFormat('dd/MM/yyyy').format(DateTime.now()));

class EditPage extends ConsumerWidget {
  const EditPage(this.products, {super.key});

  final List products;

  int getId(List list) {
    int id = 1;
    while (
        (list.singleWhere((e) => e.id == id, orElse: () => false)) != false) {
      id++;
    }
    return id;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List edit = products;
    final format = DateFormat("yyyy-MM-dd");

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
                // TODO make the table recompile when added new product
                // TODO сбросить editProducts при отмене сохраниения при возвращении на home page
                // TODO первая добавленная штука сохраняется в main products почему?
                child: Text('Cancel', style: Theme.of(context).textTheme.button),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.pop(context),

                  edit.add(Product(
                      getId(edit),
                      ref.watch(productNameProvider.notifier).state,
                      ref.watch(dateProvider.notifier).state)),
                  // build(context, ref),
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
