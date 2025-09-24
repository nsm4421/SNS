part of 'profiles_table.datasource.dart';

class SupabaseProfileTableDataSourceImpl
    with DbErrorHandlerMixin
    implements ProfilesTableDataSource {
  SupabaseProfileTableDataSourceImpl(this._postgrestQueryBuilder);

  final PostgrestQueryBuilder<void> _postgrestQueryBuilder;

  @override
  Future<ProfileModel> findByUserId(String userId) async {
    try {
      return await _postgrestQueryBuilder
          .select()
          .eq('user_id', userId)
          .single()
          .then(ProfileModel.fromJson);
    } on PostgrestException catch (e) {
      throwCustomExceptionFromPostgresException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProfileModel> updateProfile(UpdateProfileRequestDto profile) async {
    try {
      return await _postgrestQueryBuilder
          .upsert({
            ...profile.toJson(),
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .select()
          .single()
          .then(ProfileModel.fromJson);
    } on PostgrestException catch (e) {
      throwCustomExceptionFromPostgresException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> getIsUsernameDuplicated(String username) async {
    try {
      return await _postgrestQueryBuilder
          .select('username')
          .eq('username', username)
          .limit(1)
          .maybeSingle()
          .then((res) => res != null);
    } on PostgrestException catch (e) {
      throwCustomExceptionFromPostgresException(e);
    } catch (e) {
      rethrow;
    }
  }
}
