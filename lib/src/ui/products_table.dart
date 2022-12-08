import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

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
          child: Text(dataGridCell.value.toString(), softWrap: true,),
        );
      }).toList(),
    );
  }
}


FutureBuilder getTable(ref) {
  final products = ref.watch(fetchProductsProvider);

  return FutureBuilder<List<dynamic>>(
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
                          'Name',
                          style: Theme.of(context).textTheme.button,
                          softWrap: true,))),
                GridColumn(
                    columnName: 'date',
                    width: 200,
                    label: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Date',
                          style: Theme.of(context).textTheme.button,
                          softWrap: true,
                        )
                    )
                ),
              ],
            ),
          );
        }
        return Image.network('https://http.cat/102');
      });
}