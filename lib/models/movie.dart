class Movie {
  final int id;
  final String title;
  final String poster;
  final String description;
  final String trailer;
  final int duration; // durasi film

  Movie({
    required this.id,
    required this.title,
    required this.poster,
    required this.description,
    required this.trailer,
    required this.duration,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: int.parse(json['id'].toString()),
      title: json['title'] ?? '',
      poster: json['poster'] ?? '',
      description: json['description'] ?? '',
      trailer: json['trailer'] ?? '',
      duration: int.parse(json['duration'].toString()),
    );
  }
}
