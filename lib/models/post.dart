class Post {
  final int id;
  final String title;
  final String body;

  const Post({required this.id, required this.title, required this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"] as int,
      title: json["title"] as String,
      body: json["body"] as String,
    );
  }

  static List<Post> parseList(dynamic list) {
    return (list as List<dynamic>)
        .map((item) => Post.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
