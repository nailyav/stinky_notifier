import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;

import '../application/edit_products.dart';

class ProductDataSource extends DataGridSource {
  ProductDataSource(this.products, this.ref) {
    _products = products
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'name', value: e.name),
              DataGridCell<String>(columnName: 'date', value: e.date),
              const DataGridCell<Icon>(
                  columnName: 'delete', value: Icon(Icons.delete)),
            ]))
        .toList();
  }

  WidgetRef ref;
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
              : dataGridCell.columnName == 'delete'
                  ? Alignment.center
                  : Alignment.centerRight,
          padding: const EdgeInsets.all(16.0),
          child: (dataGridCell.columnName == 'delete')
              ? IconButton(
                  icon: dataGridCell.value,
                  onPressed: () {
                    products.removeWhere(
                        (element) => element.id == row.getCells()[0].value);
                    ref.read(editProductsProvider.notifier).writeProducts(products);
                  },
                )
              : Text(dataGridCell.value.toString(), softWrap: true,),
        );
      }).toList(),
    );
  }

  dynamic newCellValue;

  TextEditingController editingController = TextEditingController();

  @override
  void onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhere((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            .value ??
        '';

    final int dataRowIndex = rows.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }

    if (column.columnName == 'id') {
      rows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'id', value: newCellValue);
      products[dataRowIndex].id = newCellValue as int;
      ref.read(editProductsProvider.notifier).writeProducts(products);
    } else if (column.columnName == 'name') {
      rows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'name', value: newCellValue);
      products[dataRowIndex].name = newCellValue.toString();
      ref.read(editProductsProvider.notifier).writeProducts(products);
    } else if (column.columnName == 'date') {
      rows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'date', value: newCellValue);
      products[dataRowIndex].date = newCellValue.toString();
      ref.read(editProductsProvider.notifier).writeProducts(products);
    }
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    final String displayText = dataGridRow
            .getCells()
            .firstWhere((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            .value?.toString() ?? '';

    newCellValue = null;

    final bool isNumericType = column.columnName == 'id';

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
        ),
        // TODO open date picker when edited
        keyboardType: isNumericType ? TextInputType.number : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = int.parse(value);
            } else {
              newCellValue = value;
            }
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          submitCell();
        },
      ),
    );
  }
}

FutureBuilder getEditTable(ref) {
  final edit = ref.watch(editProductsProvider);

  return FutureBuilder<List<dynamic>>(
      future: edit,
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          late ProductDataSource productDataSource;
          final data = snapshot.data as List;
          productDataSource = ProductDataSource(data, ref);

          return SfDataGridTheme(
                data: SfDataGridThemeData(
                  headerColor: Theme.of(context).colorScheme.onSecondary,
                ),
                child: SfDataGrid(
                  source: productDataSource,
                  onQueryRowHeight: (details) {
                    return details.getIntrinsicRowHeight(details.rowIndex);
                  },
                  columnWidthMode: ColumnWidthMode.fill,
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
                            child: Text(
                                'ID',
                                style: Theme.of(context).textTheme.button,
                                softWrap: true,
                            ))),
                    GridColumn(
                        columnName: 'name',
                        label: Container(
                            padding: const EdgeInsets.all(16.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                                'Name',
                                style: Theme.of(context).textTheme.button,
                                softWrap: true,
                            ))),
                    GridColumn(
                        columnName: 'date',
                        width: 130,
                        label: Container(
                            padding: const EdgeInsets.all(16.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                                'Date',
                                style: Theme.of(context).textTheme.button,
                                softWrap: true,
                            ))),
                    GridColumn(
                        columnName: 'delete',
                        allowEditing: false,
                        width: 80,
                        label: Container(
                            padding: const EdgeInsets.all(16.0),
                            alignment: Alignment.centerRight,
                            child: Text(
                                'Delete',
                                style: Theme.of(context).textTheme.button,
                                softWrap: true,
                            ))),
                  ],
                ),

          );
        }
        return Image.network('https://http.cat/102');
        // return const CircularProgressIndicator();
      });
}
