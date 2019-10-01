// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messages_list_viewmodel.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MessagesListViewModel extends MessagesListViewModel {
  @override
  final User currentUser;
  @override
  final BuiltList<Message> messages;
  @override
  final bool userIsMember;
  @override
  final BuiltMap<String, User> authors;

  factory _$MessagesListViewModel(
          [void Function(MessagesListViewModelBuilder) updates]) =>
      (new MessagesListViewModelBuilder()..update(updates)).build();

  _$MessagesListViewModel._(
      {this.currentUser, this.messages, this.userIsMember, this.authors})
      : super._() {
    if (messages == null) {
      throw new BuiltValueNullFieldError('MessagesListViewModel', 'messages');
    }
    if (userIsMember == null) {
      throw new BuiltValueNullFieldError(
          'MessagesListViewModel', 'userIsMember');
    }
    if (authors == null) {
      throw new BuiltValueNullFieldError('MessagesListViewModel', 'authors');
    }
  }

  @override
  MessagesListViewModel rebuild(
          void Function(MessagesListViewModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MessagesListViewModelBuilder toBuilder() =>
      new MessagesListViewModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MessagesListViewModel &&
        currentUser == other.currentUser &&
        messages == other.messages &&
        userIsMember == other.userIsMember &&
        authors == other.authors;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc(0, currentUser.hashCode), messages.hashCode),
            userIsMember.hashCode),
        authors.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('MessagesListViewModel')
          ..add('currentUser', currentUser)
          ..add('messages', messages)
          ..add('userIsMember', userIsMember)
          ..add('authors', authors))
        .toString();
  }
}

class MessagesListViewModelBuilder
    implements Builder<MessagesListViewModel, MessagesListViewModelBuilder> {
  _$MessagesListViewModel _$v;

  UserBuilder _currentUser;
  UserBuilder get currentUser => _$this._currentUser ??= new UserBuilder();
  set currentUser(UserBuilder currentUser) => _$this._currentUser = currentUser;

  ListBuilder<Message> _messages;
  ListBuilder<Message> get messages =>
      _$this._messages ??= new ListBuilder<Message>();
  set messages(ListBuilder<Message> messages) => _$this._messages = messages;

  bool _userIsMember;
  bool get userIsMember => _$this._userIsMember;
  set userIsMember(bool userIsMember) => _$this._userIsMember = userIsMember;

  MapBuilder<String, User> _authors;
  MapBuilder<String, User> get authors =>
      _$this._authors ??= new MapBuilder<String, User>();
  set authors(MapBuilder<String, User> authors) => _$this._authors = authors;

  MessagesListViewModelBuilder();

  MessagesListViewModelBuilder get _$this {
    if (_$v != null) {
      _currentUser = _$v.currentUser?.toBuilder();
      _messages = _$v.messages?.toBuilder();
      _userIsMember = _$v.userIsMember;
      _authors = _$v.authors?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MessagesListViewModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$MessagesListViewModel;
  }

  @override
  void update(void Function(MessagesListViewModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$MessagesListViewModel build() {
    _$MessagesListViewModel _$result;
    try {
      _$result = _$v ??
          new _$MessagesListViewModel._(
              currentUser: _currentUser?.build(),
              messages: messages.build(),
              userIsMember: userIsMember,
              authors: authors.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'currentUser';
        _currentUser?.build();
        _$failedField = 'messages';
        messages.build();

        _$failedField = 'authors';
        authors.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'MessagesListViewModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
