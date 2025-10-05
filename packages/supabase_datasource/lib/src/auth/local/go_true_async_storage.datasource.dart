import 'package:supabase/supabase.dart' show GotrueAsyncStorage;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'go_true_async_storage.datasource_impl.dart';

abstract interface class GoTrueAsyncStorageDataSource
    implements GotrueAsyncStorage {
  const GoTrueAsyncStorageDataSource();
}
