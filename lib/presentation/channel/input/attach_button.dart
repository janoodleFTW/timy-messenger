import "package:circles_app/circles_localization.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/attachment/attachment_actions.dart";
import "package:circles_app/presentation/common/platform_alerts.dart";
import "package:circles_app/routes.dart";
import "package:circles_app/theme.dart";
import "package:circles_app/util/permissions.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:image_picker/image_picker.dart";

class AttachButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(16),
      icon: Image.asset(
        "assets/graphics/input/icon_add_content.png",
        scale: 2.5,
      ),
      onPressed: () {
        _showDialogCameraOrGalleryCupertino(context);
      },
    );
  }

  _pickFiles(BuildContext context) async {
    final permission = await getStoragePermission();
    if (!permission) {
      showNoAccessAlert(context: context, type: AccessResourceType.STORAGE);
    } else {
      await Navigator.pushReplacementNamed(context, Routes.imagePicker);
    }
  }

  Future _takePicture(BuildContext context) async {
    final bool cameraPermission = await getCameraPermission();
    if (!cameraPermission) {
      await showNoAccessAlert(
          context: context, type: AccessResourceType.CAMERA);
      return;
    }

    final imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    if (imageFile == null) return;
    StoreProvider.of<AppState>(context).dispatch(
      NewMessageWithMultipleFilesAction([imageFile.path], true),
    );
    await Navigator.of(context).maybePop();
  }

  void _showDialogCameraOrGalleryCupertino(context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: _cameraItem(context),
            onPressed: () {
              _takePicture(context);
            },
          ),
          CupertinoActionSheetAction(
            child: _galleryItem(context),
            onPressed: () {
              _pickFiles(context);
            },
          ),
        ],
      ),
    );
  }

  Row _cameraItem(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Image.asset(
            "assets/graphics/input/icon_camera.png",
            scale: 3,
          ),
        ),
        Text(
          CirclesLocalizations.of(context).attachModalCamera,
          style: AppTheme.optionTextStyle,
          textScaleFactor: 1,
        ),
      ],
    );
  }

  Row _galleryItem(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Image.asset(
            "assets/graphics/input/icon_pictures.png",
            scale: 3,
          ),
        ),
        Text(
          CirclesLocalizations.of(context).attachModalGallery,
          style: AppTheme.optionTextStyle,
          textScaleFactor: 1,
        ),
      ],
    );
  }
}
