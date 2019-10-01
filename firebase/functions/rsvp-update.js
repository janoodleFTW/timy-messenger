const { getUser } = require('./user-util');
const functions = require('firebase-functions');
const { db } = require('./admin');
const { getGroupName } = require('./group-util');
const updateLatestActivityForChannel = require('./channel-updatedAt');
const { getTitleForRSVPUpdate,
    getBodyForRSVPUpdate } = require('./localize-util');
const { pushToUser } = require('./push-send');
const { getChannel } = require('./channel-util');

async function sendUpdateToRSVPAuthor(authorId, updatingMemberName, rsvpType, groupId, channel) {
    const groupName = await getGroupName(groupId);
    const channelName = channel.data().name;
    const authorDoc = await getUser(authorId);
    const locale = authorDoc.data().locale;
    const authorToken = authorDoc.data().token;
    const title = getTitleForRSVPUpdate(locale, rsvpType, groupName, channelName);
    const message = getBodyForRSVPUpdate(locale, rsvpType, updatingMemberName, channelName);

    await pushToUser(authorId, authorToken, title, message, "", groupId, channel.id);
}

const rsvpUpdate = functions
    .region('europe-west1')
    .firestore.document('/groups/{groupId}/channels/{channelId}/users/{userId}')
    .onUpdate(async (change, context) => {
        const userBefore = change.before.data();
        const userAfter = change.after.data();
        const rsvpBefore = userBefore.rsvp;
        const rsvpAfter = userAfter.rsvp;
        const validRSVP = rsvpBefore !== rsvpAfter;

        const channel = await getChannel(context.params.groupId, context.params.channelId);
        const isAuthor = channel.data().authorId === context.params.userId;

        if (validRSVP) {
            if (isAuthor) {
                return;
            }

            const doc = await getUser(userBefore.uid);
            await sendUpdateToRSVPAuthor(channel.data().authorId, doc.data().name, rsvpAfter, context.params.groupId, channel);

            let message;
            switch (rsvpAfter) {
                case "YES":
                    message = "{RSVP_YES}";
                    break;
                case "MAYBE":
                    message = "{RSVP_MAYBE}";
                    break;
                case "NO":
                    message = "{RSVP_NO}";
                    break;
            }

            await db.collection(`/groups/${context.params.groupId}/channels/${context.params.channelId}/messages/`)
            .add({
                body: `${doc.data().name} ${message}`,
                type: "RSVP",
                timestamp: `${Date.now()}`
            });

            await updateLatestActivityForChannel(context.params.groupId, context.params.channelId, Date.now());
        }
    });

module.exports = rsvpUpdate;
