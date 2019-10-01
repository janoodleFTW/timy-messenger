import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter/services.dart";

const MethodChannel _channel = MethodChannel("de.janoodle.timy/thumbnails-android");

Future<Uint8List> getThumbnailBitmap({
  @required String fileId,
  @required int type,
}) async {
  final Uint8List data = await _channel.invokeMethod(
    "getThumbnailBitmap",
    {
      "fileId": fileId,
      "type": type,
    },
  );
  return data;
}
