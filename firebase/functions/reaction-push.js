const { getUser, usersInChannel } = require('./user-util');
const flagChannelUnread = require('./channel-flagChannelUnread');
const getMessage = require('./message-get');
const { sendPush } = require('./push-send');
const { getNotificationTitleForReaction, getNotificationBodyForReaction } = require('./localize-util');
const { getGroupName } = require('./group-util');
const { getChannelName } = require('./channel-util');

const sendPushForNewReaction = async (messageBefore, messageAfter, authorUid, context) => {
    const reactionBefore = messageBefore.reaction;
    const reactionAfter = messageAfter.reaction;
    const author = await getUser(authorUid);
    const groupName = await getGroupName(context.params.groupId);
    const channelName = await getChannelName(context.params.groupId, context.params.channelId);

    for (const key in reactionAfter) {
        // A new reaction was added
        if (!Object.keys(reactionBefore).includes(key)) {
            console.log('New Emoji reaction added to message');

            // get the list of users that joined the channel
            const users = await usersInChannel(context.params.groupId, context.params.channelId);
            // Check if the author is still part of the channel
            if (!users.docs.some((user) => {
                return authorUid === user.id;
            })) {
                console.log('Author left the channel');
                return;
            }

            // Update read flag for author.
            await flagChannelUnread(context.params.groupId, context.params.channelId, author.data().uid);

            const val = reactionAfter[key];
            const emoji = val.emoji;
            const username = val.user_name;
            const token = author.data().token;

            // If the user has a cloud messaging token registered
            if (token != null) {
                const title = getNotificationTitleForReaction(username, groupName, channelName);
                const body = getNotificationBodyForReaction(author.data().locale, emoji);
                console.log('Sending notification to user ' + author.data().name + ' with text: ' + body);
                const message = getMessage(
                    token,
                    title,
                    body,
                    { type: "reaction" });
                await sendPush(message);
            }
        }
    }
}

module.exports = sendPushForNewReaction;
