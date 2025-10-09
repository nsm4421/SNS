import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/core/core.export.dart';
import 'package:karma/domain/entity/entity.export.dart';
import 'package:karma/domain/repository/repository.export.dart';

part 'scenario/get_user_by_id.usecase.dart';

part 'scenario/update_profile.usecase.dart';

part 'scenario/online_presence.usecase.dart';

part 'scenario/get_is_username_duplicated.usecase.dart';

@lazySingleton
class UserUseCases {
  final UserRepository _repository;

  UserUseCases(this._repository);

  Stream<Set<String>> getOnlineUserIdsStream(String topic) =>
      _repository.getOnlineUserIdsStream(topic);

  GetUserByIdUseCase get getById => GetUserByIdUseCase(_repository);

  GetIsUsernameDuplicatedUseCase get getIsUsernameDuplicated =>
      GetIsUsernameDuplicatedUseCase(_repository);

  UpdateProfileUseCase get updateProfile => UpdateProfileUseCase(_repository);

  StartOnlinePresenceUseCase get startOnlinePresence =>
      StartOnlinePresenceUseCase(_repository);

  LeaveOnlinePresenceUseCase get leaveOnlinePresence =>
      LeaveOnlinePresenceUseCase(_repository);

  StopOnlinePresenceUseCase get stopOnlinePresence =>
      StopOnlinePresenceUseCase(_repository);
}
