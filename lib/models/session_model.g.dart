// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      id: (json['id'] as num).toInt(),
      cinemaId: (json['cinemaId'] as num).toInt(),
      cinemaHallId: (json['cinemaHallId'] as num).toInt(),
      movieId: (json['movieId'] as num).toInt(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      durationInMinutes: (json['durationInMinutes'] as num).toInt(),
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'id': instance.id,
      'cinemaId': instance.cinemaId,
      'cinemaHallId': instance.cinemaHallId,
      'movieId': instance.movieId,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'durationInMinutes': instance.durationInMinutes,
    };
