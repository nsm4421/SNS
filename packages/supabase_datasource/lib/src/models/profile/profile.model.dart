import 'package:supabase_datasource/src/models/supabase/database.dart';

class ProfileModel extends ProfilesRow {
  ProfileModel({
    required super.userId,
    required super.username,
    super.createdAt,
    super.displayName,
    super.avatarUrl,
    super.bio,
    super.statusMessage,
    super.lastSeenAt,
    super.updatedAt,
  });

  factory ProfileModel.fromRow(ProfilesRow row) {
    return ProfileModel(
      userId: row.userId,
      username: row.username ?? '',
      createdAt: row.createdAt,
      displayName: row.displayName,
      avatarUrl: row.avatarUrl,
      bio: row.bio,
      statusMessage: row.statusMessage,
      lastSeenAt: row.lastSeenAt,
      updatedAt: row.lastSeenAt,
    );
  }
}
