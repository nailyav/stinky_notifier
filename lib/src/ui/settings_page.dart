import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/fetch_joke.dart';
import '../models/joke_model.dart';

final themeProvider = StateProvider<bool>((ref) => true);

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final joke = ref.watch(callApiProvider);
    final light = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
          title: const Center(
        child: Text('Jokes with Chuck Norris'),
      )),
      body: Center(
        child: SafeArea(
          bottom: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding:
                    EdgeInsets.only(left: 60, bottom: 10, right: 60, top: 0),
              ),
              FutureBuilder<Joke>(
                future: joke,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(snapshot.data!.value,
                          style: const TextStyle(fontSize: 15),
                          textAlign: TextAlign.center),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
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
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Next', style: Theme.of(context).textTheme.button),
        icon: Icon(
            Icons.arrow_forward_rounded,
            size: 24.0,
            color: Theme.of(context).colorScheme.onPrimary
        ),
        onPressed: () {
          ref.read(callApiProvider.notifier).call();
        },
      ),
    );
  }
}
