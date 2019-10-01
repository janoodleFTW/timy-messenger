const { db, admin } = require('./admin');

/**
 * Performs two updates:
 * 1. Updates / Sets `updatedGroups`  user `userId`  with `groupId`. This is used to build a map of unread channels for a group on the client.
 * 2. Adds key `groupId` with value `channelId` of all channels containing updates.
 * This is used to highlight that there are yet unread updates.
 */
const userGroupUpdate = async (groupId, userId, channelId) => {
    try {
        const userDocRef = db.collection("/users/").doc(userId);
        await userDocRef.update({
            updatedGroups: admin.firestore.FieldValue.arrayUnion(groupId),
            [groupId]: admin.firestore.FieldValue.arrayUnion(channelId)
        })
    } catch (error) {
        console.error("Error updating user for group update: ", error);
    }
}

module.exports = userGroupUpdate;