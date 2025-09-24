part of 'profiles_table.datasource.dart';

class SupabaseProfileTableDataSourceImpl
    with DbErrorHandlerMixin
    implements ProfilesTableDataSource {
  SupabaseProfileTableDataSourceImpl(this._profilesTable);

  final ProfilesTable _profilesTable;

  @override
  Future<ProfilesRow> findByUserId(String userId) async {
    try {
      final fetched = await _profilesTable.querySingleRow(
        queryFn: (q) => q.eq('user_id', userId),
      );
      if (fetched == null) {
        throw CustomException.database(
          message: 'user id $userId is not founded',
          code: 'NOT_FOUND',
        );
      }
      return fetched;
    } on PostgrestException catch (e) {
      throwCustomExceptionFromPostgresException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProfilesRow> updateProfile(UpdateProfileRequestDto dto) async {
    try {
      final updated = await _profilesTable
          .update(
            matchingRows: (q) => q.eq('user_id', dto.userId),
            data: {
              ...dto.toJson(),
              'updated_at': DateTime.now().toUtc().toIso8601String(),
            },
          )
          .then((res) => res.firstOrNull);
      if (updated == null) {
        throw CustomException.database(
          message: 'user id ${dto.userId} is not founded',
          code: 'NOT_FOUND',
        );
      }
      return updated;
    } on PostgrestException catch (e) {
      throwCustomExceptionFromPostgresException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> getIsUsernameDuplicated(String username) async {
    try {
      return await _profilesTable
          .querySingleRow(queryFn: (q) => q.eq('username', username))
          .then((res) => res != null);
    } on PostgrestException catch (e) {
      throwCustomExceptionFromPostgresException(e);
    } catch (e) {
      rethrow;
    }
  }
}
