// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Group extends Group {
  @override
  final String id;
  @override
  final String name;
  @override
  final String hexColor;
  @override
  final String image;
  @override
  final String abbreviation;
  @override
  final BuiltMap<String, Channel> channels;

  factory _$Group([void Function(GroupBuilder) updates]) =>
      (new GroupBuilder()..update(updates)).build();

  _$Group._(
      {this.id,
      this.name,
      this.hexColor,
      this.image,
      this.abbreviation,
      this.channels})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Group', 'id');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('Group', 'name');
    }
    if (hexColor == null) {
      throw new BuiltValueNullFieldError('Group', 'hexColor');
    }
    if (abbreviation == null) {
      throw new BuiltValueNullFieldError('Group', 'abbreviation');
    }
    if (channels == null) {
      throw new BuiltValueNullFieldError('Group', 'channels');
    }
  }

  @override
  Group rebuild(void Function(GroupBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GroupBuilder toBuilder() => new GroupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Group &&
        id == other.id &&
        name == other.name &&
        hexColor == other.hexColor &&
        image == other.image &&
        abbreviation == other.abbreviation &&
        channels == other.channels;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc($jc(0, id.hashCode), name.hashCode), hexColor.hashCode),
                image.hashCode),
            abbreviation.hashCode),
        channels.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Group')
          ..add('id', id)
          ..add('name', name)
          ..add('hexColor', hexColor)
          ..add('image', image)
          ..add('abbreviation', abbreviation)
          ..add('channels', channels))
        .toString();
  }
}

class GroupBuilder implements Builder<Group, GroupBuilder> {
  _$Group _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _hexColor;
  String get hexColor => _$this._hexColor;
  set hexColor(String hexColor) => _$this._hexColor = hexColor;

  String _image;
  String get image => _$this._image;
  set image(String image) => _$this._image = image;

  String _abbreviation;
  String get abbreviation => _$this._abbreviation;
  set abbreviation(String abbreviation) => _$this._abbreviation = abbreviation;

  MapBuilder<String, Channel> _channels;
  MapBuilder<String, Channel> get channels =>
      _$this._channels ??= new MapBuilder<String, Channel>();
  set channels(MapBuilder<String, Channel> channels) =>
      _$this._channels = channels;

  GroupBuilder();

  GroupBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _name = _$v.name;
      _hexColor = _$v.hexColor;
      _image = _$v.image;
      _abbreviation = _$v.abbreviation;
      _channels = _$v.channels?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Group other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Group;
  }

  @override
  void update(void Function(GroupBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Group build() {
    _$Group _$result;
    try {
      _$result = _$v ??
          new _$Group._(
              id: id,
              name: name,
              hexColor: hexColor,
              image: image,
              abbreviation: abbreviation,
              channels: channels.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'channels';
        channels.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Group', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
