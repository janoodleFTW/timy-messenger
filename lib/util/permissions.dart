import "dart:io";

import "package:circles_app/native_channels/android_permission_channel.dart";
import "package:circles_app/native_channels/ios_permission_channel.dart";
import "package:circles_app/util/logger.dart";
import "package:flutter/services.dart";

const MethodChannel channel = MethodChannel("de.janoodle.timy/permission");

/// Obtain the status for storage/photos permissions
///
/// If the app has no permission, it will request it.
/// Uses [PermissionType.Photos] for iOS and Android.
///
/// For other platforms always returns false.
Future<bool> getStoragePermission() async {
  if (Platform.isIOS) {
    final status = await IOSPermissionChannel.requestPermission(
        permissionType: PermissionType.Photos);
    Logger.d("Photo permission status: $status");
    return (status == "AUTHORIZED") ? true : false;
  } else if (Platform.isAndroid) {
    final result = await AndroidPermissionChannel.requestPermission(
        permissionType: PermissionType.Photos);
    Logger.d("Photo permission status: $result");
    return result;
  }
  Logger.e("Invalid platform", s: StackTrace.current);
  return false;
}

/// Requests camera permission
///
/// If the app has no permission, it will request it.
/// Uses [PermissionType.Camera] for iOS.
///
/// Android always returns true.
///
/// For other platforms always returns false.
Future<bool> getCameraPermission() async {
  if (Platform.isIOS) {
    final status = await IOSPermissionChannel.requestPermission(
        permissionType: PermissionType.Camera);
    Logger.w("Photo permission status: $status");
    return (status == "AUTHORIZED") ? true : false;
  } else if (Platform.isAndroid) {
    // Android does not need permissions to use camera as "Intent"
    return true;
  }
  Logger.e("Invalid platform", s: StackTrace.current);
  return false;
}
