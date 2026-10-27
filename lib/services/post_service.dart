import 'dart:convert';

import 'package:flutter_infinite_listview/models/post_page.dart';
import 'package:http/http.dart' as http;

class PostService {
  static const int pageSize = 20;

  Future<PostPage> fetchPage({required int skip}) async {
    final Uri uri = Uri.https("dummyjson.com", "/posts", {
      "limit": "$pageSize",
      "skip": "$skip",
      "select": "title,body",
    });
    final http.Response response = await http.get(uri);
    if (response.statusCode != 200) {
      throw http.ClientException(
        "Unexpected status ${response.statusCode}",
        uri,
      );
    }
    return PostPage.fromJson(
      json.decode(response.body) as Map<String, dynamic>,
    );
  }
}
