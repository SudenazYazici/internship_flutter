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
