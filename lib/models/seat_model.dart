import 'package:json_annotation/json_annotation.dart';

part 'seat_model.g.dart';

@JsonSerializable()
class Seat {
  final int id;
  final int seatNum;
  final int cinemaHallId;

  Seat({
    required this.id,
    required this.seatNum,
    required this.cinemaHallId,
  });

  factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);

  Map<String, dynamic> toJson() => _$SeatToJson(this);
}
