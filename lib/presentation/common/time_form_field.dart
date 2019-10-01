import "dart:io";

import "package:circles_app/circles_localization.dart";
import "package:circles_app/theme.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

class TimeFormField extends StatefulWidget {
  const TimeFormField({
    Key key,
    String labelText,
    String helperText,
    @required ValueNotifier<TimeOfDay> controller,
    @required FormFieldValidator<TimeOfDay> validator,
  })  : _controller = controller,
        _labelText = labelText,
        _helperText = helperText,
        _validator = validator,
        super(key: key);

  final ValueNotifier<TimeOfDay> _controller;
  final String _labelText;
  final String _helperText;
  final FormFieldValidator<TimeOfDay> _validator;

  @override
  _TimeFormFieldState createState() => _TimeFormFieldState();
}

class _TimeFormFieldState extends State<TimeFormField> {
  @override
  Widget build(BuildContext context) {
    return FormField<TimeOfDay>(
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
                _showTimePickerIOS(context, state);
              } else {
                _showTimePickerAndroid(context, state);
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
                state.value?.format(context) ?? "",
                style: AppTheme.inputMediumTextStyle,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showTimePickerAndroid(
      BuildContext context, FormFieldState<TimeOfDay> state) {
    showTimePicker(
      context: context,
      initialTime: widget._controller.value ?? TimeOfDay.now(),
    ).then((timeOfDay) {
      state.didChange(timeOfDay);
      widget._controller.value = timeOfDay;
    });
  }

  void _showTimePickerIOS(
    BuildContext context,
    FormFieldState<TimeOfDay> state,
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
                        state.didChange(TimeOfDay.now());
                        widget._controller.value = TimeOfDay.now();
                      }
                    },
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  initialDateTime: _initialDateTime(),
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: MediaQuery.of(context).alwaysUse24HourFormat,
                  onDateTimeChanged: (dateTime) {
                    state.didChange(TimeOfDay.fromDateTime(dateTime));
                    widget._controller.value = TimeOfDay.fromDateTime(dateTime);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  DateTime _initialDateTime() {
    final value = widget._controller.value;
    final today = DateTime.now();
    if (value != null) {
      return DateTime(
          today.year, today.month, today.day, value.hour, value.minute);
    }
    return today;
  }
}
