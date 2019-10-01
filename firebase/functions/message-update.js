const functions = require('firebase-functions');
const sendPushForNewReaction = require('./reaction-push');

const updatedMessages = functions
    .region('europe-west1')
    .firestore
    .document('/groups/{groupId}/channels/{channelId}/messages/{messageId}')
    .onUpdate(async (change, context) => {
        const messageBefore = change.before.data();
        const messageAfter = change.after.data();
        const authorUid = messageAfter.author;

        await sendPushForNewReaction(messageBefore, messageAfter, authorUid, context);

    });

module.exports = updatedMessages;
