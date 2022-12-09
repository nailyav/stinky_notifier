import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:notifier/src/ui/settings_page.dart';
import 'package:flutter/material.dart';

import 'http_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('getImage', () {
    // test('returns an Album if the http call completes successfully', () async {
    //   final client = MockClient();
    //   when(client
    //       .get(Uri.parse('https://http.cat/102.jpg')))
    //       .thenAnswer((_) async =>
    //       http.Response('{"userId": 1, "id": 2, "title": "mock"}', 200));
    //
    //   expect(0, 0);
    // });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      when(client
          .get(Uri.parse('https://http.cat/102.jpg')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(getImage(client), throwsException);
    });
  });
}