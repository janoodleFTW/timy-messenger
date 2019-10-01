import "package:circles_app/theme.dart";
import "package:flutter/material.dart";
import "package:transparent_image/transparent_image.dart";

class ImageWithLoader extends StatelessWidget {
  const ImageWithLoader({
    this.url,
    this.fit = BoxFit.cover,
    this.loaderSize = 48.0,
  });

  final String url;
  final BoxFit fit;
  final double loaderSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          color: AppTheme.colorGrey241,
          child: Center(
            child: SizedBox(
              width: loaderSize,
              height: loaderSize,
              child: _buildCircularProgressIndicator(),
            ),
          ),
        ),
        FadeInImage.memoryNetwork(
          image: url,
          fit: fit,
          placeholder: kTransparentImage,
        ),
      ],
    );
  }
}

CircularProgressIndicator _buildCircularProgressIndicator() {
  return CircularProgressIndicator(
    backgroundColor: AppTheme.colorGrey225,
    strokeWidth: 3,
    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.colorGrey155),
  );
}
