import "package:circles_app/data/file_repository.dart";
import "package:circles_app/data/user_repository.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/domain/redux/attachment/attachment_actions.dart";
import "package:circles_app/domain/redux/attachment/image_processor.dart";
import "package:circles_app/domain/redux/user/user_actions.dart";
import "package:circles_app/native_channels/upload_platform.dart";
import "package:circles_app/util/logger.dart";
import "package:redux/redux.dart";

List<Middleware<AppState>> createAttachmentMiddleware(
  FileRepository fileRepository,
  ImageProcessor imageProcessor,
  UserRepository userRepository,
) {
  return [
    TypedMiddleware<AppState, NewMessageWithMultipleFilesAction>(
        _newMessageWithMultipleFiles()),
    TypedMiddleware<AppState, ChangeAvatarAction>(_changeAvatar(
      fileRepository,
      imageProcessor,
      userRepository,
    )),
  ];
}

void Function(
  Store<AppState> store,
  NewMessageWithMultipleFilesAction action,
  NextDispatcher next,
) _newMessageWithMultipleFiles() {
  return (store, action, next) {
    next(action);
    
    UploadPlatform().uploadFiles(
      filePaths: action.isPath ? action.fileIdentifiers : [],
      localIdentifiers: action.isPath ? [] : action.fileIdentifiers,
      groupId: store.state.selectedGroupId,
      channelId: store.state.channelState.selectedChannel,
    );
  };
}

void Function(
  Store<AppState> store,
  ChangeAvatarAction action,
  NextDispatcher next,
) _changeAvatar(
  FileRepository repository,
  ImageProcessor imageProcessor,
  UserRepository userRepository,
) {
  return (store, action, next) async {
    next(action);
    // TODO: proper error handling when the Avatar upload screens are
    //  implemented
    if (store.state.user.uid != action.user.uid) {
      Logger.w("Cannot change other user's pictures");
      return;
    }
    try {
      final file = await imageProcessor.cropAndResizeAvatar(action.file);
      final url = await repository.uploadFile(file);
      final user = action.user.rebuild((u) => u..image = url);
      await userRepository.updateUser(user);
      store.dispatch(OnUserUpdateAction(user));
    } catch (error) {
      Logger.e(error.toString(), s: StackTrace.current);
    }
  };
}
