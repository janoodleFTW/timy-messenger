import "dart:async";

import "package:built_collection/built_collection.dart";
import "package:circles_app/circles_localization.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/channel/channel_actions.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/model/user.dart";
import "package:circles_app/presentation/common/color_label_text_form_field.dart";
import "package:circles_app/presentation/common/common_app_bar.dart";
import "package:circles_app/presentation/common/date_form_field.dart";
import "package:circles_app/presentation/common/error_label_text_form_field.dart";
import "package:circles_app/presentation/common/time_form_field.dart";
import "package:circles_app/presentation/user/user_item.dart";
import "package:circles_app/routes.dart";
import "package:circles_app/theme.dart";
import "package:circles_app/util/logger.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_platform_widgets/flutter_platform_widgets.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:redux/redux.dart";

class CreateEventScreen extends StatefulWidget {
  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _nameController = TextEditingController();
  final _dateController = ValueNotifier<DateTime>(null);
  final _timeController = ValueNotifier<TimeOfDay>(null);
  final _venueController = TextEditingController();
  final _purposeController = TextEditingController();
  ChannelVisibility _visibility = ChannelVisibility.OPEN;
  final Set<String> _selectedUsers = Set();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  // will be null if we are in create mode
  Channel _editChannel;
  bool _loadedEditChannel = false;

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _venueController.dispose();
    _purposeController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _editChannel = ModalRoute.of(context).settings.arguments;
    if (_editChannel != null && !_loadedEditChannel) {
      _loadedEditChannel = true;
      _nameController.text = _editChannel.name;
      _dateController.value = _editChannel.startDate;
      if (_editChannel.hasStartTime) {
        _timeController.value = TimeOfDay(
          hour: _editChannel.startDate.hour,
          minute: _editChannel.startDate.minute,
        );
      }
      _venueController.text = _editChannel.venue;
      _purposeController.text = _editChannel.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: _buildTitle(context),
        action: FlatButton(
            key: Key("Create"),
            child: Text(
              _buildSaveButtonText(context),
              style: AppTheme.buttonTextStyle,
            ),
            onPressed: () {
              _validateAndSubmit();
            }),
      ),
      body: StoreConnector<AppState, _ViewModel>(
        builder: (context, _vm) => listForm(_vm),
        converter: _ViewModel.fromStore,
      ),
    );
  }

  String _buildSaveButtonText(BuildContext context) {
    return _editChannel != null
        ? CirclesLocalizations.of(context).save
        : CirclesLocalizations.of(context).create;
  }

  _buildTitle(BuildContext context) {
    return _editChannel != null
        ? CirclesLocalizations.of(context).eventEditTitle
        : CirclesLocalizations.of(context).eventCreateTitle;
  }

  Widget listForm(_ViewModel vm) {
    final nameInput = _buildName();

    final dateInput = Padding(
      padding: const EdgeInsets.only(
        top: 24,
        left: AppTheme.appMargin,
        right: AppTheme.appMargin / 2,
      ),
      child: DateFormField(
        key: Key("EventDate"),
        labelText: CirclesLocalizations.of(context).eventFormDate,
        controller: _dateController,
        validator: (value) {
          if (value == null) {
            return CirclesLocalizations.of(context).eventFormDateEmpty;
          }
          final today = DateTime.now();
          if (value.isBefore(DateTime(today.year, today.month, today.day))) {
            return CirclesLocalizations.of(context).eventFormDatePast;
          }
          return null;
        },
      ),
    );

    final timeInput = Padding(
      padding: const EdgeInsets.only(
        top: 24,
        left: AppTheme.appMargin / 2,
        right: AppTheme.appMargin,
      ),
      child: TimeFormField(
        key: Key("EventTime"),
        labelText: CirclesLocalizations.of(context).eventFormTime,
        controller: _timeController,
        validator: (_) => null,
      ),
    );

    final eventTimeRow = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: dateInput),
        Expanded(child: timeInput),
      ],
    );

    final venueInput = Padding(
      padding: const EdgeInsets.only(
        top: 24,
        left: AppTheme.appMargin,
        right: AppTheme.appMargin,
      ),
      child: ColorLabelTextFormField(
        labelText: CirclesLocalizations.of(context).eventFormVenue,
        helperText: CirclesLocalizations.of(context).eventFormVenueHelper,
        controller: _venueController,
      ),
    );

    final purposeInput = Padding(
      padding: const EdgeInsets.only(
        top: 24,
        left: AppTheme.appMargin,
        right: AppTheme.appMargin,
      ),
      child: ColorLabelTextFormField(
        key: Key("Purpose"),
        labelText: CirclesLocalizations.of(context).eventFormPurpose,
        helperText: CirclesLocalizations.of(context).eventFormPurposeHelper,
        controller: _purposeController,
      ),
    );

    final users = _visibility == ChannelVisibility.CLOSED ? vm.groupUsers : [];

    return Form(
      key: _key,
      child: Container(
        child: ListView.custom(
          childrenDelegate: SliverChildListDelegate(
            <Widget>[
              nameInput,
              eventTimeRow,
              venueInput,
              purposeInput,
              Visibility(
                visible: _editChannel == null,
                child: _buildSwitch(),
              ),
              _buildInviteUsersHeader(),
              ...users.map((user) => UserItem(
                    user: user,
                    selected: _selectedUsers.contains(user.uid),
                    selectionHandler: _selectUser,
                  )),
            ],
          ),
        ),
        color: Colors.white,
      ),
    );
  }

  Padding _buildName() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24,
        left: AppTheme.appMargin,
        right: AppTheme.appMargin,
      ),
      child: ErrorLabelTextFormField(
          key: Key("TopicName"),
          maxCharacters: 30,
          labelText: CirclesLocalizations.of(context).eventFormName,
          helperText:
              CirclesLocalizations.of(context).channelFormCreateTopicEmptyError,
          controller: _nameController,
          enabled: _editChannel == null,
          validator: (value) {
            if (value.isEmpty) {
              return CirclesLocalizations.of(context)
                  .channelFormCreateTopicEmptyError;
            }
            return null;
          }),
    );
  }

  Padding _buildSwitch() {
    final _switchWidth = 60.0;
    final visibilitySwitch = Padding(
      padding: EdgeInsets.only(
        top: 24.0,
        left: AppTheme.appMargin,
        right: AppTheme.appMargin,
        bottom: 24.0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  CirclesLocalizations.of(context).channelFormCreateTopicPublic,
                  style: AppTheme.switchTitleTextStyle,
                ),
                SizedBox(height: 4),
                Text(
                  CirclesLocalizations.of(context)
                      .channelFormCreateTopicPublicHelper,
                  style: AppTheme.switchSubtitleTextStyle,
                ),
              ],
            ),
          ),
          Container(
              width: _switchWidth,
              child: PlatformSwitch(
                key: Key("Visibility"),
                value: _visibility == ChannelVisibility.OPEN,
                onChanged: (bool value) {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _visibility = value
                        ? ChannelVisibility.OPEN
                        : ChannelVisibility.CLOSED;
                  });
                },
              )),
        ],
      ),
    );
    return visibilitySwitch;
  }

  Widget _buildInviteUsersHeader() {
    return Visibility(
      visible: _visibility == ChannelVisibility.CLOSED,
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(AppTheme.appMargin),
            child: Image.asset(
              "assets/graphics/channel/details_padlock.png",
              height: 36,
            ),
          ),
          Expanded(
            child: Text(
              CirclesLocalizations.of(context)
                  .channelFormCreateTopicPrivateHelper,
              style: AppTheme.topicDetailsItemTextStyle,
            ),
          ),
        ],
      ),
    );
  }

  void _selectUser(User user) {
    Logger.d("Selected user: $user");
    setState(() {
      if (_selectedUsers.contains(user.uid)) {
        _selectedUsers.remove(user.uid);
      } else {
        _selectedUsers.add(user.uid);
      }
    });
  }

  // TODO: Maybe unify with Create Channel module
  void _showAlert(
    BuildContext context,
    String title,
    String content,
  ) {
    showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          PlatformDialogAction(
              child: PlatformText(CirclesLocalizations.of(context).ok),
              onPressed: () {
                // UI clean up
                Navigator.pop(context);
              }),
        ],
      ),
    );
  }

  void _validateAndSubmit() {
    if (_key.currentState.validate()) {
      if (_editChannel == null) {
        _submitCreateChannel();
      } else {
        _submitEditChannel();
      }
    }
  }

  _submitCreateChannel() {
    List<String> members = [];
    if (_visibility == ChannelVisibility.CLOSED) {
      members = _selectedUsers.toList();
      if (members.length == 0) {
        Logger.w("Members list is empty. Select at least one member");
        _showAlert(
          context,
          CirclesLocalizations.of(context).channelCreateTitle,
          CirclesLocalizations.of(context).channelFormSelectMembersError,
        );
        return;
      }
    }
    final Completer completer = _createCompleter();
    _dispatchCreateAction(members, completer);
  }

  Completer _createCompleter() {
    final completer = Completer();
    completer.future.then((val) {
      Navigator.of(context).popUntil(ModalRoute.withName(Routes.home));
    }).catchError((error) {
      _showAlert(
        context,
        CirclesLocalizations.of(context).channelCreateTitle,
        CirclesLocalizations.of(context).channelFormTopicExists,
      );
    });
    return completer;
  }

  void _dispatchCreateAction(List<String> members, Completer completer) {
    final provider = StoreProvider.of<AppState>(context);
    provider.dispatch(CreateChannel(
      Channel((c) => c
        ..type = ChannelType.EVENT
        ..name = _nameController.text
        ..description = _purposeController.text ?? ""
        ..venue = _venueController.text
        ..startDate = _calculateStartDate()
        ..hasStartTime = _timeController.value != null
        ..visibility = _visibility
        ..authorId = provider.state.user.uid),
      BuiltList<String>(members),
      completer,
    ));
  }

  DateTime _calculateStartDate() {
    final date = _dateController.value;
    final year = date.year;
    final month = date.month;
    final day = date.day;
    final time = _timeController.value;
    if (time != null) {
      return DateTime(year, month, day, time.hour, time.minute);
    }
    // The time of the event is at the end of the day when there's no time set
    // https://github.com/janoodleFTW/flutter-app/issues/248
    return DateTime(year, month, day, 23, 59);
  }

  void _submitEditChannel() {
    final completer = Completer();
    completer.future.then((val) {
      Navigator.of(context).popUntil(ModalRoute.withName(Routes.home));
    }).catchError((error) {
      // TODO: Log or display error
    });
    final provider = StoreProvider.of<AppState>(context);
    provider.dispatch(EditChannelAction(
      _editChannel.rebuild((c) => c
        ..description = _purposeController.text ?? ""
        ..venue = _venueController.text
        ..startDate = _calculateStartDate()
        ..hasStartTime = _timeController.value != null),
      completer,
    ));
  }
}

class _ViewModel {
  final List<String> channels;
  final List<User> groupUsers;

  const _ViewModel({
    this.channels,
    this.groupUsers,
  });

  bool hasChannelNamed(String name) {
    return channels.contains(name.toLowerCase());
  }

  static _ViewModel fromStore(Store<AppState> store) {
    final state = store.state;
    var channels;
    if (state.selectedGroupId != null &&
        state.groups[state.selectedGroupId] != null) {
      final channelNames = state.groups[state.selectedGroupId].channels.values
          .map((c) => c.name.toLowerCase())
          .toList();
      channels = channelNames ?? [];
    }

    final users = state.groupUsers.toList();
    users.remove(state.user);

    return _ViewModel(
      channels: channels,
      groupUsers: users,
    );
  }
}
