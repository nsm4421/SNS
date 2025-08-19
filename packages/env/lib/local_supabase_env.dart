import 'package:envied/envied.dart';

part 'local_supabase_env.g.dart';

@Envied(path: '.env.local', obfuscate: true)
abstract class LocalSupabaseEnv {
  @EnviedField(varName: 'SUPABASE_URL')
  static final String supabaseUrl = _LocalSupabaseEnv.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static final String supabaseAnonKey = _LocalSupabaseEnv.supabaseAnonKey;
}
