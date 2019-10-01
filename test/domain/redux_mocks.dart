import "package:circles_app/data/channel_repository.dart";
import "package:circles_app/data/group_repository.dart";
import "package:circles_app/data/file_repository.dart";
import "package:circles_app/data/message_repository.dart";
import "package:circles_app/data/user_repository.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/foundation.dart";
import "package:mockito/mockito.dart";
import "package:redux/redux.dart";
import "package:flutter/widgets.dart" as w;

class MockGroupRepository extends Mock implements GroupRepository {}

class MockChannelsRepository extends Mock implements ChannelRepository {}

class MockMessageRepository extends Mock implements MessageRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockFileRepository extends Mock implements FileRepository {}

class MockFirebaseMessaging extends Mock implements FirebaseMessaging {}

class MockMiddleware extends Mock implements MiddlewareClass<AppState> {}

// ignore: must_be_immutable
class MockGlobalKey extends Mock implements w.GlobalKey<w.NavigatorState> {}

class MockNavigatorState extends Mock implements w.NavigatorState {
  @override
  // ignore: invalid_override_different_default_values_named
  String toString({DiagnosticLevel minLevel}) => "";
}
