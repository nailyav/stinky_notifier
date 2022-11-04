import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/joke_model.dart';


Future<Joke> fetchJoke() async {
  final response =
  await http.get(Uri.parse('https://api.chucknorris.io/jokes/random'));

  if (response.statusCode == 200) {
    return Joke.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load the joke');
  }
}

class CallApi extends Notifier<Future<Joke>>{

  @override
  Future<Joke> build() {
    return fetchJoke();
  }

  void call() {
    state = fetchJoke();
  }
}

final callApiProvider = NotifierProvider<CallApi, Future<Joke>>(() {
  return CallApi();
});
