class Session {
  final int id;
  final int cinemaId;
  final int cinemaHallId;
  final int movieId;
  final DateTime startDate;
  final DateTime endDate;
  final int durationInMinutes;

  Session({
    required this.id,
    required this.cinemaId,
    required this.cinemaHallId,
    required this.movieId,
    required this.startDate,
    required this.endDate,
    required this.durationInMinutes,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['id'],
      cinemaId: json['cinemaId'],
      cinemaHallId: json['cinemaHallId'],
      movieId: json['movieId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      durationInMinutes: json['durationInMinutes'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cinemaId': cinemaId,
      'cinemaHallId': cinemaHallId,
      'movieId': movieId,
      'startDate': startDate,
      'endDate': endDate,
      'durationInMinutes': durationInMinutes,
    };
  }
}
