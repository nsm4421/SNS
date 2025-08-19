import 'package:injectable/injectable.dart';
import 'package:shared/env/local_supabase_env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_codegen/supabase_codegen.dart';

@InjectableInit.microPackage()
Future<void> initSupabaseDataSourceMicroPackage() async {
  await Supabase.initialize(
    url: LocalSupabaseEnv.supabaseUrl,
    anonKey: LocalSupabaseEnv.supabaseAnonKey,
  );

  setClient(Supabase.instance.client);
}
