const functions = require('firebase-functions');
const { getNotificationBodyForNewChannel,
    getNotificationTitleForNewChannel,
    getNotificationTitleForNewEvent,
    getNotificationBodyForNewEvent } = require('./localize-util');
const { pushToUser } = require('./push-send');
const constants = require('./constants');
const { getUser } = require('./user-util');
const { updateCalendarUser } = require('./calendar-update');
const { db } = require('./admin');
const updateLatestActivityForChannel = require('./channel-updatedAt');
const { getChannel } = require('./channel-util');

async function postSystemMessage(context) {
    const channel = await getChannel(context.params.groupId, context.params.channelId);
    await updateLatestActivityForChannel(context.params.groupId, context.params.channelId, Date.now());

    return db.collection("/users/")
        .doc(context.params.userId)
        .get()
        .then(snapshot => {
            return db.collection(`/groups/${context.params.groupId}/channels/${context.params.channelId}/messages/`)
                .add({
                    body: channel.data().type == 'EVENT' ? `${snapshot.data().name} {JOINED_EVENT}` : `${snapshot.data().name} {JOINED_CHANNEL}`,
                    type: "SYSTEM",
                    timestamp: `${Date.now()}`,
                    author: { email: "system", name: "system" }
                });
        });
}

async function addUserToChannel(groupId, channelId, uid, isInvitation, tempMetadata) {
    return await db.collection(`/groups/${groupId}/channels/${channelId}/users/`)
        .doc(uid)
        .set({
            uid: uid,
            invitation: isInvitation,
            metadata: tempMetadata,
        });
}

async function pushToInvitedChannelUser(channelUserData, groupId, channelId) {
    // Send push notification to invited users:
    const groupName = channelUserData.metadata.group_name;
    const channelType = channelUserData.metadata.type;
    const channelName = channelUserData.metadata.channel_name;
    const channelVisibility = channelUserData.metadata.visibility;
    const authorName = channelUserData.metadata.inviting_user;

    const isEvent = channelType == constants.CHANNEL_EVENT_TYPE;
    const isvVisibilityOpen = channelVisibility == constants.CHANNEL_VISIBILITY_OPEN;

    const user = await getUser(channelUserData.uid);
    const userData = user.data();
    const userToken = userData.token;
    const userLocale = userData.locale;

    const title = isEvent ? getNotificationTitleForNewEvent(userLocale, isvVisibilityOpen, groupName, channelName) :
        getNotificationTitleForNewChannel(userLocale, isvVisibilityOpen, groupName, channelName);
    const message = isEvent ? getNotificationBodyForNewEvent(userLocale, isvVisibilityOpen, authorName, channelName) :
        getNotificationBodyForNewChannel(userLocale, isvVisibilityOpen, authorName, channelName);

    return await pushToUser(channelUserData.uid, userToken, title, message, "", groupId, channelId);
}

/**
 * This function is triggered when a new user joins a channel.
 *
 * @type {CloudFunction<DocumentSnapshot>}
 */

const newChannelUser = functions
    .region('europe-west1')
    .firestore
    .document('/groups/{groupId}/channels/{channelId}/users/{userId}')
    .onCreate(async (snap, context) => {
        const channelUserData = snap.data()

        // Post system message
        await postSystemMessage(context);

        // Update Calendar
        await updateCalendarUser(context.params.groupId, context.params.channelId, channelUserData.uid, false);

        //  Send push notification to invited users:
        if (channelUserData.invitation) { 
            await pushToInvitedChannelUser(channelUserData, context.params.groupId, context.params.channelId);
         }

        // Clean up user by removing metadata
        const FieldValue = require('firebase-admin').firestore.FieldValue;
        return await snap.ref.update({ metadata: FieldValue.delete() });
    });

module.exports = { newChannelUser, addUserToChannel };
