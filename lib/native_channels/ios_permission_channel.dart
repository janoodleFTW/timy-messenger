import "package:flutter/foundation.dart";
import "package:flutter/services.dart";

enum PermissionType { Photos, Camera }

class IOSPermissionChannel {
  static const MethodChannel channel =
      MethodChannel("de.janoodle.timy/permission-ios");

   static Future<dynamic> requestPermission({
    @required PermissionType permissionType
  }) {
    return channel.invokeMethod<dynamic>(
      "requestPermission",
      <String, String>{
        "permissionType": _stringOf(permissionType),
      },
    );
  }

  static String _stringOf(PermissionType permissionType) {
    switch (permissionType) {
      case PermissionType.Camera:
        return "CAMERA";
      case PermissionType.Photos:
        return "PHOTOS";
      default:
        return "";
    }
  }
}