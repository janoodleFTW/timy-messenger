import "dart:io";
import "dart:typed_data";

import "package:circles_app/native_channels/android_thumbnail_channel.dart";
import "package:circles_app/theme.dart";
import "package:circles_app/util/cache.dart";
import "package:circles_app/util/logger.dart";
import "package:flutter/material.dart";
import "package:media_picker_builder/data/media_file.dart";
import "package:media_picker_builder/media_picker_builder.dart";

/// Displays a MediaFile
///
/// To be used in the FilePicker grid.
/// When [selected] it will be grayed out and will display a check on the
/// bottom right corner.
class FilePickerItem extends StatelessWidget {
  const FilePickerItem({
    Key key,
    this.file,
    this.selected,
    this.thumbnailCache,
  }) : super(key: key);

  final MediaFile file;
  final bool selected;
  final BasicCache<String, Uint8List> thumbnailCache;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        file.thumbnailPath != null ? _buildThumb(file) : _buildThumbAsync(file),
        file.type == MediaType.VIDEO
            ? Icon(Icons.play_circle_filled, color: Colors.white, size: 24)
            : const SizedBox(),
        Visibility(
          visible: selected,
          child: Container(
            color: AppTheme.colorGrey128_50,
            padding: EdgeInsets.all(6),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                "assets/graphics/upload/selected.png",
                width: 24,
                height: 24,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildThumb(MediaFile file) {
    return RotatedBox(
      quarterTurns: Platform.isIOS
          ? 0
          : MediaPickerBuilder.orientationToQuarterTurns(file.orientation),
      child: Image.file(
        File(file.thumbnailPath),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildThumbAsync(MediaFile file) {
    if (Platform.isIOS) {
      return _buildThumbAsyncIOS(file);
    } else if (Platform.isAndroid) {
      return _buildThumbAsyncAndroid(file);
    } else {
      return _errorIcon();
    }
  }

  Widget _buildThumbAsyncIOS(MediaFile file) {
    return FutureBuilder(
        future: MediaPickerBuilder.getThumbnail(
          fileId: file.id,
          type: file.type,
        ),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            final thumbnail = snapshot.data;
            file.thumbnailPath = thumbnail;
            return Image.file(
              File(thumbnail),
              fit: BoxFit.cover,
            );
          } else if (snapshot.hasError) {
            Logger.w("Error loading thumbnail for ${file.path}.",
                e: snapshot.error);
            return _errorIcon();
          } else {
            return _loadingIndicator();
          }
        });
  }

  Padding _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CircularProgressIndicator(),
    );
  }

  Icon _errorIcon() {
    return Icon(
      Icons.cancel,
      color: Colors.red,
    );
  }

  Widget _buildThumbAsyncAndroid(MediaFile file) {
    if (thumbnailCache.containsKey(file.id)) {
      return Image.memory(
        thumbnailCache[file.id],
        fit: BoxFit.cover,
      );
    }
    return FutureBuilder(
        future: getThumbnailBitmap(
          fileId: file.id,
          type: file.type.index,
        ),
        builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
          if (snapshot.hasData) {
            final thumbnail = snapshot.data;
            thumbnailCache[file.id] = thumbnail;
            return Image.memory(
              thumbnail,
              fit: BoxFit.cover,
            );
          } else if (snapshot.hasError) {
            Logger.w(
              "Error loading thumbnail for ${file.id}.",
              e: snapshot.error,
            );
            return _errorIcon();
          } else {
            return _loadingIndicator();
          }
        });
  }
}
