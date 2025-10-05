part of '../chat.usecases.dart';

// final class FetchChatRoomUseCase {
//   final ChatRepository _repository;
//
//   FetchChatRoomUseCase(this._repository);
//
//   Future<Either<Failure, List<ChatRoomEntity>>> call() async {
    // return await _repository.getCurrentUser().then(
    //       (res) => res.mapLeft((l) {
    //     if (l.code == ErrorCode.notFound) {
    //       return l.copyWith(AuthErrorMessage.gettingCurrentUserFail.message);
    //     }
    //     return l.copyWith('unknown auth error occurs');
    //   }),
    // );
//   }
// }