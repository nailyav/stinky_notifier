import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final themeProvider = StateProvider<bool>((ref) => true);

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final light = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
          title: const Center(
        child: Text('Settings'),
      )),
      body: Center(
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SwitchListTile(
                    title: Text('Theme', style: Theme.of(context).textTheme.bodyText2,),
                    // for light theme
                    activeColor: const Color(0xfffedbd0),
                    activeTrackColor: const Color(0xfffeeae6),
                    // for dark theme
                    inactiveThumbColor: Colors.grey.shade600,
                    inactiveTrackColor: Colors.grey.shade400,
                    value: light,
                    onChanged: (toggle){
                      ref.read(themeProvider.notifier).state = toggle;
                    },
                    // secondary: const Icon(Icons.wb_sunny),
                ),
              ),
              Image.network('https://http.cat/200'),
            ],
          ),
        ),
      ),
    );
  }
}
