import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../application/fetch_products.dart';


class ProductDataSource extends DataGridSource {
  ProductDataSource(this.products) {
    _products = products.map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<int>(columnName: 'id', value: e.id),
      DataGridCell<String>(columnName: 'name', value: e.name),
      DataGridCell<String>(columnName: 'date', value: e.date),
      const DataGridCell<Icon>(columnName: 'delete', value: Icon(Icons.delete)),
    ])).toList();
  }

  List products;
  List<DataGridRow> _products = [];

  @override
  List<DataGridRow> get rows =>  _products;

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
              products.removeWhere((element) => element.id == row.getCells()[0].value);
            },
          )
              : Text(dataGridCell.value.toString()),
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
    } else if (column.columnName == 'name') {
      rows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'name', value: newCellValue);
      products[dataRowIndex].name = newCellValue.toString();
    } else if (column.columnName == 'date') {
      rows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'date', value: newCellValue);
      products[dataRowIndex].date = newCellValue.toString();
    }
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
        .getCells()
        .firstWhere((DataGridCell dataGridCell) =>
    dataGridCell.columnName == column.columnName)
        .value
        ?.toString() ??
        '';

    newCellValue = null;

    final bool isNumericType = column.columnName == 'id';

    return Container(
      padding: const EdgeInsets.all(8.0),
      // alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        // textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
        ),
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

FutureBuilder getEditTable(ref){
  // late ProductDataSource productDataSource;
  // List products = [];
  final edit = ref.watch(fetchProductsProvider);
  // edit.then((data) {
  //   products = data;
  // });
  // productDataSource = ProductDataSource(products);

  return FutureBuilder<List<dynamic>>(
      future: edit,
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {

          late ProductDataSource productDataSource;
          final data = snapshot.data as List;
          productDataSource = ProductDataSource(data);

          return Expanded(
            child: SfDataGrid(
              source: productDataSource,
              allowEditing: true,
              selectionMode: SelectionMode.single,
              navigationMode: GridNavigationMode.cell,
              columns: <GridColumn> [
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
                    width: 130,
                    label: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.centerRight,
                        child: const Text('Date'))),
                GridColumn(
                    columnName: 'delete',
                    allowEditing: false,
                    width: 80,
                    label: Container(
                        padding: const EdgeInsets.all(16.0),
                        alignment: Alignment.centerRight,
                        child: const Text('Delete'))),
              ],
            ),
          );
        }
        return const CircularProgressIndicator();
      }
  );
}
