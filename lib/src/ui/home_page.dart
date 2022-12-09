import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:notifier/src/ui/settings_page.dart';
import 'package:notifier/src/application/fetch_products.dart';
import '../application/edit_products.dart';
import 'edit_page.dart';

class ProductDataSource extends DataGridSource {
  ProductDataSource(this.products) {
    _products = products
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<int>(columnName: 'id', value: e.id),
      DataGridCell<String>(columnName: 'name', value: e.name),
      DataGridCell<String>(columnName: 'date', value: e.date),
    ]))
        .toList();
  }

  List products;
  List<DataGridRow> _products = [];

  @override
  List<DataGridRow> get rows => _products;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: dataGridCell.columnName == 'name'
              ? Alignment.centerLeft
              : Alignment.centerRight,
          padding: const EdgeInsets.all(16.0),
          child: Text(dataGridCell.value.toString(), softWrap: true,),
        );
      }).toList(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(fetchProductsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stinky Notifier'),
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
              }),
        ],
      ),
      body: Center(
        // child: getTable(ref),
          child: FutureBuilder<List<dynamic>>(
              future: products,
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasData) {
                  late ProductDataSource productDataSource;
                  final data = snapshot.data as List;
                  productDataSource = ProductDataSource(data);

                  return SfDataGridTheme(
                    data: SfDataGridThemeData(
                      headerColor: Theme.of(context).colorScheme.onSecondary,
                    ),
                    child: SfDataGrid(
                      // TODO change row text color to  style: Theme.of(context).textTheme.button
                      source: productDataSource,
                      onQueryRowHeight: (details) {
                        return details.getIntrinsicRowHeight(details.rowIndex);
                      },
                      columnWidthMode: ColumnWidthMode.fill,
                      navigationMode: GridNavigationMode.cell,
                      columns: <GridColumn>[
                        GridColumn(
                            columnName: 'id',
                            allowEditing: false,
                            label: Container(
                                padding: const EdgeInsets.all(16.0),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'ID',
                                  style: Theme.of(context).textTheme.button,
                                  softWrap: true,))),
                        GridColumn(
                            columnName: 'name',
                            label: Container(
                                padding: const EdgeInsets.all(16.0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppLocalizations.of(context)!.name,
                                  style: Theme.of(context).textTheme.button,
                                  softWrap: true,))),
                        GridColumn(
                            columnName: 'date',
                            width: 200,
                            label: Container(
                                padding: const EdgeInsets.all(16.0),
                                alignment: Alignment.centerRight,
                                child: Text(
                                  AppLocalizations.of(context)!.expirationDate,
                                  style: Theme.of(context).textTheme.button,
                                  softWrap: true,
                                )
                            )
                        ),
                      ],
                    ),
                  );
                }
                return const CircularProgressIndicator();
              }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(AppLocalizations.of(context)!.edit, style: Theme.of(context).textTheme.button),
        icon: Icon(
          Icons.edit,
          size: 24.0,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        onPressed: () {
          products.then((value) => {
            ref.read(editProductsProvider.notifier).writeProducts(value),
            print("products: ${value.length}"),
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const EditPage()),
            )
          });
        },
      ),
    );
  }
}
