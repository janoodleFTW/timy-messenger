import "dart:math";

import "package:flutter_native_image/flutter_native_image.dart";
import "dart:io";

const avatarSize = 200;

class ImageProcessor {
  Future<File> cropAndResizeAvatar(File file) async {
    final ImageProperties properties =
        await FlutterNativeImage.getImageProperties(file.path);
    final squareSize = min(properties.width, properties.height);
    final originX = ((properties.width / 2) - (squareSize / 2)).toInt();
    final originY = ((properties.height / 2) - (squareSize / 2)).toInt();
    final cropped = await FlutterNativeImage.cropImage(
        file.path, originX, originY, squareSize, squareSize);
    return await FlutterNativeImage.compressImage(cropped.path,
        quality: 95, targetWidth: avatarSize, targetHeight: avatarSize);
  }
}
