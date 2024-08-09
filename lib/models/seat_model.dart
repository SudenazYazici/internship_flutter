class Seat {
  final int id;
  final int seatNum;
  final int cinemaHallId;

  Seat({
    required this.id,
    required this.seatNum,
    required this.cinemaHallId,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      id: json['id'],
      seatNum: json['seatNum'],
      cinemaHallId: json['cinemaHallId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'seatNum': seatNum,
      'cinemaHallId': cinemaHallId,
    };
  }
}
