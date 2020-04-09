import 'package:maps/models/comment.dart';
import 'package:maps/models/position.dart';
import 'package:json_annotation/json_annotation.dart';

part 'spot.g.dart';

@JsonSerializable()
class Spot {
  String id;
  String name;
  String about;
  String category;
  String location;
  String pinColor;
  String image;
  @JsonKey(toJson: commentsToJson)
  List<Comment> comments;
  Map<String, dynamic> position;
  String userId;

  Spot(this.id, this.name, this.about, this.category, this.location, this.pinColor, this.image,
      this.comments, this.position, this.userId);
  factory Spot.fromJson(Map<String, dynamic> json) => _$SpotFromJson(json);
  Map<String, dynamic> toJson() => _$SpotToJson(this);

  static commentsToJson(List<Comment> comments) {
    return comments.map((comment) => comment.toJson()).toList();
  }

  static positionToJson(Position position) {
    return position.toJson();
  }
}
