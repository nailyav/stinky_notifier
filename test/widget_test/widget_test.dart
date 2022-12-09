import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:notifier/src/app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:notifier/src/ui/edit_page.dart' show EditPage;
import 'package:notifier/src/ui/home_page.dart';

Widget makeTestableWidget({ required Widget child }) {
  return MediaQuery(
    data: const MediaQueryData(),
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: child,
    ),
  );
}

Future<void> prepareDatePicker(
    WidgetTester tester,
    Future<void> Function(Future<DateTime?> date) callback, {
      TextDirection textDirection = TextDirection.ltr,
      bool useMaterial3 = false,
    }) async {
  await tester.pumpWidget(MaterialApp(
    theme: ThemeData(useMaterial3: useMaterial3),
    home: Material(
      child: Builder(
        builder: (BuildContext context) {
          return ElevatedButton(
            onPressed: () {
            },
            child: const Text('Go'),
          );
        },
      ),
    ),
  ));
}


void main() {
  group('Edit Page tests', ()
  {
    testWidgets('MyHomePage has a title', (tester) async {
      await tester.pumpWidget(const ProviderScope(child: MyApp()));
      final titleFinder = find.text('Stinky Notifier');
      expect(titleFinder, findsOneWidget);
    });

    testWidgets("Edit button exists and opens a dialog", (WidgetTester tester) async{
      await tester.pumpWidget(ProviderScope(child: makeTestableWidget(child: const EditPage())));
      await tester.pump();

      var findByText = find.byType(Text);
      expect(findByText.evaluate().isEmpty, false);

      var addButton = find.text("Add");
      expect(addButton, findsOneWidget);
      await tester.tap(addButton);

      await tester.pumpAndSettle();

      var alertDialog = find.byType(AlertDialog);
      expect(alertDialog, findsOneWidget);
    });

    testWidgets("Product name is saved", (WidgetTester tester) async{
      await tester.pumpWidget(ProviderScope(child: makeTestableWidget(child: const EditPage())));
      await tester.pump();

      await tester.tap(find.text("Add"));
      await tester.pumpAndSettle();

      var addNewProductText = find.text("Add new product");
      expect(addNewProductText, findsOneWidget);

      var textField = find.byType(TextFormField);
      expect(textField, findsOneWidget);

      var findText = find.text('Milk');
      await tester.enterText(textField, 'Milk');
      expect(findText, findsOneWidget);

      await tester.tap(find.descendant(of: find.byType(AlertDialog), matching: find.text("Add")));
      expect(findText, findsOneWidget);
    });

    testWidgets("Date picker works correctly", (WidgetTester tester) async{
      await tester.pumpWidget(ProviderScope(child: makeTestableWidget(child: const EditPage())));
      await tester.pump();

      await tester.tap(find.text("Add"));
      await tester.pumpAndSettle();

      var dateField = find.byType(DateTimeField);
      expect(dateField, findsOneWidget);

      await tester.tap(dateField);
      await prepareDatePicker(tester, (Future<DateTime?> date) async {
        await tester.tap(find.text('12'));
        await tester.tap(find.text('OK'));
        expect(await date, equals(DateTime(2022, DateTime.december, 12)));

        await tester.tap(find.descendant(of: find.byType(AlertDialog), matching: find.text("Add")));
        expect(await date, findsOneWidget);
      });
    });

    testWidgets("Product is saved to database", (WidgetTester tester) async{
      await tester.pumpWidget(ProviderScope(child: makeTestableWidget(child: const EditPage())));
      await tester.pump();

      await tester.tap(find.text("Add"));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'Milk');
      await tester.tap(find.descendant(of: find.byType(AlertDialog), matching: find.text("Add")));

      var iconCheck = find.byIcon(Icons.check);
      await tester.tap(iconCheck, warnIfMissed: false);
      expect(iconCheck, findsOneWidget);

      await tester.pumpWidget(ProviderScope(child: makeTestableWidget(child: const MyHomePage())));
      await tester.pump();

      expect(find.text('Milk'), findsOneWidget);
    });
  });
}