const { db } = require('./admin');

/**
 * Sets `hasUpdates` flag for user in channel to false.
 * This is used to allow the channels listener on client-side 
 * to update its list accordingly.
 */
const flagChannelUnread = async (groupdId, channelId, userId) => {
    try {
        await db
            .collection("/groups/")
            .doc(groupdId)
            .collection("/channels/")
            .doc(channelId)
            .collection("/users/").doc(userId).update({
                hasUpdates: true
            });
        console.log("Updated has updates for user: " + userId);
    } catch (error) {
        console.error("Error writing document: ", error);
    }
}

module.exports = flagChannelUnread;
