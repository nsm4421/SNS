part of '../user.usecases.dart';

final class StartOnlinePresenceUseCase {
  final UserRepository _repository;

  StartOnlinePresenceUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String topic) async {
    return await _repository.enterPresence(topic: topic);
  }
}

final class LeaveOnlinePresenceUseCase {
  final UserRepository _repository;

  LeaveOnlinePresenceUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String topic) async {
    return await _repository.leavePresence(topic);
  }
}

final class StopOnlinePresenceUseCase {
  final UserRepository _repository;

  StopOnlinePresenceUseCase(this._repository);

  Future<Either<Failure, Unit>> call() async {
    return await _repository.disposePresence();
  }
}
