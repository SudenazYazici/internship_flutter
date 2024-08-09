// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Seat _$SeatFromJson(Map<String, dynamic> json) => Seat(
      id: (json['id'] as num).toInt(),
      seatNum: (json['seatNum'] as num).toInt(),
      cinemaHallId: (json['cinemaHallId'] as num).toInt(),
    );

Map<String, dynamic> _$SeatToJson(Seat instance) => <String, dynamic>{
      'id': instance.id,
      'seatNum': instance.seatNum,
      'cinemaHallId': instance.cinemaHallId,
    };
