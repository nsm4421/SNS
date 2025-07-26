import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sns/core/constant/user_profile.constant.dart';

part 'edit_profile_request.model.g.dart';

part 'edit_profile_request.model.freezed.dart';

@freezed
@JsonSerializable()
class EditProfileRequestModel with _$EditProfileRequestModel {
  final String? username;
  final Sex? sex;
  final String? description;

  EditProfileRequestModel({this.username, this.sex, this.description});

  factory EditProfileRequestModel.fromJson(Map<String, dynamic> json) =>
      _$EditProfileRequestModelFromJson(json);
}
