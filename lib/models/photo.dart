class Photo {
  final String title;
  final String thumbnailUrl;

  Photo(this.title, this.thumbnailUrl);

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      json["title"],
      json["thumbnailUrl"],
    );
  }

  static List<Photo> parseList(List<dynamic> list) {
    return list.map((i) => Photo.fromJson(i)).toList();
  }
}
