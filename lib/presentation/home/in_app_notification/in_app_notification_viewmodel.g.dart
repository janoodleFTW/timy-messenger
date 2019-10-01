// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'in_app_notification_viewmodel.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InAppNotificationViewModel extends InAppNotificationViewModel {
  @override
  final InAppNotification inAppNotification;
  @override
  final Function onDismissed;
  @override
  final Function onTap;

  factory _$InAppNotificationViewModel(
          [void Function(InAppNotificationViewModelBuilder) updates]) =>
      (new InAppNotificationViewModelBuilder()..update(updates)).build();

  _$InAppNotificationViewModel._(
      {this.inAppNotification, this.onDismissed, this.onTap})
      : super._() {
    if (onDismissed == null) {
      throw new BuiltValueNullFieldError(
          'InAppNotificationViewModel', 'onDismissed');
    }
    if (onTap == null) {
      throw new BuiltValueNullFieldError('InAppNotificationViewModel', 'onTap');
    }
  }

  @override
  InAppNotificationViewModel rebuild(
          void Function(InAppNotificationViewModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InAppNotificationViewModelBuilder toBuilder() =>
      new InAppNotificationViewModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InAppNotificationViewModel &&
        inAppNotification == other.inAppNotification;
  }

  @override
  int get hashCode {
    return $jf($jc(0, inAppNotification.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('InAppNotificationViewModel')
          ..add('inAppNotification', inAppNotification)
          ..add('onDismissed', onDismissed)
          ..add('onTap', onTap))
        .toString();
  }
}

class InAppNotificationViewModelBuilder
    implements
        Builder<InAppNotificationViewModel, InAppNotificationViewModelBuilder> {
  _$InAppNotificationViewModel _$v;

  InAppNotificationBuilder _inAppNotification;
  InAppNotificationBuilder get inAppNotification =>
      _$this._inAppNotification ??= new InAppNotificationBuilder();
  set inAppNotification(InAppNotificationBuilder inAppNotification) =>
      _$this._inAppNotification = inAppNotification;

  Function _onDismissed;
  Function get onDismissed => _$this._onDismissed;
  set onDismissed(Function onDismissed) => _$this._onDismissed = onDismissed;

  Function _onTap;
  Function get onTap => _$this._onTap;
  set onTap(Function onTap) => _$this._onTap = onTap;

  InAppNotificationViewModelBuilder();

  InAppNotificationViewModelBuilder get _$this {
    if (_$v != null) {
      _inAppNotification = _$v.inAppNotification?.toBuilder();
      _onDismissed = _$v.onDismissed;
      _onTap = _$v.onTap;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InAppNotificationViewModel other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$InAppNotificationViewModel;
  }

  @override
  void update(void Function(InAppNotificationViewModelBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$InAppNotificationViewModel build() {
    _$InAppNotificationViewModel _$result;
    try {
      _$result = _$v ??
          new _$InAppNotificationViewModel._(
              inAppNotification: _inAppNotification?.build(),
              onDismissed: onDismissed,
              onTap: onTap);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'inAppNotification';
        _inAppNotification?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'InAppNotificationViewModel', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
