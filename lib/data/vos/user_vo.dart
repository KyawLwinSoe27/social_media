import 'package:json_annotation/json_annotation.dart';
part 'user_vo.g.dart';
@JsonSerializable()
class UserVO {
  @JsonKey(name: "id")
  String? id;

  @JsonKey(name: "user_name")
  String? userName;

  @JsonKey(name: "email")
  String? email;

  @JsonKey(name: "password")
  String? password;

  @JsonKey(name: "profile_picture")
  String? profilePicture;

  UserVO({
    this.id,
    this.userName,
    this.email,
    this.password,
    this.profilePicture,
  });

  factory UserVO.fromJson(Map<String,dynamic> json) => _$UserVOFromJson(json);
  Map<String,dynamic> toJson() => _$UserVOToJson(this);
}
