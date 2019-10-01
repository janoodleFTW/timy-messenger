const functions = require('firebase-functions');
const { deleteCalendarEntry } = require('./calendar-update');

const deleteChannel = functions
    .region('europe-west1')
    .firestore
    .document('/groups/{groupId}/channels/{channelId}')
    .onDelete(async (snap, context) => {
        return await deleteCalendarEntry(context.params.groupId, context.params.channelId);
    });

module.exports = deleteChannel;
