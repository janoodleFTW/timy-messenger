import "package:circles_app/domain/redux/app_reducer.dart";
import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/model/group.dart";
import "package:circles_app/model/user.dart";
import "package:circles_app/presentation/channel/invite/invite_to_channel_viewmodel.dart";
import "package:flutter_test/flutter_test.dart";
import "package:redux/redux.dart";

main() {
  group("Invite To Channel ViewModel", () {
    test("should list users that are not already in the channel", () {
      final user = User((u) => u
        ..uid = "user"
        ..email = "email"
        ..name = "name");

      // Group has three users: 1, 2, 3
      final user1 = user.rebuild((u) => u..uid = "user1");
      final user2 = user.rebuild((u) => u..uid = "user2");
      final user3 = user.rebuild((u) => u..uid = "user3");

      // User 1 and 2 are already in the channel
      final channelUser1 = ChannelUser((u) => u
        ..id = "user1"
        ..rsvp = RSVP.UNSET);
      final channelUser2 = ChannelUser((u) => u
        ..id = "user2"
        ..rsvp = RSVP.UNSET);

      final store = Store<AppState>(appReducer,
          initialState: AppState.init().rebuild((s) => s
            ..groupUsers.replace([user1, user2, user3])
            ..selectedGroupId = "groupId"
            ..groups.replace({
              "groupId": Group((g) => g
                ..id = "groupId"
                ..name = "group"
                ..hexColor = ""
                ..abbreviation = ""
                ..channels.replace({
                  "channelId": Channel((c) => c
                    ..id = "channelId"
                    ..name = "name"
                    ..visibility = ChannelVisibility.CLOSED
                    ..type = ChannelType.EVENT
                    ..users.replace([channelUser1, channelUser2]))
                }))
            })));

      final vm = InviteToChannelViewModel.fromStore("channelId")(store);

      // Only user 3 should appear in the list
      expect(vm.newUsers, [user3]);
    });
  });
}
