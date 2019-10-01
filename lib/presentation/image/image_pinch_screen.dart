import "package:flutter/material.dart";
import "package:pinch_zoom_image/pinch_zoom_image.dart";
import "package:transparent_image/transparent_image.dart";

class ImagePinchScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final String url = ModalRoute.of(context).settings.arguments;
    return SafeArea(
      child: GestureDetector(
        child: PinchZoomImage(
          image: FadeInImage.memoryNetwork(
            image: url,
            placeholder: kTransparentImage,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
