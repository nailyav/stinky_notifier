import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:notifier/src/application/providers.dart';
import 'package:notifier/src/ui/settings_page.dart';
import 'package:notifier/src/application/fetch_products.dart';
import '../application/edit_products.dart';
import 'edit_page.dart';
import '../services/local_notification_service.dart';
import 'package:animator/animator.dart';

class ProductDataSource extends DataGridSource {
  ProductDataSource(this.products, this.ref, this.service, this.context) {
    _products = products
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<int>(columnName: 'id', value: e.id),
      DataGridCell<String>(columnName: 'name', value: e.name),
      DataGridCell<String>(columnName: 'date', value: e.date),
      const DataGridCell<Icon>(
          columnName: 'notification', value: Icon(Icons.notifications_active_rounded)),
    ]))
        .toList();
  }

  BuildContext context;
  LocalNotificationService service;
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
              : Alignment.centerRight,
          padding: const EdgeInsets.all(16.0),
          child: (dataGridCell.columnName == 'notification')
              ? IconButton(
              icon: dataGridCell.value,
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.addNewProduct, style: Theme.of(context).textTheme.headline6),
                  content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        labelText: AppLocalizations.of(context)!.enterNotificationTime,
                      ),
                      onChanged: (seconds) {
                        ref.read(notificationTimeProvider.notifier).state = int.parse(seconds);
                      },
                    ),
                  ]),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => {
                        Navigator.pop(context),
                      },
                      child: Text(AppLocalizations.of(context)!.cancel, style: Theme.of(context).textTheme.button),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await service.showScheduledNotification(
                            id: 0,
                            title: AppLocalizations.of(context)!.notificationTitle,
                            body:  AppLocalizations.of(context)!.notificationBody + row.getCells()[1].value,
                            seconds: ref.read(notificationTimeProvider.notifier).state // * 3600 // but for sake of testing now it's seconds,
                        );
                      },
                      // },
                      child: Text(AppLocalizations.of(context)!.add, style: Theme.of(context).textTheme.button),
                    ),
                  ],
                ),
              ))
              : Text(dataGridCell.value.toString(), softWrap: true,),
        );
      }).toList(),
    );
  }
}


class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  late final LocalNotificationService service;

  @override
  void initState() {
    service = LocalNotificationService();
    service.initialize();
    listenToNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(fetchProductsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child:

            Animator<double>(
              tween: Tween<double>(begin: 0, end: 2 * 3.14),
              duration: const Duration(seconds: 2),
              repeats: 0,
              builder: (_, animationState, __) => Transform(
                transform: Matrix4.rotationY(animationState.value),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/poop.png',
                  width: 10,
                ),
              ),
            )
        ),
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
                  productDataSource = ProductDataSource(data, ref, service, context);

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
                            width: 140,
                            label: Container(
                                padding: const EdgeInsets.all(16.0),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  AppLocalizations.of(context)!.name,
                                  style: Theme.of(context).textTheme.button,
                                  softWrap: true,))),
                        GridColumn(
                            columnName: 'date',
                            width: 140,
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
                        GridColumn(
                            columnName: 'notification',
                            width: 80,
                            label: Container(
                                padding: const EdgeInsets.all(16.0),
                                alignment: Alignment.centerRight,
                                child: Text(AppLocalizations.of(context)!.notify,
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
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const EditPage()),
            )
          });
        },
      ),
    );
  }

  void listenToNotification() =>
      service.onNotificationClick.stream.listen(onNotificationListener);

  void onNotificationListener(String? payload) {
    if (payload != null && payload.isNotEmpty) {
    }
  }
}
