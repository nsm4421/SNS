import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sns/core/constant/user_profile.constant.dart';

part 'sign_up_request.model.g.dart';

part 'sign_up_request.model.freezed.dart';

@freezed
@JsonSerializable()
class SignUpRequestModel with _$SignUpRequestModel {
  final String username;
  final String email;
  final String password;
  final Sex? sex;
  final String? description;

  SignUpRequestModel({
    required this.email,
    required this.username,
    required this.password,
    this.sex,
    this.description = '',
  });

  factory SignUpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpRequestModelFromJson(json);
}
