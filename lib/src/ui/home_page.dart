import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notifier/src/ui/products_table.dart';
import 'package:notifier/src/ui/settings_page.dart';
import 'package:notifier/src/application/fetch_products.dart';
import '../application/edit_products.dart';
import 'edit_page.dart';

// class MyHomePage extends ConsumerWidget {
//   const MyHomePage({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final products = ref.watch(fetchProductsProvider);
//
//     return FutureBuilder<List<dynamic>>(
//         future: products,
//         builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
//           if (snapshot.hasData) {
//             final data = snapshot.data as List;
//             return Scaffold(
//               appBar: AppBar(
//                 title: const Text('Stinky Notifier'),
//                 actions: <Widget>[
//                   IconButton(
//                       icon: const Icon(
//                         Icons.settings,
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: ((context) => const SettingsPage()),
//                           ),
//                         );
//                       }),
//                 ],
//               ),
//               body: Center(
//                 child: getTable(ref),
//               ),
//               floatingActionButton: FloatingActionButton.extended(
//                 label: Text('Edit', style: Theme
//                     .of(context)
//                     .textTheme
//                     .button),
//                 icon: Icon(
//                   Icons.edit,
//                   size: 24.0,
//                   color: Theme
//                       .of(context)
//                       .colorScheme
//                       .onPrimary,
//                 ),
//                 onPressed: () {
//                   ref.watch(fetchProductsProvider).then((value) => ref.read(editProductsProvider.notifier).writeProducts(value));
//                   print("products: ${data.length}");
//                   Navigator.of(context).push(
//                     MaterialPageRoute(builder: (context) => const EditPage()),
//                   );
//                 },
//               ),
//             );
//           }
//           return const CircularProgressIndicator();
//         }
//     );
//   }
// }


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
        child: getTable(ref),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Edit', style: Theme.of(context).textTheme.button),
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
