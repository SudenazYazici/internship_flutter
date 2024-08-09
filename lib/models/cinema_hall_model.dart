import 'package:json_annotation/json_annotation.dart';

part 'cinema_hall_model.g.dart';

@JsonSerializable()
class CinemaHall {
  final int id;
  final int hallNum;
  final int cinemaId;

  CinemaHall({
    required this.id,
    required this.hallNum,
    required this.cinemaId,
  });

  factory CinemaHall.fromJson(Map<String, dynamic> json) =>
      _$CinemaHallFromJson(json);

  Map<String, dynamic> toJson() => _$CinemaHallToJson(this);
}
