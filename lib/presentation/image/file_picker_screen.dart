import "dart:io";
import "dart:typed_data";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/attachment/attachment_actions.dart";
import "package:circles_app/presentation/common/common_app_bar.dart";
import "package:circles_app/presentation/common/platform_alerts.dart";
import "package:circles_app/presentation/image/file_picker_item.dart";
import "package:circles_app/theme.dart";
import "package:circles_app/util/cache.dart";
import "package:circles_app/util/logger.dart";
import "package:circles_app/util/permissions.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:image_picker/image_picker.dart";
import "package:media_picker_builder/data/album.dart";
import "package:media_picker_builder/data/media_file.dart";
import "package:media_picker_builder/media_picker_builder.dart";

/// Displays a gallery image picker
class FilePickerScreen extends StatefulWidget {
  @override
  _FilePickerScreenState createState() => _FilePickerScreenState();
}

class _FilePickerScreenState extends State<FilePickerScreen> {
  final files = <MediaFile>[];
  // On Android, thumbnails are loaded from memory and not from file paths
  // we use this simple cache to keep them in memory while the file picker
  // is displayed
  final thumbnailCache = BasicCache<String, Uint8List>(size: 100);

  // Indexes of picked files
  final picked = <int>[];

  // Data loading flag (currently used on iOS only)
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadFilePaths();
  }

  @override
  void dispose() {
    super.dispose();
    thumbnailCache.clear();
  }

  /// Load all pictures from the device
  ///
  /// First will ask the user for permission to read all files, then
  /// will load pictures and put them in
  /// the [files] array.
  _loadFilePaths() {
    getStoragePermission().then((gotPermission) {
      if (!gotPermission) {
        Logger.w("User gave no permission to load photos");
        return <Album>[];
      } else {
        setState(() {
          _isLoading = true;
        });
        return MediaPickerBuilder.getAlbums(
            withImages: true,
            withVideos: false,
            loadIOSPaths:
                false // For iOS users this should never be true since it'll consume way too much memory.
            );
      }
    }).then((albums) {
      _updateMediaFiles(albums);
      setState(() {
        _isLoading = false;
      });
    });
  }

  /// Update [MediaFiles] in [files]
  ///
  /// Removes all duplicated [MediaFiles] from the [Album]s list
  /// then clears [files] and adds all the new files.
  void _updateMediaFiles(List<Album> albums) {
    // Avoid duplicates by path for Android. 
    // In iOS files are uniquely referenced by their id
    final map = <String, MediaFile>{};
    for (final album in albums) {
      for (final file in album.files) {
        if (Platform.isIOS) {
          map[file.id] = file;
        } else {
          map[file.path] = file;
        }
      }
    }
    setState(() {
      files.clear();
      files.addAll(map.values);
      // Sort by new
      files.sort((a, b) => b.dateAdded.compareTo(a.dateAdded));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "All Photos",
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                        Container(
                            child: CircularProgressIndicator(
                          backgroundColor: AppTheme.colorGrey225,
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.colorGrey155),
                        ))
                      ])
                : _buildGridView(),
          ),
          _buildBottomBar(context)
        ],
      ),
    );
  }

  /// Bottom bar with the camera icon and the send button
  Container _buildBottomBar(BuildContext context) {
    return Container(
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildCameraIcon(context),
          ),
          _buildSendButton(context),
        ],
      ),
    );
  }

  /// Send button
  ///
  /// Will be disabled if there are no [picked] files.
  /// It will display the count otherwise.
  FlatButton _buildSendButton(BuildContext context) {
    return FlatButton(
      child: Text(
        picked.isEmpty ? "Send" : "Send (${picked.length})",
        style: AppTheme.buttonTextStyle,
      ),
      onPressed: picked.isNotEmpty ? () => _sendPictures(context) : null,
    );
  }

  /// Action to send pictures
  ///
  /// Reads all the paths from [picked] and sends them in a Middleware action.
  void _sendPictures(BuildContext context) {
    final fileIdentifiers = <String>[];
    final isPath = !Platform.isIOS;

    for (final index in picked) {
      if (!isPath) {
        fileIdentifiers.add(files[index].id);
      } else {
        fileIdentifiers.add(files[index].path);
      }
    }
    StoreProvider.of<AppState>(context)
        .dispatch(NewMessageWithMultipleFilesAction(fileIdentifiers, isPath));
    // Close the file picker
    Navigator.pop(context);
  }

  /// Camera icon, when clicked launches take and share picture.
  ///
  /// Taking and sharing a camera picture works like uploading a single image.
  IconButton _buildCameraIcon(BuildContext context) {
    return IconButton(
      icon: Image.asset(
        "assets/graphics/input/icon_camera.png",
        scale: 3,
      ),
      onPressed: () async {
        final bool cameraPermission = await getCameraPermission();
        if (!cameraPermission) {
          await showNoAccessAlert(
              context: context, type: AccessResourceType.CAMERA);
          return;
        }

        final imageFile =
            await ImagePicker.pickImage(source: ImageSource.camera);
        if (imageFile == null) return;
        StoreProvider.of<AppState>(context).dispatch(
          NewMessageWithMultipleFilesAction([imageFile.path], true),
        );
        await Navigator.of(context).maybePop();
      },
    );
  }

  /// File picker grid
  ///
  /// It displays 4 columns.
  /// Aspect ratio of items is defined here, as 1:1 (squares).
  ///
  /// Increases the cacheExtend from 250 which is defined in
  /// [RenderAbstractViewport.defaultCacheExtent] to 1000
  /// so the scrolling is nicer
  ///
  GridView _buildGridView() {
    return GridView.builder(
      cacheExtent: 1000,
      reverse: Platform.isIOS, // Start from bottom on iOS
      itemCount: files.length,
      itemBuilder: (context, position) => _buildThumbnail(context, position),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        childAspectRatio: 1.0,
      ),
    );
  }

  /// File picker items
  ///
  /// Adds an on tap action that selects item in [_selectItem].
  /// Evaluates if an item has been picked or not by checking if the
  /// [picked] array contains the item index.
  Widget _buildThumbnail(BuildContext context, int position) {
    final file = files[position];
    return InkWell(
      onTap: () => _selectItem(file, position),
      child: FilePickerItem(
        key: Key(file.id),
        file: file,
        selected: picked.contains(position),
        thumbnailCache: thumbnailCache,
      ),
    );
  }

  /// Select item action
  ///
  /// Adds or removes the file index into the [picked] array.
  _selectItem(MediaFile file, int position) {
    if (picked.contains(position)) {
      setState(() {
        picked.remove(position);
      });
    } else {
      if (picked.length >= 30) {
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Max. 30 pictures at once"),
        ));
        return;
      }
      setState(() {
        picked.add(position);
      });
    }
  }
}
