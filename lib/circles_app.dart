import "package:circles_app/data/calendar_repository.dart";
import "package:circles_app/data/group_repository.dart";
import "package:circles_app/data/file_repository.dart";
import "package:circles_app/data/user_repository.dart";
import "package:circles_app/domain/redux/attachment/attachment_middleware.dart";
import "package:circles_app/domain/redux/attachment/image_processor.dart";
import "package:circles_app/domain/redux/authentication/auth_actions.dart";
import "package:circles_app/domain/redux/authentication/auth_middleware.dart";
import "package:circles_app/domain/redux/calendar/calendar_middleware.dart";
import "package:circles_app/domain/redux/channel/channel_middleware.dart";
import "package:circles_app/data/message_repository.dart";
import "package:circles_app/domain/redux/message/message_middleware.dart";
import "package:circles_app/data/channel_repository.dart";
import "package:circles_app/circles_localization.dart";
import "package:circles_app/domain/redux/push/push_actions.dart";
import "package:circles_app/domain/redux/push/push_middleware.dart";
import "package:circles_app/domain/redux/user/user_middleware.dart";
import "package:circles_app/presentation/channel/create/create_channel.dart";
import "package:circles_app/presentation/channel/event/create_event.dart";
import "package:circles_app/presentation/channel/invite/invite_to_channel_screen.dart";
import "package:circles_app/presentation/channel/reaction/reaction_details.dart";
import "package:circles_app/domain/redux/app_middleware.dart";
import "package:circles_app/domain/redux/app_reducer.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/presentation/home/main_screen.dart";
import "package:circles_app/presentation/image/file_picker_screen.dart";
import "package:circles_app/presentation/image/image_pinch_screen.dart";
import "package:circles_app/presentation/image/image_screen.dart";
import "package:circles_app/presentation/login/loginscreen.dart";
import "package:circles_app/presentation/settings/settings_screen.dart";
import "package:circles_app/presentation/user/user_screen.dart";
import "package:circles_app/routes.dart";
import "package:circles_app/theme.dart";
import "package:circles_app/util/logger.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:redux/redux.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "domain/redux/user/user_actions.dart";

class CirclesApp extends StatefulWidget {
  const CirclesApp({
    Key key,
  }) : super(key: key);

  @override
  _CirclesAppState createState() => _CirclesAppState();
}

class _CirclesAppState extends State<CirclesApp> {
  Store<AppState> store;
  static final _navigatorKey = GlobalKey<NavigatorState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final userRepo = UserRepository(FirebaseAuth.instance, Firestore.instance);
  final channelRepository = ChannelRepository(Firestore.instance);
  final groupRepository = GroupRepository(Firestore.instance);
  final calendarRepository = CalendarRepository(Firestore.instance);

  @override
  void initState() {
    super.initState();
    store = Store<AppState>(
      appReducer,
      initialState: AppState.init(),
      middleware: createStoreMiddleware(
        groupRepository,
      )
        ..addAll(createAuthenticationMiddleware(
          userRepo,
          _navigatorKey,
        ))
        ..addAll(createCalendarMiddleware(calendarRepository))
        ..addAll(createUserMiddleware(userRepo))
        ..addAll(createChannelsMiddleware(
          channelRepository,
          _navigatorKey,
        ))
        ..addAll(createMessagesMiddleware(
          MessageRepository(Firestore.instance),
        ))
        ..addAll(createPushMiddleware(
          userRepo,
          _firebaseMessaging,
          groupRepository,
          channelRepository,
        ))
        ..addAll(createAttachmentMiddleware(
          FileRepository(FirebaseStorage.instance),
          ImageProcessor(),
          userRepo,
        )),
    );
    store.dispatch(VerifyAuthenticationState());
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        store.dispatch(OnPushNotificationReceivedAction(message));
      },
      onLaunch: (Map<String, dynamic> message) async {
        store.dispatch(OnPushNotificationOpenAction(message));
      },
      onResume: (Map<String, dynamic> message) async {
        store.dispatch(OnPushNotificationOpenAction(message));
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      Logger.d("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      Logger.d("Push Messaging token: $token");
      store.dispatch(UpdateUserTokenAction(token));
    });
  }

  // Used to propagate this users current locale to our backend (which then can send localized notifications).
  _updateUserLocale(context) {
    final localeCode = CirclesLocalizations.of(context).locale.languageCode;
    StoreProvider.of<AppState>(context)
        .dispatch(UpdateUserLocaleAction(localeCode));
  }

  @override
  Widget build(BuildContext context) {

    return StoreProvider(
      store: store,
      child: MaterialApp(
        localizationsDelegates: localizationsDelegates,
        supportedLocales: [
          const Locale("de", "DE"),
          const Locale("en", "EN"),
          const Locale("pt_BR", "PT"),
        ],
        title: "Circles App",
        navigatorKey: _navigatorKey,
        theme: AppTheme.theme,
        routes: {
          Routes.login: (context) {
            return LoginScreen();
          },
          Routes.home: (context) {
            // We need a context and a user. Both are present when loading MainScreen.
            _updateUserLocale(context);
            return MainScreen();
          },
          Routes.channelNew: (context) {
            return CreateChannelScreen();
          },
          Routes.channelInvite: (context) {
            return InviteToChannelScreen();
          },
          Routes.eventNew: (context) {
            return CreateEventScreen();
          },
          Routes.image: (context) {
            return ImageScreen();
          },
          Routes.imagePicker: (context) {
            return FilePickerScreen();
          },
          Routes.imagePinch: (context) {
            return ImagePinchScreen();
          },
          Routes.reaction: (context) {
            return ReactionDetails();
          },
          Routes.user: (context) {
            return UserScreen();
          },
          Routes.settings: (context) {
            return SettingsScreen();
          }
        },
      ),
    );
  }
}
