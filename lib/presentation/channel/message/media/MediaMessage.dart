import "dart:io";

import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/attachment/attachment_actions.dart";
import "package:circles_app/domain/redux/message/message_actions.dart";
import "package:circles_app/model/message.dart";
import "package:circles_app/presentation/image/image_with_loader.dart";
import "package:circles_app/routes.dart";
import "package:circles_app/theme.dart";
import "package:circles_app/util/logger.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";

class MessageMedia extends StatelessWidget {
  const MessageMedia(this.message);

  final Message message;

  @override
  Widget build(BuildContext context) {
    switch (message.mediaStatus) {
      case MediaStatus.UPLOADING:
        return _loadingProgress();
        break;
      case MediaStatus.DONE:
        return InkWell(
          child: _buildMosaic(),
          onTap: () {
            Navigator.pushNamed(context, Routes.image, arguments: message);
          },
        );
        break;
      case MediaStatus.ERROR:
      default:
        return _buildError(context);
        break;
    }
  }

  Widget _buildMosaic() {
    final media = message.media.toList();
    switch (media.length) {
      case 0:
        Logger.w("Empty media list");
        return SizedBox.shrink();
      case 1:
        return _buildSingleImage(media.first);
      case 2:
        return _buildTwoImages(media);
      case 3:
        return _buildThreeImages(media);
      case 4:
        return _buildFourImages(media);
      default:
        return _buildFiveOrMoreImages(media);
    }
  }

  Widget _buildSingleImage(String url) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 296,
        maxHeight: 296,
      ),
      child: _aspectRatioImage(
        url: url,
        // backend should store the aspect ratio if there's only one media file
        // defaults to 4:3
        aspectRatio: message.mediaAspectRatio ?? 4 / 3,
      ),
    );
  }

  Widget _aspectRatioImage({
    String url,
    double aspectRatio = 1,
  }) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: ImageWithLoader(url: url),
    );
  }

  Widget _buildTwoImages(List<String> media) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 296,
        maxHeight: 148,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: _aspectRatioImage(url: media[0])),
          _spacer(),
          Expanded(child: _aspectRatioImage(url: media[1])),
        ],
      ),
    );
  }

  Widget _buildThreeImages(List<String> media) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 296,
        maxHeight: 196,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(flex: 196, child: _aspectRatioImage(url: media[0])),
          _spacer(),
          Expanded(
            flex: 97,
            child: Column(
              children: <Widget>[
                _aspectRatioImage(url: media[1]),
                _spacer(),
                _aspectRatioImage(url: media[2]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _spacer() {
    return SizedBox.fromSize(
      size: Size(2, 2),
    );
  }

  Widget _buildFourImages(List<String> media) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 296,
        maxHeight: 296,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: _aspectRatioImage(url: media[0])),
              _spacer(),
              Expanded(child: _aspectRatioImage(url: media[1])),
            ],
          ),
          _spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: _aspectRatioImage(url: media[2])),
              _spacer(),
              Expanded(child: _aspectRatioImage(url: media[3])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFiveOrMoreImages(List<String> media) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 296,
        maxHeight: 248,
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: _aspectRatioImage(url: media[0])),
              _spacer(),
              Expanded(child: _aspectRatioImage(url: media[1])),
            ],
          ),
          _spacer(),
          Row(
            children: <Widget>[
              Expanded(child: _aspectRatioImage(url: media[2])),
              _spacer(),
              Expanded(child: _aspectRatioImage(url: media[3])),
              _spacer(),
              Expanded(
                child: _plusMorePictures(
                  valueCount: media.length - 5,
                  child: _aspectRatioImage(
                    url: media[4],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _loadingProgress() {
    return Container(
        height: 148,
        width: 148,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AppTheme.colorGrey241,
        ),
        child: Center(
          child: SizedBox(
            width: 48,
            height: 48,
            child: _buildCircularProgressIndicator(),
          ),
        ));
  }

  CircularProgressIndicator _buildCircularProgressIndicator() {
    return CircularProgressIndicator(
      backgroundColor: AppTheme.colorGrey225,
      strokeWidth: 3,
      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.colorGrey155),
    );
  }

  Widget _buildError(BuildContext context) {
    return Container(
        height: 148,
        width: 148,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AppTheme.colorGrey241,
        ),
        child: Center(
          child: InkWell(
            onTap: () {
              _retryPictureUpload(context);
            },
            child: SizedBox(
                width: 48,
                height: 48,
                child: Image.asset(
                    "assets/graphics/upload/indicator_0_try_again.png")),
          ),
        ));
  }

  /// Retry picture upload
  ///
  /// Delete the old upload message and create a new one.
  ///
  /// The failed to upload paths should be in the message.media still,
  /// use them to upload pictures again.
  void _retryPictureUpload(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    store.dispatch(DeleteMessage(message.id));
    store.dispatch(NewMessageWithMultipleFilesAction(
      message.media.toList(),
      Platform.isAndroid,
    ));
  }

  Widget _plusMorePictures({
    int valueCount,
    Widget child,
  }) {
    if (valueCount <= 0) {
      return child;
    } else {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          child,
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: AppTheme.colorWhite_50,
              child: Center(
                child: Text(
                  "+$valueCount",
                  style: AppTheme.plusManyPicturesTextStyle,
                ),
              ),
            ),
          )
        ],
      );
    }
  }
}
