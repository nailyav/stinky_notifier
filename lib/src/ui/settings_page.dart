import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:animator/animator.dart';

final themeProvider = StateProvider<bool>((ref) => true);

Future<Image> getImage(http.Client client) async {
  try {
    final response = await client
      .get(Uri.parse('https://http.cat/102.jpg'));
      if (response.statusCode == 200) {
        return Image.network('https://http.cat/102.jpg');
      } else {
        throw Exception('Failed to load image');
      }
  }
  catch (e) {
    return Image.asset('assets/404.jpeg');
  }

}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final light = ref.watch(themeProvider);
    final image = getImage(http.Client());
    
    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text(AppLocalizations.of(context)!.settings),
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
                    title: Text(AppLocalizations.of(context)!.theme, style: Theme.of(context).textTheme.bodyText2,),
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
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Animator(
                tweenMap: {
                  "rotation": Tween<double>(begin: 0, end: 4 * 3.14),
                },
                cycles: 0,
                duration: const Duration(seconds: 2),
                builder: (context, anim, child) => Transform.rotate(
                  angle: anim.getValue('rotation'),
                  child:  FutureBuilder<Image>(
                    future: image,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data!;
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
