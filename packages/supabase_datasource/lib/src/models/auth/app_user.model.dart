import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase/supabase.dart';

part 'app_user.model.freezed.dart';

part 'app_user.model.g.dart';

@freezed
@JsonSerializable()
class AppUserModel with _$AppUserModel {
  AppUserModel({
    required this.id,
    required this.email,
    this.username,
    this.avatarUrl,
    this.createdAt,
  });

  final String id;
  final String email;
  final String? username;
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  factory AppUserModel.fromJson(Map<String, dynamic> json) =>
      _$AppUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserModelToJson(this);

  static AppUserModel fromSupabaseUser(User supabaseUser) {
    return AppUserModel(
      id: supabaseUser.id,
      email: supabaseUser.email ?? '',
      username: supabaseUser.userMetadata?['username'] as String?,
      avatarUrl: supabaseUser.userMetadata?['avatar_url'] as String?,
      createdAt: supabaseUser.createdAt,
    );
  }
}
