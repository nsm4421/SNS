import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(obfuscate: false)
abstract class Env {
  @EnviedField(varName: 'SUPABASE_API_URL')
  static const String supabaseApiUrl = _Env.supabaseApiUrl;

  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static const String supabaseAnonKey = _Env.supabaseAnonKey;
}
