import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.model.freezed.dart';

part 'profile.model.g.dart';

@freezed
@JsonSerializable()
class ProfileModel with _$ProfileModel {
  ProfileModel({
    required this.userId,
    this.username,
    this.displayName,
    this.avatarUrl,
    this.bio,
    this.statusMessage,
    this.lastSeenAt,
    this.createdAt,
    this.updatedAt,
  });

  @JsonKey(name: 'user_id')
  final String userId;
  final String? username;
  @JsonKey(name: 'display_name')
  final String? displayName;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  final String? bio;
  @JsonKey(name: 'status_message')
  final String? statusMessage;
  @JsonKey(name: 'last_seen_at')
  final String? lastSeenAt;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
