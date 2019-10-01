const { db } = require('./admin');

const getUsersInGroup = async (groupId) => {
    try {
        return await db.collection("users")
            .where("joinedGroups", "array-contains", groupId)
            .get()
    } catch (error) {
        console.log(`Error getting users for group: ${groupId}`);
    }
}

const getUser = (uid) => {
    try {
        return db
            .collection('users')
            .doc(uid)
            .get();
    } catch (error) {
        console.error("Error getting user: ", error);
    }
}

const usersInChannel = async (groupId, channelId) => {
    return await db
        .collection(`/groups/${groupId}/channels/${channelId}/users`)
        .get();
}

module.exports = { getUser, usersInChannel, getUsersInGroup };
