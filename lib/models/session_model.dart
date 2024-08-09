import 'package:json_annotation/json_annotation.dart';

part 'session_model.g.dart';

@JsonSerializable()
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

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);
}
