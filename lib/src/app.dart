import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:notifier/src/ui/home_page.dart';
import 'package:notifier/src/ui/settings_page.dart';

const MaterialColor pinkColor = MaterialColor(
  0xfffedbd0,
  <int, Color>{
    50: Color(0xfffeeae6),
    100: Color(0xfffedbd0),
    200: Color(0xfffedbd0),
    300: Color(0xfffbb8ac),
    400: Color(0xfffffbfa),
    500: Color(0xffffffff),
    600: Color(0xffc5032b),
    700: Color(0xfffedbd0),
    800: Color(0xffC18378),
    900: Color(0xff442c2e),
  },
);

const MaterialColor darkPinkColor = MaterialColor(
  0xff212121,
  <int, Color>{
    50: Color(0xff212121),
    100: Color(0xFF303030),
    200: Color(0xff424242),
    300: Color(0xffbb86fc),
    400: Color(0xffc5032b),
    500: Color(0xfffffbfa),
    600: Color(0xff212121),
    700: Color(0xff212121),
    800: Color(0xff212121),
    900: Color(0xff212121),
  },
);

ThemeData _darkTheme = ThemeData(
  // scaffoldBackgroundColor: const Color(0xFF303030),
  // brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSwatch(primarySwatch: darkPinkColor).copyWith(
    // primary: const Color(0xff212121),
    secondary: const Color(0xffbb86fc), // for buttons
    onPrimary: const Color(0xfffffbfa), // for icons
    onSecondary: const Color(0xff424242), // for table heading
    error: const Color(0xffc5032b),
    brightness: Brightness.dark,
  ),
  textTheme: const TextTheme(
    bodyText2: TextStyle(color: Color(0xfffffbfa)),
    button: TextStyle(color: Color(0xfffffbfa)),
    headline6: TextStyle(color: Color(0xfffffbfa)),
  ),
);

ThemeData _lightTheme = ThemeData(
  scaffoldBackgroundColor: const Color(0xfffffbfa),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: pinkColor).copyWith(
      // primary: const Color(0xfffedbd0),
      secondary: const Color(0xfffeeae6), // for buttons
      onPrimary: const Color(0xff442c2e), // for icons
      onSecondary: const Color(0xfffeeae6), // for table heading
      error: const Color(0xffc5032b),
      brightness: Brightness.light),
  textTheme: const TextTheme(
    bodyText2: TextStyle(color: Color(0xff442c2e)),
    button: TextStyle(color: Color(0xff442c2e)),
    headline6: TextStyle(color: Color(0xff442c2e)),
  ),
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final light = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Stinky Notifier',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        // GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('kk', ''),
      ],
      theme: light ? _lightTheme : _darkTheme,
      home: const MyHomePage(),
    );
  }
}
