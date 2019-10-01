// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Message extends Message {
  @override
  final String id;
  @override
  final String authorId;
  @override
  final String body;
  @override
  final BuiltMap<String, Reaction> reactions;
  @override
  final MessageType messageType;
  @override
  final bool pending;
  @override
  final DateTime timestamp;
  @override
  final BuiltList<String> media;
  @override
  final MediaStatus mediaStatus;
  @override
  final double mediaAspectRatio;

  factory _$Message([void Function(MessageBuilder) updates]) =>
      (new MessageBuilder()..update(updates)).build() as _$Message;

  _$Message._(
      {this.id,
      this.authorId,
      this.body,
      this.reactions,
      this.messageType,
      this.pending,
      this.timestamp,
      this.media,
      this.mediaStatus,
      this.mediaAspectRatio})
      : super._() {
    if (body == null) {
      throw new BuiltValueNullFieldError('Message', 'body');
    }
    if (reactions == null) {
      throw new BuiltValueNullFieldError('Message', 'reactions');
    }
    if (messageType == null) {
      throw new BuiltValueNullFieldError('Message', 'messageType');
    }
    if (pending == null) {
      throw new BuiltValueNullFieldError('Message', 'pending');
    }
    if (timestamp == null) {
      throw new BuiltValueNullFieldError('Message', 'timestamp');
    }
    if (media == null) {
      throw new BuiltValueNullFieldError('Message', 'media');
    }
  }

  @override
  Message rebuild(void Function(MessageBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  _$MessageBuilder toBuilder() => new _$MessageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Message &&
        id == other.id &&
        authorId == other.authorId &&
        body == other.body &&
        reactions == other.reactions &&
        messageType == other.messageType &&
        pending == other.pending &&
        timestamp == other.timestamp &&
        media == other.media &&
        mediaStatus == other.mediaStatus &&
        mediaAspectRatio == other.mediaAspectRatio;
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
                                $jc($jc($jc(0, id.hashCode), authorId.hashCode),
                                    body.hashCode),
                                reactions.hashCode),
                            messageType.hashCode),
                        pending.hashCode),
                    timestamp.hashCode),
                media.hashCode),
            mediaStatus.hashCode),
        mediaAspectRatio.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Message')
          ..add('id', id)
          ..add('authorId', authorId)
          ..add('body', body)
          ..add('reactions', reactions)
          ..add('messageType', messageType)
          ..add('pending', pending)
          ..add('timestamp', timestamp)
          ..add('media', media)
          ..add('mediaStatus', mediaStatus)
          ..add('mediaAspectRatio', mediaAspectRatio))
        .toString();
  }
}

class _$MessageBuilder extends MessageBuilder {
  _$Message _$v;

  @override
  String get id {
    _$this;
    return super.id;
  }

  @override
  set id(String id) {
    _$this;
    super.id = id;
  }

  @override
  String get authorId {
    _$this;
    return super.authorId;
  }

  @override
  set authorId(String authorId) {
    _$this;
    super.authorId = authorId;
  }

  @override
  String get body {
    _$this;
    return super.body;
  }

  @override
  set body(String body) {
    _$this;
    super.body = body;
  }

  @override
  MapBuilder<String, Reaction> get reactions {
    _$this;
    return super.reactions ??= new MapBuilder<String, Reaction>();
  }

  @override
  set reactions(MapBuilder<String, Reaction> reactions) {
    _$this;
    super.reactions = reactions;
  }

  @override
  MessageType get messageType {
    _$this;
    return super.messageType;
  }

  @override
  set messageType(MessageType messageType) {
    _$this;
    super.messageType = messageType;
  }

  @override
  bool get pending {
    _$this;
    return super.pending;
  }

  @override
  set pending(bool pending) {
    _$this;
    super.pending = pending;
  }

  @override
  DateTime get timestamp {
    _$this;
    return super.timestamp;
  }

  @override
  set timestamp(DateTime timestamp) {
    _$this;
    super.timestamp = timestamp;
  }

  @override
  ListBuilder<String> get media {
    _$this;
    return super.media ??= new ListBuilder<String>();
  }

  @override
  set media(ListBuilder<String> media) {
    _$this;
    super.media = media;
  }

  @override
  MediaStatus get mediaStatus {
    _$this;
    return super.mediaStatus;
  }

  @override
  set mediaStatus(MediaStatus mediaStatus) {
    _$this;
    super.mediaStatus = mediaStatus;
  }

  @override
  double get mediaAspectRatio {
    _$this;
    return super.mediaAspectRatio;
  }

  @override
  set mediaAspectRatio(double mediaAspectRatio) {
    _$this;
    super.mediaAspectRatio = mediaAspectRatio;
  }

  _$MessageBuilder() : super._();

  MessageBuilder get _$this {
    if (_$v != null) {
      super.id = _$v.id;
      super.authorId = _$v.authorId;
      super.body = _$v.body;
      super.reactions = _$v.reactions?.toBuilder();
      super.messageType = _$v.messageType;
      super.pending = _$v.pending;
      super.timestamp = _$v.timestamp;
      super.media = _$v.media?.toBuilder();
      super.mediaStatus = _$v.mediaStatus;
      super.mediaAspectRatio = _$v.mediaAspectRatio;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Message other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Message;
  }

  @override
  void update(void Function(MessageBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Message build() {
    _$Message _$result;
    try {
      _$result = _$v ??
          new _$Message._(
              id: id,
              authorId: authorId,
              body: body,
              reactions: reactions.build(),
              messageType: messageType,
              pending: pending,
              timestamp: timestamp,
              media: media.build(),
              mediaStatus: mediaStatus,
              mediaAspectRatio: mediaAspectRatio);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'reactions';
        reactions.build();

        _$failedField = 'media';
        media.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Message', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
