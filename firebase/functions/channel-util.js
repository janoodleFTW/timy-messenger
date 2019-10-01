const { db } = require('./admin');

const getChannel = async (groupId, channelId) => {
    return await db
        .collection(`/groups/${groupId}/channels/`)
        .doc(channelId)
        .get();
}

const getChannelName = async (groupId, channelId) => {
    let channelDoc = await getChannel(groupId, channelId);
    return channelDoc.data().name
};

const sendSystemMessage = async (groupId, channelId, body) => {
    await db.collection(`/groups/${groupId}/channels/${channelId}/messages/`).add({
        body: body,
        type: "SYSTEM",
        timestamp: `${Date.now()}`,
        author: { email: "system", name: "system" }
    });
};


module.exports = { getChannel, getChannelName, sendSystemMessage };
