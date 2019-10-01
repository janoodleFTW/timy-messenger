import "package:circles_app/native_channels/ios_permission_channel.dart";
import "package:circles_app/util/logger.dart";
import "package:flutter/foundation.dart";
import "package:flutter/services.dart";

const ANDROID_PERMISSION_GRANTED = 0;

class AndroidPermissionChannel {
  static const MethodChannel channel =
      MethodChannel("de.janoodle.timy/permission-android");

   static Future<bool> requestPermission({
    @required PermissionType permissionType
  }) async {
    final result = await channel.invokeMethod<dynamic>(
      "requestPermission",
      <String, String>{
        "permissionType": _stringOf(permissionType),
      },
    );
    final int granted = result[_stringOf(permissionType)];
    if (granted == ANDROID_PERMISSION_GRANTED) {
      Logger.d("Permission granted");
      return true;
    } else {
      Logger.w("Permission denied for ${_stringOf(permissionType)}");
      return false;
    }
  }

  static String _stringOf(PermissionType permissionType) {
    switch (permissionType) {
      case PermissionType.Photos:
        return "android.permission.READ_EXTERNAL_STORAGE";
      default:
        return "";
    }
  }
}