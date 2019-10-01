const { db, admin } = require('./admin');
const { getUser } = require('./user-util');
const { getGroupName } = require('./group-util');
const { getChannelName } = require('./channel-util');
const getMessage = require('./message-get');
const { getNotificationTitleForMessage, getNotificationBodyForEmptyPhotoMessage } = require('./localize-util');
/**
 * Send push notification.
 * @param message is a JSON that follows this specs: https://firebase.google.com/docs/cloud-messaging/http-server-ref
 */
const sendPush = async (message) => {
    try {
        const response = await admin.messaging().send(message);
        console.log('Notification sent successfully:', response);
    } catch (error) {
        console.error('Notification sent failed:', error);
    }
}

async function countTotalUnread(userId) {
    let badgeCount = 0;

    try {
        let listGroups = await db
            .collection("/groups")
            .listDocuments();

        for (let ref of listGroups) {

            let listChannels = await ref
                .collection('channels')
                .listDocuments();

            for (let channel of listChannels) {

                let userInChannel = await channel
                    .collection('users')
                    .doc(userId)
                    .get();

                if (userInChannel.exists) {
                    if (userInChannel.data().hasUpdates) {
                        badgeCount++;
                    }
                }
            }
        }
    } catch (error) {
        console.error("Error calculating badges: ", error);
    }

    return badgeCount;
}

function getMessageData(groupId, channelId, username) {
    return {
        groupId: groupId,
        channelId: channelId,
        username: username,
        type: "message"
    };
}

/**
* iOS Reference: https://developer.apple.com/library/archive/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/PayloadKeyReference.html#//apple_ref/doc/uid/TP40008194-CH17-SW1
*/
function getApnsData(badge) {
    return {
        payload: {
            aps: {
                badge: badge
            }
        }
    }
}

/**
 * https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages#androidnotification
 */
function getAndroidData() {
    return {
        notification: {
            // required for onResume and onLaunch callbacks on notification tap
            click_action: "FLUTTER_NOTIFICATION_CLICK"
        }
    }
}

const sendNewMessagePush = async (uid, body, attachment = null, context, author) => {
    const groupName = await getGroupName(context.params.groupId);
    const channelName = await getChannelName(context.params.groupId, context.params.channelId);
    const title = getNotificationTitleForMessage(attachment != null, author.name, groupName, channelName);

    // get the user document from the /users collection
    const doc = await getUser(uid);
    const message = (attachment != null && body.length == 0) ? getNotificationBodyForEmptyPhotoMessage(doc.data().locale) : body;

    // If the user has a cloud messaging token registered
    let token = doc.data().token;

    await pushToUser(uid, token, title, message, author.name, context.params.groupId, context.params.channelId);
}

const pushToUser = async (uid, token, title, body, authorName, groupId, channelId) => {
    // compute the total number of unreads
    const badge = await countTotalUnread(uid);

    // If the user has a cloud messaging token registered
    if (token != null) {
        const push = getMessage(
            token,
            title,
            body,
            getMessageData(
                groupId,
                channelId,
                authorName,
                body
            ),
            getApnsData(badge),
            getAndroidData());
        await sendPush(push);
    }
}

module.exports = { sendPush, sendNewMessagePush, pushToUser };
