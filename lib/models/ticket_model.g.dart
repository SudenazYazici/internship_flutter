// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map<String, dynamic> json) => Ticket(
      id: (json['id'] as num).toInt(),
      cinemaId: (json['cinemaId'] as num).toInt(),
      movieName: json['movieName'] as String,
      date: DateTime.parse(json['date'] as String),
      price: (json['price'] as num).toInt(),
    );

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
      'id': instance.id,
      'cinemaId': instance.cinemaId,
      'movieName': instance.movieName,
      'date': instance.date.toIso8601String(),
      'price': instance.price,
    };
