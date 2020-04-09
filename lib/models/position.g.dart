// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Position _$PositionFromJson(Map<String, dynamic> json) {
  return Position(
    json['geohash'] as String,
    Position._geoFromJson(json['geopoint'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PositionToJson(Position instance) => <String, dynamic>{
      'geohash': instance.geohash,
      'geopoint': Position._geoToJson(instance.geopoint),
    };
