import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:karma/domain/entity/entity.export.dart';

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget(this._user, {super.key, double size = 40})
    : _size = size;

  final UserEntity? _user;
  final double _size;

  @override
  Widget build(BuildContext context) {
    if (_user?.avatarUrl != null && _user!.avatarUrl!.isNotEmpty) {
      return Container(
        width: _size,
        height: _size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: CachedNetworkImageProvider(_user.avatarUrl!),
          ),
        ),
      );
    } else if (_user?.username != null && _user!.username!.isNotEmpty) {
      return CircleAvatar(
        radius: _size / 2,
        child: Text(
          _user.username!.substring(0, 1),
          style: TextStyle(fontSize: _size / 2),
        ),
      );
    } else {
      return CircleAvatar(
        radius: _size / 2,
        child: Icon(Icons.question_mark, size: _size / 1.5),
      );
    }
  }
}
