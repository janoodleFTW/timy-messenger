import "package:circles_app/domain/redux/app_state.dart";
import "package:circles_app/model/channel.dart";
import "package:circles_app/presentation/home/channel_list/channel_list_item.dart";
import "package:circles_app/presentation/home/channel_list/channel_list_viewmodel.dart";
import "package:flutter_test/flutter_test.dart";
import "package:redux/redux.dart";

import "../../data/data_mocks.dart";

main() {
  group("Channel List ViewModel", () {
    test("should show list of joined topics", () {
      final appState = AppState.init().rebuild((a) => a
        ..user = mockUser.toBuilder()
        ..selectedGroupId = "groupId"
        ..groups.replace({
          "groupId": mockGroup.rebuild((g) => g
            ..channels.replace({
              "channel1": mockChannel.rebuild((c) => c
                ..type = ChannelType.TOPIC),
              "channel2": mockChannel.rebuild((c) => c
                ..type = ChannelType.TOPIC),
              "channel3": mockChannel.rebuild((c) => c
                ..type = ChannelType.TOPIC),
              "channel4": mockChannel.rebuild((c) => c
                ..type = ChannelType.TOPIC),
            }))
        }));
      final store = Store(null, initialState: appState);

      final vm = ChannelListViewModel.fromStore(store);

      // Group header
      expect(vm.items[0] is ChannelListHeadingItem, true);
      // Events (empty)
      expect(vm.items[1] is ChannelListActionItem, true);
      // Topics
      expect(vm.items[2] is ChannelListActionItem, true);
      // Joined topics
      expect(vm.items[3] is ChannelListHeadingItem, true);
      expect(vm.items[4] is ChannelListChannelItem, true);
      expect(vm.items[5] is ChannelListChannelItem, true);
      expect(vm.items[6] is ChannelListChannelItem, true);
      expect(vm.items[7] is ChannelListChannelItem, true);
    });

    test("should show list of past events", () {
      final appState = AppState.init().rebuild((a) => a
        ..user = mockUser.toBuilder()
        ..selectedGroupId = "groupId"
        ..groups.replace({
          "groupId": mockGroup.rebuild((g) => g
            ..channels.replace({
              "channel1": mockChannel.rebuild((c) => c
                ..startDate = DateTime(2019, 1, 1)
                ..type = ChannelType.EVENT),
              "channel2": mockChannel.rebuild((c) => c
                ..type = ChannelType.TOPIC),
              "channel3": mockChannel.rebuild((c) => c
                ..type = ChannelType.TOPIC),
              "channel4": mockChannel.rebuild((c) => c
                ..type = ChannelType.TOPIC),
            }))
        }));
      final store = Store(null, initialState: appState);

      final vm = ChannelListViewModel.fromStore(store);

      expect(vm.items[0] is ChannelListHeadingItem, true);
      // Events
      expect(vm.items[1] is ChannelListActionItem, true);
      // "previous"
      expect(vm.items[2] is ChannelListHeadingItem, true);
      // Event in the past
      expect(vm.items[3] is ChannelListChannelItem, true);

      // Topics
      expect(vm.items[4] is ChannelListActionItem, true);
      // Joined topics
      expect(vm.items[5] is ChannelListHeadingItem, true);
      expect(vm.items[6] is ChannelListChannelItem, true);
      expect(vm.items[7] is ChannelListChannelItem, true);
      expect(vm.items[8] is ChannelListChannelItem, true);
    });
  });
}
