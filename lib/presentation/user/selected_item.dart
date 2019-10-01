import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

class SelectedItem extends StatelessWidget {
  final bool selected;

  const SelectedItem({
    this.selected,
  });

  @override
  Widget build(BuildContext context) {
    final height = 24.0, width = 24.0;
    return (selected
        ? Image.asset(
            "assets/graphics/input/checkbox_active.png",
            height: height,
            width: width,
          )
        : Image.asset(
            "assets/graphics/input/checkbox_inactive.png",
            height: height,
            width: width,
          ));
  }
}
