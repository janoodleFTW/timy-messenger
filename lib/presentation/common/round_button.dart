import "package:circles_app/theme.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";

class RoundButton extends StatelessWidget {
  const RoundButton({
    @required this.text,
    @required this.onTap,
  });

  final String text;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(24);
    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(
              color: AppTheme.colorDarkBlue
            )
          ),
          height: 40,
          width: 200,
          child: Center(
            child: Text(
              text,
              style: AppTheme.buttonTextStyle.apply(
                color: AppTheme.colorDarkBlue
              ),
            ),
          ),
        ),
      ),
    );
  }
}
