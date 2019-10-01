import "package:flutter/services.dart";
import "package:meta/meta.dart";

class UploadPlatform {
  static const MethodChannel channel =
      MethodChannel("de.janoodle.timy/upload_platform");

  Future<dynamic> uploadFiles({
    @required List<String> filePaths, // Path to files on Android and a photo just taken on iOS
    @required List<String> localIdentifiers, // iOS files localIdentifiers
    @required String groupId,
    @required String channelId,
  }) {
    return channel.invokeMethod<dynamic>(
      "uploadFiles",
      <String, dynamic>{
        "filePaths": filePaths,
        "localIdentifiers": localIdentifiers,
        "groupId": groupId,
        "channelId": channelId,
      },
    );
  }
}
