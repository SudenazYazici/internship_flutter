class CinemaHall {
  final int id;
  final int hallNum;
  final int cinemaId;

  CinemaHall({
    required this.id,
    required this.hallNum,
    required this.cinemaId,
  });

  factory CinemaHall.fromJson(Map<String, dynamic> json) {
    return CinemaHall(
      id: json['id'],
      hallNum: json['hallNum'],
      cinemaId: json['cinemaId'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hallNum': hallNum,
      'cinemaId': cinemaId,
    };
  }
}
