import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notifier/src/application/fetch_products.dart';
import 'package:notifier/src/ui/products_table.dart';
import 'package:notifier/src/ui/settings_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import 'edit_page.dart';

Future<String> getTime() async {
  String time;

  try {
    final response = await http
        .get(Uri.parse("http://worldtimeapi.org/api/timezone/Europe/Moscow"));
    Map<String, dynamic> data = jsonDecode(response.body);

    String datetime = data['datetime'];
    String offset = data['utc_offset'].substring(1, 3);

    DateTime now = DateTime.parse(datetime);
    now = now.add(Duration(hours: int.parse(offset)));

    time = DateFormat.jm().format(now);
    return time;
  } catch (e) {
    time = 'could not get time data';
    return time;
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(fetchProductsProvider);
    final time = getTime();
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
            future: time,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.toString());
              }
              return const CircularProgressIndicator();
            }),
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
        child: FutureBuilder<List<dynamic>>(
            future: products,
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data as List;
                return getTable(data, ref);
              }
              return const CircularProgressIndicator();
            }),
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
      ),
    );
  }
}
