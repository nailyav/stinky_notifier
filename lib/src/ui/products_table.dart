import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../application/fetch_products.dart';

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
          child: Text(dataGridCell.value.toString()),
        );
      }).toList(),
    );
  }
}

Expanded getTable(List products, ref) {
  late ProductDataSource productDataSource;
  final edit = ref.watch(fetchProductsProvider);
  edit.then((data) {
    products = data;
  });
  productDataSource = ProductDataSource(products);

  return Expanded(
    child: SfDataGrid(
      source: productDataSource,
      allowEditing: true,
      selectionMode: SelectionMode.single,
      navigationMode: GridNavigationMode.cell,
      columns: <GridColumn>[
        GridColumn(
            columnName: 'id',
            allowEditing: false,
            label: Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.centerRight,
                child: const Text('ID'))),
        GridColumn(
            columnName: 'name',
            label: Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.centerLeft,
                child: const Text('Name'))),
        GridColumn(
            columnName: 'date',
            width: 200,
            label: Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.centerRight,
                child: const Text('Date'))),
      ],
    ),
  );
}
