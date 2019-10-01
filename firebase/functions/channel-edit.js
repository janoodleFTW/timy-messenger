const functions = require('firebase-functions');
const { sendSystemMessage } = require('./channel-util');
const { pushToUser } = require('./push-send');
const constants = require('./constants');
const { usersInChannel, getUser } = require('./user-util');
const { getGroupName } = require('./group-util');
const { updateCalendarChannel } = require('./calendar-update');
const {
    localizeDate,
    getNotificationTitleForEventEdit,
    getNotificationBodyForEventEdit,
    getSystemMessageEventEditDate,
    getSystemMessageEventEditVenue,
    getSystemMessageEventEditDescription
} = require('./localize-util');

async function sendPushToChannelUsers(author, groupId, channelId, channelName, channelVenue, eventDate, eventEdits) {
    const groupName = await getGroupName(groupId);
    const channelUsers = await usersInChannel(groupId, channelId);
    const title = getNotificationTitleForEventEdit(groupName, channelName);

    for (const channelUser of channelUsers.docs) {
        const rsvpStatus = channelUser.data().rsvp;
        if (rsvpStatus == constants.RSVP_MAYBE || rsvpStatus == constants.RSVP_YES) {
            const user = await getUser(channelUser.data().uid);
            const token = user.data().token;
            const locale = user.data().locale;
            const body = getNotificationBodyForEventEdit(locale, author, localizeDate(locale, eventDate), channelVenue, eventEdits);
            if (body != null) {
                await pushToUser(channelUser.data().uid, token, title, body, "", groupId, channelId);
            }
        }
    }
}

/**
 * On channel edits (event channels)
 * - Post separate message to channel if [start_date | venue | description] have been edited
 * - Send push notification to channel users except author notifying about changes
 */
const editChannel = functions
    .region('europe-west1')
    .firestore
    .document('/groups/{groupId}/channels/{channelId}')
    .onUpdate(async (change, context) => {
        const channelAfter = change.after.data();
        const channelBefore = change.before.data();

        const user = await getUser(channelAfter['authorId']);
        const locale = user.data().locale;
        const name = user.data().name;
        var editChanges = [];

        if (channelAfter.start_date != null &&
            (channelAfter.start_date.toDate().getTime() !== channelBefore.start_date.toDate().getTime()
                || channelAfter['has_start_time'] !== channelBefore['has_start_time'])) {
            const body = getSystemMessageEventEditDate(locale, name);
            await sendSystemMessage(context.params.groupId, context.params.channelId, body);
            editChanges.push(constants.EVENT_EDIT_TIME);
        }

        if (channelAfter['venue'] !== channelBefore['venue']) {
            const body = getSystemMessageEventEditVenue(locale, name);
            await sendSystemMessage(context.params.groupId, context.params.channelId, body);
            editChanges.push(constants.EVENT_EDIT_VENUE);
        }

        if (channelAfter['description'] !== channelBefore['description']) {
            const body = getSystemMessageEventEditDescription(locale, name);
            await sendSystemMessage(context.params.groupId, context.params.channelId, body);
            editChanges.push(constants.EVENT_EDIT_DESCRIPTION);
        }

        // Notify channel members about changes via notifications
        if (editChanges.length > 0) {
            const venue = channelAfter.venue;
            const timezoneOffset = channelAfter.timezone_seconds_offset * 1000;
            const startDate = channelAfter.start_date.toDate();
            startDate.setTime(startDate.getTime() + timezoneOffset);
            await sendPushToChannelUsers(user.data().name, context.params.groupId, context.params.channelId, channelAfter.name, venue, startDate, editChanges);
        }

        // Update calendar event
        await updateCalendarChannel(
            context.params.groupId,
            context.params.channelId, 
            channelAfter.name, 
            channelAfter.start_date, 
            channelAfter.has_start_time, 
            channelAfter.timezone_seconds_offset
        );
    });

module.exports = editChannel;
