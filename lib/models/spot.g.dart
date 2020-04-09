// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Spot _$SpotFromJson(Map<String, dynamic> json) {
  return Spot(
    json['id'] as String,
    json['name'] as String,
    json['about'] as String,
    json['category'] as String,
    json['location'] as String,
    json['pinColor'] as String,
    json['image'] as String,
    (json['comments'] as List)
        ?.map((e) =>
            e == null ? null : Comment.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['position'] as Map<String, dynamic>,
    json['userId'] as String,
  );
}

Map<String, dynamic> _$SpotToJson(Spot instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'about': instance.about,
      'category': instance.category,
      'location': instance.location,
      'pinColor': instance.pinColor,
      'image': instance.image,
      'comments': Spot.commentsToJson(instance.comments),
      'position': instance.position,
      'userId': instance.userId,
    };
