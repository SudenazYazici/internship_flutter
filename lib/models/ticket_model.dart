import 'package:json_annotation/json_annotation.dart';

part 'ticket_model.g.dart';

@JsonSerializable()
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

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);

  Map<String, dynamic> toJson() => _$TicketToJson(this);
}
