enum MediaType { image, video, other }

extension MediaTypeExtension on MediaType {
  MediaType fromMimeType(String mimeType) {
    if (mimeType.startsWith('image/')) {
      return MediaType.image;
    } else if (mimeType.startsWith('video/')) {
      return MediaType.video;
    } else {
      return MediaType.other;
    }
  }
}
