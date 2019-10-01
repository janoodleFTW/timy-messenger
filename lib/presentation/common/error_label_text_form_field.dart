import "package:circles_app/theme.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

///
/// This is a TextFormField which will change the Label color
/// when there's an error and as well does the same
/// ColorLabelTextFormField does.
///
/// i.e. When the validator returns not null, the whole TextFormField
/// becomes red: The error text, the border and the label.
///
/// In the default TextFormField the label stays in the original color.
///
/// It only makes sense to use this when you have a validator,
/// otherwise just use the normal TextFormField or the
/// ColorLabelTextFormField.
///
class ErrorLabelTextFormField extends StatefulWidget {
  const ErrorLabelTextFormField({
    Key key,
    String labelText,
    String helperText,
    int maxCharacters = 0,
    bool enabled = true,
    @required TextEditingController controller,
    @required FormFieldValidator<String> validator,
  })  : _controller = controller,
        _validator = validator,
        _labelText = labelText,
        _helperText = helperText,
        _maxCharacters = maxCharacters,
        _enabled = enabled,
        super(key: key);

  final TextEditingController _controller;
  final FormFieldValidator<String> _validator;
  final String _labelText;
  final String _helperText;
  final int _maxCharacters;
  final bool _enabled;

  @override
  _ErrorLabelTextFormFieldState createState() =>
      _ErrorLabelTextFormFieldState();
}

class _ErrorLabelTextFormFieldState extends State<ErrorLabelTextFormField> {
  bool _isEmpty = true;
  bool _hasErrors = false;

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
    final theme = _hasErrors
        ? AppTheme.inputDecorationErrorTheme
        : (_isEmpty
            ? AppTheme.inputDecorationEmptyTheme
            : AppTheme.inputDecorationFilledTheme);

    return TextFormField(
      inputFormatters: [
        widget._maxCharacters > 0
            ? LengthLimitingTextInputFormatter(widget._maxCharacters)
            : null
      ],
      style: AppTheme.inputMediumTextStyle,
      decoration: InputDecoration(
        labelText: widget._labelText,
        helperText: widget._helperText,
      ).applyDefaults(theme),
      controller: widget._controller,
      enabled: widget._enabled,
      validator: (value) {
        final out = widget._validator(value);
        setState(() {
          _hasErrors = (out != null);
        });
        return out;
      },
    );
  }
}
