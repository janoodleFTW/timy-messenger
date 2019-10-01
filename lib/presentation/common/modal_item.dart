import "package:circles_app/theme.dart";
import "package:flutter/cupertino.dart";

class ModalItem extends StatelessWidget {
  const ModalItem({
    Key key,
    this.iconAsset,
    this.iconData,
    @required this.label,
  }) : super(key: key);

  final String iconAsset;
  final String label;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: iconAsset != null
              ? Image.asset(
                  iconAsset,
                  scale: 3,
                )
              : Icon(iconData),
        ),
        Text(
          label,
          style: AppTheme.optionTextStyle,
          textScaleFactor: 1,
        ),
      ],
    );
  }
}
