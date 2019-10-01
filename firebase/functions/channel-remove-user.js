const functions = require('firebase-functions');
const { updateCalendarUser } = require('./calendar-update');
const { getChannel } = require('./channel-util');
const updateLatestActivityForChannel = require('./channel-updatedAt');
const { db } = require('./admin');

/**
 * This function is triggered when a user leaves a channel.
 *
 * @type {CloudFunction<DocumentSnapshot>}
**/

const deleteChannelUser = functions
    .region('europe-west1')
    .firestore
    .document('/groups/{groupId}/channels/{channelId}/users/{userId}')
    .onDelete(async (snap, context) => {
        // Remove user from calendar entry
        await updateCalendarUser(context.params.groupId, context.params.channelId, context.params.userId, true);

        // System message
        const channel = await getChannel(context.params.groupId, context.params.channelId);
        
        if (channel.data() == null) {
            return;
        }

        await updateLatestActivityForChannel(context.params.groupId, context.params.channelId, Date.now());

        await db.collection("/users/")
            .doc(context.params.userId)
            .get()
            .then(snapshot => {
                return db.collection(`/groups/${context.params.groupId}/channels/${context.params.channelId}/messages/`)
                    .add({
                        body: channel.data().type == 'EVENT' ? `${snapshot.data().name} {LEFT_EVENT}` : `${snapshot.data().name} {LEFT_CHANNEL}`,
                        type: "SYSTEM",
                        timestamp: `${Date.now()}`,
                        author: { email: "system", name: "system" }
                    });
            });
    });

module.exports = deleteChannelUser;
