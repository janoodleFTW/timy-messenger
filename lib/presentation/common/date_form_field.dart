import "dart:io";

import "package:circles_app/circles_localization.dart";
import "package:circles_app/theme.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";

class DateFormField extends StatefulWidget {
  const DateFormField({
    Key key,
    String labelText,
    String helperText,
    @required ValueNotifier<DateTime> controller,
    @required FormFieldValidator<DateTime> validator,
  })  : _controller = controller,
        _labelText = labelText,
        _helperText = helperText,
        _validator = validator,
        super(key: key);

  final ValueNotifier<DateTime> _controller;
  final String _labelText;
  final String _helperText;
  final FormFieldValidator<DateTime> _validator;

  @override
  _DateFormFieldState createState() => _DateFormFieldState();
}

class _DateFormFieldState extends State<DateFormField> {
  @override
  Widget build(BuildContext context) {
    return FormField<DateTime>(
      validator: widget._validator,
      initialValue: widget._controller.value,
      builder: (state) {
        final theme = state.errorText != null
            ? AppTheme.inputDecorationErrorTheme
            : (state.value == null
                ? AppTheme.inputDecorationEmptyTheme
                : AppTheme.inputDecorationFilledTheme);

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (Platform.isIOS) {
                _showDatePickerIOS(context, state);
              } else {
                _showDatePickerAndroid(context, state);
              }
            },
            child: InputDecorator(
              isEmpty: state.value == null,
              decoration: InputDecoration(
                labelText: widget._labelText,
                helperText: widget._helperText,
                errorText: state.errorText,
              ).applyDefaults(theme),
              child: Text(
                state.value != null
                    ? DateFormat.yMMMd().format(state.value)
                    : "",
                style: AppTheme.inputMediumTextStyle,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDatePickerIOS(
    BuildContext context,
    FormFieldState<DateTime> state,
  ) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      CirclesLocalizations.of(context).cancel,
                      style: AppTheme.buttonTextStyle,
                    ),
                    onPressed: () {
                      Navigator.maybePop(context);
                      state.didChange(null);
                      widget._controller.value = null;
                    },
                  ),
                  FlatButton(
                    child: Text(
                      CirclesLocalizations.of(context).save,
                      style: AppTheme.buttonTextStyle,
                    ),
                    onPressed: () {
                      Navigator.maybePop(context);
                      if (widget._controller.value == null) {
                        state.didChange(DateTime.now());
                        widget._controller.value = DateTime.now();
                      }
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: widget._controller.value ?? DateTime.now(),
                  minimumYear: DateTime.now().year,
                  maximumYear: 2030,
                  mode: CupertinoDatePickerMode.date,
                  onDateTimeChanged: (dateTime) {
                    state.didChange(dateTime);
                    widget._controller.value = dateTime;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDatePickerAndroid(
      BuildContext context, FormFieldState<DateTime> state) {
    final now = DateTime.now();
    showDatePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(2030),
      initialDate: widget._controller.value ?? now,
    ).then((dateTime) {
      state.didChange(dateTime);
      widget._controller.value = dateTime;
    });
  }
}
