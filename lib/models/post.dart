class Post {
  final String title;
  final String body;

  const Post(this.title, this.body);

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      json["title"],
      json["body"],
    );
  }

  static List<Post> parseList(List<dynamic> list) {
    return list.map((i) => Post.fromJson(i)).toList();
  }
}
