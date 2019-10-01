import "package:circles_app/theme.dart";
import "package:flutter/material.dart";

///
/// This is a TextFormField which will change the Label color
/// when it is not empty.
///
/// i.e. When the content is not empty, the whole TextFormField
/// becomes the normal color: the border and the label.
///
/// If you are also using validation, use ErrorLabelTextFormField
///
class ColorLabelTextFormField extends StatefulWidget {
  const ColorLabelTextFormField({
    Key key,
    String labelText,
    String helperText,
    @required TextEditingController controller,
  })  : _controller = controller,
        _labelText = labelText,
        _helperText = helperText,
        super(key: key);

  final TextEditingController _controller;
  final String _labelText;
  final String _helperText;

  @override
  _ColorLabelTextFormFieldState createState() =>
      _ColorLabelTextFormFieldState();
}

class _ColorLabelTextFormFieldState extends State<ColorLabelTextFormField> {
  bool _isEmpty = true;

  @override
  void initState() {
    super.initState();
    widget._controller.addListener(() {
      setState(() {
        _isEmpty = widget._controller.text.isEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isEmpty
        ? AppTheme.inputDecorationEmptyTheme
        : AppTheme.inputDecorationFilledTheme;

    return TextFormField(
      style: AppTheme.inputMediumTextStyle,
      decoration: InputDecoration(
        labelText: widget._labelText,
        helperText: widget._helperText,
      ).applyDefaults(theme),
      controller: widget._controller,
    );
  }
}
