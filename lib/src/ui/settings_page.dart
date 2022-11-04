import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Settings'),
        )
      ),
      body: Center(
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Padding(
                padding:
                EdgeInsets.only(left: 60, bottom: 10, right: 60, top: 0),
                // child: Image(image: AssetImage('assets/icon.png')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
