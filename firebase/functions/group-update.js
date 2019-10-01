const functions = require('firebase-functions');
const { updateCalendarGroupName } = require('./calendar-update');

const updatedGroup = functions
    .region('europe-west1')
    .firestore
    .document('/groups/{groupId}')
    .onUpdate(async (change, context) => {
        const groupAfter = change.after.data();

        // Update Calendar
        await updateCalendarGroupName(context.params.groupId, groupAfter.name);
    });

module.exports = updatedGroup;