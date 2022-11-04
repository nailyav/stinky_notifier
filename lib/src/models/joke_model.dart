import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


@JsonSerializable()
class Joke {
  final String iconUrl;
  final String id;
  final String url;
  final String value;
  bool isFavourite = false;

  Joke(this.iconUrl, this.id, this.url, this.value);

  Joke.fromJson(Map<String, dynamic> json)
      : iconUrl = json['icon_url'],
        id = json['id'],
        url = json['url'],
        value = json['value'];

  Map<String, dynamic> toJson() => {
    'icon_url' : iconUrl,
    'id' : id,
    'url' : url,
    'value' : value
  };

// factory Joke.fromJson(Map<String, dynamic> json) => _$Joke(json);
// Map<String, dynamic> toJson() => _$Joke(this);
}

final jokeProvider = Provider<Joke>((ref) {
  throw UnimplementedError();
});