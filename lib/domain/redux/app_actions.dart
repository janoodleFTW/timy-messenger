import "package:circles_app/model/group.dart";
import "package:meta/meta.dart";

/// Actions are payloads of information that send data from your application to
/// your store. They are the only source of information for the store.
///
/// They are PODOs (Plain Old Dart Objects).
///
class ConnectToDataSource {
  @override
  String toString() {
    return "ConnectToDataSource{}";
  }
}

@immutable
class OnGroupsLoaded {
  final List<Group> groups;

  const OnGroupsLoaded(this.groups);

  @override
  String toString() {
    return "OnGroupsLoaded{groups: $groups}";
  }
}

@immutable
class SelectGroup {
  final String groupId;

  const SelectGroup(this.groupId);

  @override
  String toString() {
    return "SelectGroup{groupId: $groupId}";
  }
}
