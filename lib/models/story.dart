import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:may_be_clean/env/env.dart';

class Story {
  final int id;
  final String title;
  final String content;
  final String? picture;
  final String url;
  final DateTime createdAt;
  final DateTime updatedAt;

  Story({
    required this.id,
    required this.title,
    required this.content,
    this.picture,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      picture: json['picture'],
      url: json['url'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  static Future<List<Story>> getStories() async {
    final response = await http.get(
      Uri.parse('${ENV.apiEndpoint}/article'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        "Authorization": "Bearer test"
      },
    );

    if (response.statusCode == 200) {
      return json
          .decode(response.body)['articles']
          .map<Story>((json) => Story.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load stories');
    }
  }
}
