class Cinema {
  final int id;
  final String name;
  final String city;
  final String address;

  Cinema({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
  });

  factory Cinema.fromJson(Map<String, dynamic> json) {
    return Cinema(
      id: json['id'],
      name: json['name'],
      city: json['city'],
      address: json['address'],
    );
  }
}

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
}

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
}

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
}

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
}
