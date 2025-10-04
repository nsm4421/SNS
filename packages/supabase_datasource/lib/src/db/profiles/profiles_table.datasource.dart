import 'package:logger/logger.dart';
import 'package:shared/shared.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_datasource/src/db/exception/db_error_handler_mixin.dart';
import 'package:supabase_datasource/src/db/profiles/dto/update_profile_request.dto.dart';
import 'package:supabase_datasource/src/models/profile/profile.model.dart';
import 'package:supabase_datasource/src/models/supabase/database.dart';

part 'profiles_table.datasource_impl.dart';

abstract interface class ProfilesTableDataSource {
  Future<ProfileModel> findByUserId(String userId);

  Future<ProfileModel> updateProfile(UpdateProfileRequestDto dto);

  Future<bool> getIsUsernameDuplicated(String username);
}
