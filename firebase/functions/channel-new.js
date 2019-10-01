const functions = require('firebase-functions');
const { getUsersInGroup, getUser } = require('./user-util');
const { pushToUser } = require('./push-send');
const { getNotificationBodyForNewChannel,
    getNotificationTitleForNewChannel,
    getNotificationTitleForNewEvent,
    getNotificationBodyForNewEvent } = require('./localize-util');
const { getGroupName } = require('./group-util');
const constants = require('./constants');
const { db } = require('./admin');
const { addUserToChannel } = require('./channel-new-user');
const { addCalendarEntry } = require('./calendar-update');

async function setRsvpGoingForEventCreator(groupId, channelId, userId) {
    try {
        return await db
            .collection("/groups/")
            .doc(groupId)
            .collection("/channels/")
            .doc(channelId)
            .collection("/users/")
            .doc(userId).update({
                rsvp: "YES"
            });
    } catch (error) {
        console.error("Error setting rsvp 'YES' for channel creator: ", error);
    }
}

async function addInvitedUsersToChannel(snap, channel, groupId, channelId, authorId, groupName) {
    let author = await getUser(authorId);

    let tempMetadata = {
        inviting_user: author.data().name,
        group_name: groupName,
        channel_name: channel.name,
        visibility: channel.visibility,
        type: channel.type
    }

    for (const inviteId of channel.invited_members) {
        await addUserToChannel(groupId, channelId, inviteId, authorId != inviteId, tempMetadata);
    }

    // Clean up channel by removing invited_members array
    const FieldValue = require('firebase-admin').firestore.FieldValue;
    return snap.ref.update({ invited_members: FieldValue.delete() });
}

async function sendPushToGroupForOpenChannel(channelData, groupId, channelId, authorId, isEvent, groupName) {
    if (channelData.visibility != "OPEN") {
        return;
    }

    const users = await getUsersInGroup(groupId);
    const authorDoc = await getUser(authorId);
    const authorName = authorDoc.data().name
    const channelName = channelData.name;

    for (const userSnapshot of users.docs) {
        const userData = userSnapshot.data();
        const title = isEvent ? getNotificationTitleForNewEvent(userData.locale, true, groupName, channelName) :
            getNotificationTitleForNewChannel(userData.locale, true, groupName, channelName);
        const message = isEvent ? getNotificationBodyForNewEvent(userData.locale, true, authorName, channelName) :
            getNotificationBodyForNewChannel(userData.locale, true, authorName, channelName);

        await pushToUser(userData.uid, userData.token, title, message, "", groupId, channelId);
    }

    return;
}

const newChannel = functions
    .region('europe-west1')
    .firestore
    .document('/groups/{groupId}/channels/{channelId}')
    .onCreate(async (snap, context) => {
        const channel = snap.data();
        const isEvent = channel["type"] == constants.CHANNEL_EVENT_TYPE;
        const authorId = channel["authorId"];
        const groupName = await getGroupName(context.params.groupId);

        // Add author and invited users to channel
        await addInvitedUsersToChannel(snap, channel, context.params.groupId, context.params.channelId, authorId, groupName);

        if (isEvent) {
            await setRsvpGoingForEventCreator(context.params.groupId, context.params.channelId, authorId);

            // Create calendar entry
            await addCalendarEntry(
                context.params.groupId, 
                context.params.channelId, 
                channel.name, groupName, 
                channel.start_date, 
                channel.has_start_time, 
                channel.timezone_seconds_offset, 
                channel.invited_members,
            );
        }

        // Send push notification to group members for open channel.
        return await sendPushToGroupForOpenChannel(channel, context.params.groupId, context.params.channelId, authorId, isEvent, groupName);
    });

module.exports = newChannel;
