import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

mixin class PermissionHelperMixIn {
  Future<bool> handleGalleryPermission({bool requireFullAccess = true}) async {
    /// ios
    if (Platform.isIOS) {
      final status = await Permission.photos.request();
      switch (status) {
        case PermissionStatus.granted:
          debugPrint('ios 권한이 허용된 경우');
          return true;
        case PermissionStatus.limited:
          debugPrint('ios 권한이 일부만 허용된 경우');
          if (requireFullAccess) {
            await openAppSettings();
          }
          return !requireFullAccess;
        case PermissionStatus.permanentlyDenied:
          debugPrint('ios 권한요청을 너무 많이 거졀해서 영구 거절된 경우');
          await openAppSettings();
          return false;
        default:
          return false;
      }
    }
    /// andriod
    else if (Platform.isAndroid) {

      PermissionStatus photoStatus = await Permission.photos.status;
      PermissionStatus videoStatus = await Permission.videos.status;
      debugPrint('android photo status $photoStatus');
      debugPrint('android video status $videoStatus');

      if (photoStatus.isGranted && videoStatus.isGranted) {
        debugPrint('android 영상 사진 권한 모두 허용된 경우');
        return true;
      }

      // 사진, 비디오 권한 요청
      if (!photoStatus.isGranted) {
        debugPrint('android 사진 권한 요청');
        photoStatus = await Permission.photos.request();
      }
      if (!videoStatus.isGranted) {
        debugPrint('android 비디오 권한 요청');
        videoStatus = await Permission.videos.request();
      }

      if (photoStatus.isGranted && videoStatus.isGranted) {
        debugPrint('android 영상 사진 권한 요청 다시한 결과 모두 허용된 경우');
        return true;
      }

      await openAppSettings();
      debugPrint('android false 반환');
      return false;
    }
    /// other(web)
    else {
      return true;
    }
  }
}
