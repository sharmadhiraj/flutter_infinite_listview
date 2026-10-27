import 'package:flutter_infinite_listview/models/post.dart';

class PostPage {
  final List<Post> posts;
  final int total;

  const PostPage({required this.posts, required this.total});

  factory PostPage.fromJson(Map<String, dynamic> json) {
    return PostPage(
      posts: Post.parseList(json["posts"]),
      total: json["total"] as int,
    );
  }
}
