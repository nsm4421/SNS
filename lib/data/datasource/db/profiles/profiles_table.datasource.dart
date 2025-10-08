import 'package:supabase/supabase.dart';
import 'package:logger/logger.dart';
import 'package:karma/data/model/model.export.dart';
import 'package:karma/core/core.export.dart';
import '../db_error_handler_mixin.dart';
import '../generated/database.dart';

part 'profiles_table.datasource_impl.dart';

abstract interface class ProfilesTableDataSource {
  Future<ProfileModel> findByUserId(String userId);

  Future<ProfileModel> updateProfile(UpdateProfileRequestDto dto);

  Future<bool> getIsUsernameDuplicated(String username);
}
