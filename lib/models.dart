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
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
      'address': address,
    };
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
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'details': details,
    };
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

class Ticket {
  final int id;
  final int cinemaId;
  final String movieName;
  final DateTime date;
  final int price;

  Ticket(
      {required this.id,
      required this.cinemaId,
      required this.movieName,
      required this.date,
      required this.price});

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      cinemaId: json['cinemaId'],
      movieName: json['movieName'],
      date: DateTime.parse(json['date']),
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cinemaId': cinemaId,
      'movieName': movieName,
      'date': date,
      'price': price,
    };
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String password;
  final DateTime birthdate;
  final String role;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.birthdate,
      required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      birthdate: json['birthdate'] != null
          ? DateTime.parse(json['birthdate'])
          : DateTime.now(),
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'birthdate': birthdate,
      'role': role,
    };
  }
}
