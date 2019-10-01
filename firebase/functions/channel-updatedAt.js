const { db } = require('./admin');

/**
 * Sets `updatedAt` for channel to last activity's timestamp.
 */
const updateLatestActivityForChannel = async (groupId, channelId, activityDate) => {
    try {
        await db
            .collection("/groups/")
            .doc(groupId)
            .collection("/channels/")
            .doc(channelId).update({
                updatedAt: activityDate
            })

    } catch (error) {
        console.error("Error updating channel timestamp: ", error);
    }
}

module.exports = updateLatestActivityForChannel;