import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'position.g.dart';

@JsonSerializable()
class Position {
  String geohash;
  @JsonKey(fromJson: _geoFromJson, toJson: _geoToJson)
  GeoPoint geopoint;

  Position(this.geohash, this.geopoint);
  factory Position.fromJson(Map<String, dynamic> json) => _$PositionFromJson(json);
  Map<String, dynamic> toJson() => _$PositionToJson(this);

  static GeoPoint _geoFromJson(Map<String, dynamic> geo) {
    return GeoPoint(geo['latitude'], geo['longitude']);
  }

  static Map<String, dynamic> _geoToJson(GeoPoint geo) => <String, dynamic>{
    'latitude': geo.latitude,
    'longitude': geo.longitude
  };
}