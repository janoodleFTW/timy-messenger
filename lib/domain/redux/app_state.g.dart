// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AppState extends AppState {
  @override
  final BuiltList<CalendarEntry> userCalendar;
  @override
  final BuiltMap<String, Group> groups;
  @override
  final String selectedGroupId;
  @override
  final User user;
  @override
  final BuiltList<User> groupUsers;
  @override
  final ChannelState channelState;
  @override
  final BuiltList<Message> messagesOnScreen;
  @override
  final String fcmToken;
  @override
  final InAppNotification inAppNotification;
  @override
  final UiState uiState;

  factory _$AppState([void Function(AppStateBuilder) updates]) =>
      (new AppStateBuilder()..update(updates)).build();

  _$AppState._(
      {this.userCalendar,
      this.groups,
      this.selectedGroupId,
      this.user,
      this.groupUsers,
      this.channelState,
      this.messagesOnScreen,
      this.fcmToken,
      this.inAppNotification,
      this.uiState})
      : super._() {
    if (userCalendar == null) {
      throw new BuiltValueNullFieldError('AppState', 'userCalendar');
    }
    if (groups == null) {
      throw new BuiltValueNullFieldError('AppState', 'groups');
    }
    if (groupUsers == null) {
      throw new BuiltValueNullFieldError('AppState', 'groupUsers');
    }
    if (channelState == null) {
      throw new BuiltValueNullFieldError('AppState', 'channelState');
    }
    if (messagesOnScreen == null) {
      throw new BuiltValueNullFieldError('AppState', 'messagesOnScreen');
    }
    if (uiState == null) {
      throw new BuiltValueNullFieldError('AppState', 'uiState');
    }
  }

  @override
  AppState rebuild(void Function(AppStateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AppStateBuilder toBuilder() => new AppStateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AppState &&
        userCalendar == other.userCalendar &&
        groups == other.groups &&
        selectedGroupId == other.selectedGroupId &&
        user == other.user &&
        groupUsers == other.groupUsers &&
        channelState == other.channelState &&
        messagesOnScreen == other.messagesOnScreen &&
        fcmToken == other.fcmToken &&
        inAppNotification == other.inAppNotification &&
        uiState == other.uiState;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc($jc(0, userCalendar.hashCode),
                                        groups.hashCode),
                                    selectedGroupId.hashCode),
                                user.hashCode),
                            groupUsers.hashCode),
                        channelState.hashCode),
                    messagesOnScreen.hashCode),
                fcmToken.hashCode),
            inAppNotification.hashCode),
        uiState.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('AppState')
          ..add('userCalendar', userCalendar)
          ..add('groups', groups)
          ..add('selectedGroupId', selectedGroupId)
          ..add('user', user)
          ..add('groupUsers', groupUsers)
          ..add('channelState', channelState)
          ..add('messagesOnScreen', messagesOnScreen)
          ..add('fcmToken', fcmToken)
          ..add('inAppNotification', inAppNotification)
          ..add('uiState', uiState))
        .toString();
  }
}

class AppStateBuilder implements Builder<AppState, AppStateBuilder> {
  _$AppState _$v;

  ListBuilder<CalendarEntry> _userCalendar;
  ListBuilder<CalendarEntry> get userCalendar =>
      _$this._userCalendar ??= new ListBuilder<CalendarEntry>();
  set userCalendar(ListBuilder<CalendarEntry> userCalendar) =>
      _$this._userCalendar = userCalendar;

  MapBuilder<String, Group> _groups;
  MapBuilder<String, Group> get groups =>
      _$this._groups ??= new MapBuilder<String, Group>();
  set groups(MapBuilder<String, Group> groups) => _$this._groups = groups;

  String _selectedGroupId;
  String get selectedGroupId => _$this._selectedGroupId;
  set selectedGroupId(String selectedGroupId) =>
      _$this._selectedGroupId = selectedGroupId;

  UserBuilder _user;
  UserBuilder get user => _$this._user ??= new UserBuilder();
  set user(UserBuilder user) => _$this._user = user;

  ListBuilder<User> _groupUsers;
  ListBuilder<User> get groupUsers =>
      _$this._groupUsers ??= new ListBuilder<User>();
  set groupUsers(ListBuilder<User> groupUsers) =>
      _$this._groupUsers = groupUsers;

  ChannelStateBuilder _channelState;
  ChannelStateBuilder get channelState =>
      _$this._channelState ??= new ChannelStateBuilder();
  set channelState(ChannelStateBuilder channelState) =>
      _$this._channelState = channelState;

  ListBuilder<Message> _messagesOnScreen;
  ListBuilder<Message> get messagesOnScreen =>
      _$this._messagesOnScreen ??= new ListBuilder<Message>();
  set messagesOnScreen(ListBuilder<Message> messagesOnScreen) =>
      _$this._messagesOnScreen = messagesOnScreen;

  String _fcmToken;
  String get fcmToken => _$this._fcmToken;
  set fcmToken(String fcmToken) => _$this._fcmToken = fcmToken;

  InAppNotificationBuilder _inAppNotification;
  InAppNotificationBuilder get inAppNotification =>
      _$this._inAppNotification ??= new InAppNotificationBuilder();
  set inAppNotification(InAppNotificationBuilder inAppNotification) =>
      _$this._inAppNotification = inAppNotification;

  UiStateBuilder _uiState;
  UiStateBuilder get uiState => _$this._uiState ??= new UiStateBuilder();
  set uiState(UiStateBuilder uiState) => _$this._uiState = uiState;

  AppStateBuilder();

  AppStateBuilder get _$this {
    if (_$v != null) {
      _userCalendar = _$v.userCalendar?.toBuilder();
      _groups = _$v.groups?.toBuilder();
      _selectedGroupId = _$v.selectedGroupId;
      _user = _$v.user?.toBuilder();
      _groupUsers = _$v.groupUsers?.toBuilder();
      _channelState = _$v.channelState?.toBuilder();
      _messagesOnScreen = _$v.messagesOnScreen?.toBuilder();
      _fcmToken = _$v.fcmToken;
      _inAppNotification = _$v.inAppNotification?.toBuilder();
      _uiState = _$v.uiState?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AppState other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$AppState;
  }

  @override
  void update(void Function(AppStateBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$AppState build() {
    _$AppState _$result;
    try {
      _$result = _$v ??
          new _$AppState._(
              userCalendar: userCalendar.build(),
              groups: groups.build(),
              selectedGroupId: selectedGroupId,
              user: _user?.build(),
              groupUsers: groupUsers.build(),
              channelState: channelState.build(),
              messagesOnScreen: messagesOnScreen.build(),
              fcmToken: fcmToken,
              inAppNotification: _inAppNotification?.build(),
              uiState: uiState.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'userCalendar';
        userCalendar.build();
        _$failedField = 'groups';
        groups.build();

        _$failedField = 'user';
        _user?.build();
        _$failedField = 'groupUsers';
        groupUsers.build();
        _$failedField = 'channelState';
        channelState.build();
        _$failedField = 'messagesOnScreen';
        messagesOnScreen.build();

        _$failedField = 'inAppNotification';
        _inAppNotification?.build();
        _$failedField = 'uiState';
        uiState.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'AppState', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
