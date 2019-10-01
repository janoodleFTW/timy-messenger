class FirestorePaths {
  static const PATH_GROUPS = "groups";
  static const PATH_CHANNELS = "channels";
  static const PATH_MESSAGES = "messages";
  static const PATH_USERS = "users";
  static const PATH_CALENDAR = "calendar";

  static String groupPath(String groupId) {
    return "$PATH_GROUPS/$groupId";
  }

  static String channelsPath(String groupId) {
    return "$PATH_GROUPS/$groupId/$PATH_CHANNELS";
  }

  static String channelPath(String groupId, String channelId) {
    return "$PATH_GROUPS/$groupId/$PATH_CHANNELS/$channelId";
  }

  static String channelUsersPath(String groupId, String channelId) {
    return "$PATH_GROUPS/$groupId/$PATH_CHANNELS/$channelId/$PATH_USERS";
  }

  static String messagesPath(String groupId, String channelId) {
    return "$PATH_GROUPS/$groupId/$PATH_CHANNELS/$channelId/$PATH_MESSAGES";
  }

  static String messagePath(
    String groupId,
    String channelId,
    String messageId,
  ) {
    return "$PATH_GROUPS/$groupId/$PATH_CHANNELS/$channelId/$PATH_MESSAGES/$messageId";
  }

  static String userPath(String userId) {
    return "$PATH_USERS/$userId";
  }
}
