class Movie {
  final int id;
  final String name;
  final String details;

  Movie({
    required this.id,
    required this.name,
    required this.details,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      name: json['name'],
      details: json['details'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'details': details,
    };
  }
}
