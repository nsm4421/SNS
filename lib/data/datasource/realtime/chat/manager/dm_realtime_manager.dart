import 'dart:async';
import 'package:logger/logger.dart';
import 'package:supabase/supabase.dart';

import 'chat_realtime_manager.dart';
import '../channel/chat_room.channel.dart';
import 'package:karma/data/model/model.export.dart';

part 'dm_realtime_manager_impl.dart';

abstract interface class DmRealtimeManager extends ChatRealtimeManager {}
