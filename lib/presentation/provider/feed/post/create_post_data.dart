part of 'create_post.cubit.dart';

@CopyWith(copyWithNull: true)
class CreatePostData {
  final String content;
  final List<XFile> images;

  CreatePostData({this.content = '', required this.images});
}
