const functions = require('firebase-functions');

const updateLatestActivityForChannel = require('./channel-updatedAt');
const userGroupUpdate = require('./user-groupUpdate');
const flagChannelUnread = require('./channel-flagChannelUnread');
const { usersInChannel, getUser } = require('./user-util');
const { sendNewMessagePush } = require('./push-send');

/**
 * This function is triggered when a new message document is created
 *
 * @type {CloudFunction<DocumentSnapshot>}
 */
const newMessages = functions
    .region('europe-west1')
    .firestore
    .document('/groups/{groupId}/channels/{channelId}/messages/{messageId}')
    .onCreate(async (snap, context) => {
        // Obtain the newly created message
        const message = snap.data();
        const path = snap.ref.path;
        const body = message.body;
        const authorId = message.author;
        const attachment = message.attachment;

        if (message.type != "USER") {
            console.log('System message. Ignoring');
            return;
        }

        console.log(`Received ${body} with attachment: ${attachment}`);

        // get the list of users that joined the channel
        const users = await usersInChannel(context.params.groupId, context.params.channelId);

        // get the message author, we need their name
        const author = await getUser(authorId) ;

        // for each user in the channel, get the id
        for (const userSnapshot of users.docs) {
            let uid = userSnapshot.data().uid;
            // Only send notification or flag channel as unread if user is not author
            if (authorId !== uid) {
                await userGroupUpdate(context.params.groupId, uid, context.params.channelId);
                await flagChannelUnread(context.params.groupId, context.params.channelId, uid);
                await sendNewMessagePush(uid, body, attachment, context, author.data());
            }
        }
        
        await updateLatestActivityForChannel(context.params.groupId, context.params.channelId, message.timestamp);
    });

module.exports = newMessages;
