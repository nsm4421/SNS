import 'dart:async';

import 'package:logger/logger.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_datasource/src/models/vo/realtime_connection_state.vo.dart';
import 'package:supabase_datasource/supabase_datasource.dart';

import 'chat_realtime_manager.dart';

part 'dm_realtime_manager_impl.dart';

abstract interface class DmRealtimeManager extends ChatRealtimeManager {}
