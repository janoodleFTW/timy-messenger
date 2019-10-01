// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$User extends User {
  @override
  final String uid;
  @override
  final String email;
  @override
  final String name;
  @override
  final String status;
  @override
  final BuiltMap<String, BuiltList> unreadUpdates;
  @override
  final String image;

  factory _$User([void Function(UserBuilder) updates]) =>
      (new UserBuilder()..update(updates)).build();

  _$User._(
      {this.uid,
      this.email,
      this.name,
      this.status,
      this.unreadUpdates,
      this.image})
      : super._() {
    if (uid == null) {
      throw new BuiltValueNullFieldError('User', 'uid');
    }
    if (email == null) {
      throw new BuiltValueNullFieldError('User', 'email');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('User', 'name');
    }
  }

  @override
  User rebuild(void Function(UserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserBuilder toBuilder() => new UserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
        uid == other.uid &&
        email == other.email &&
        name == other.name &&
        status == other.status &&
        unreadUpdates == other.unreadUpdates &&
        image == other.image;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc($jc(0, uid.hashCode), email.hashCode), name.hashCode),
                status.hashCode),
            unreadUpdates.hashCode),
        image.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('User')
          ..add('uid', uid)
          ..add('email', email)
          ..add('name', name)
          ..add('status', status)
          ..add('unreadUpdates', unreadUpdates)
          ..add('image', image))
        .toString();
  }
}

class UserBuilder implements Builder<User, UserBuilder> {
  _$User _$v;

  String _uid;
  String get uid => _$this._uid;
  set uid(String uid) => _$this._uid = uid;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _status;
  String get status => _$this._status;
  set status(String status) => _$this._status = status;

  MapBuilder<String, BuiltList> _unreadUpdates;
  MapBuilder<String, BuiltList> get unreadUpdates =>
      _$this._unreadUpdates ??= new MapBuilder<String, BuiltList>();
  set unreadUpdates(MapBuilder<String, BuiltList> unreadUpdates) =>
      _$this._unreadUpdates = unreadUpdates;

  String _image;
  String get image => _$this._image;
  set image(String image) => _$this._image = image;

  UserBuilder();

  UserBuilder get _$this {
    if (_$v != null) {
      _uid = _$v.uid;
      _email = _$v.email;
      _name = _$v.name;
      _status = _$v.status;
      _unreadUpdates = _$v.unreadUpdates?.toBuilder();
      _image = _$v.image;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(User other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$User;
  }

  @override
  void update(void Function(UserBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$User build() {
    _$User _$result;
    try {
      _$result = _$v ??
          new _$User._(
              uid: uid,
              email: email,
              name: name,
              status: status,
              unreadUpdates: _unreadUpdates?.build(),
              image: image);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'unreadUpdates';
        _unreadUpdates?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'User', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
