// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cinema_hall_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CinemaHall _$CinemaHallFromJson(Map<String, dynamic> json) => CinemaHall(
      id: (json['id'] as num).toInt(),
      hallNum: (json['hallNum'] as num).toInt(),
      cinemaId: (json['cinemaId'] as num).toInt(),
    );

Map<String, dynamic> _$CinemaHallToJson(CinemaHall instance) =>
    <String, dynamic>{
      'id': instance.id,
      'hallNum': instance.hallNum,
      'cinemaId': instance.cinemaId,
    };
