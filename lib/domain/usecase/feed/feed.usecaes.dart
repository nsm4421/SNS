import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/core/core.export.dart';
import 'package:karma/domain/entity/entity.export.dart';
import 'package:karma/domain/repository/repository.export.dart';
import 'package:uuid/uuid.dart';

part 'scenario/post/get_post.usecase.dart';

part 'scenario/post/create_post.usecase.dart';

part 'scenario/post/fetch_posts.usecase.dart';

part 'scenario/post/delete_post.usecase.dart';

part 'scenario/comment/create_comment.usecase.dart';

part 'scenario/comment/fetch_comments.usecase.dart';

part 'scenario/comment/delete_comment.usecase.dart';

part 'scenario/like/toggle_like.usecase.dart';

@lazySingleton
class FeedUseCases {
  final FeedRepository _repository;

  FeedUseCases(this._repository);

  GetPostUseCase get getPost => GetPostUseCase(_repository);

  SavePostOnDbUseCase get savePostOnDb => SavePostOnDbUseCase(_repository);

  UploadPostMediaUseCase get uploadPostMedia =>
      UploadPostMediaUseCase(_repository);

  FetchPostsUseCase get fetchPosts => FetchPostsUseCase(_repository);

  DeletePostUseCase get deletePost => DeletePostUseCase(_repository);

  CreateCommentUseCase get createComment => CreateCommentUseCase(_repository);

  FetchCommentsUseCase get fetchComments => FetchCommentsUseCase(_repository);

  DeleteCommentUseCase get deleteComment => DeleteCommentUseCase(_repository);

  ToggleLikeUseCase get toggleLike => ToggleLikeUseCase(_repository);
}
