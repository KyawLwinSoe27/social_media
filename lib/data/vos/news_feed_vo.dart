import 'package:json_annotation/json_annotation.dart';
part 'news_feed_vo.g.dart';
@JsonSerializable()
class NewsFeedVO {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "description")
  String? description;

  @JsonKey(name: "profile_picture")
  String? profilePicture;

  @JsonKey(name: "post_image")
  String? postImage;

  @JsonKey(name: "user_name")
  String? userName;

  NewsFeedVO(
    this.id,
    this.description,
    this.profilePicture,
    this.postImage,
    this.userName,
  );

  factory NewsFeedVO.fromJson(Map<String,dynamic> json) => _$NewsFeedVOFromJson(json);
  Map<String,dynamic> toJson() => _$NewsFeedVOToJson(this);
}
