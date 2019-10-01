const constants = require('./constants');

// RSVP ////
/**
 * Building notification title for RSVP update for event author.
 */
const getTitleForRSVPUpdate = (locale, rsvpType, groupName, channelName) => {
    if (locale == constants.PUSH_LOCALE_DE) {
        return `${getTitleIconForRSVPUpdate(rsvpType)} Neue Antwort (${groupName} - ${channelName})`;
    } else {
        return `${getTitleIconForRSVPUpdate(rsvpType)} New RSVP (${groupName} - ${channelName})`;
    }
}

function getTitleIconForRSVPUpdate(rsvpType) {
    if (rsvpType == constants.RSVP_YES) {
        return "✅";
    } else if (rsvpType == constants.RSVP_MAYBE) {
        return "❓";
    } else {
        return "❌";
    }
}

/**
 * Building notification message body for RSVP update for event author.
 */
const getBodyForRSVPUpdate = (locale, rsvpType, userName, channelName) => {
    if (locale == constants.PUSH_LOCALE_DE) {
        return `${userName} ${getMessageForRSVP(locale, rsvpType)} ${channelName} teil`;
    } else {
        return `${userName} ${getMessageForRSVP(locale, rsvpType)} ${channelName}`;
    }
}

function getMessageForRSVP(locale, rsvpType) {
    if (locale == constants.PUSH_LOCALE_DE) {
        if (rsvpType == constants.RSVP_YES) {
            return "nimmt an";
        } else if (rsvpType == constants.RSVP_MAYBE) {
            return "nimmt vielleicht an";
        } else {
            return "nimmt nicht an";
        }
    } else {
        if (rsvpType == constants.RSVP_YES) {
            return "is going to";
        } else if (rsvpType == constants.RSVP_MAYBE) {
            return "is maybe going to";
        } else {
            return "is not going to";
        }
    }
}

// REACTION ////

/**
 * Building emoji reaction notification body for message.
 * Defaults to "EN" when no locale is set.
 */
const getNotificationBodyForReaction = (locale, emoji) => {
    if (locale == constants.PUSH_LOCALE_DE) {
        return `Hat mit ${emoji} auf deine Nachricht reagiert`;
    } else {
        return `Reacted with ${emoji} to your message`;
    }
}

/**
 * Building emoji reaction notification title for message.
 * Defaults to "EN" when no locale is set.
 */
const getNotificationTitleForReaction = (authorName, groupName, channelName) => {
    return `${authorName} (${groupName} - ${channelName})`;
}

// MESSAGE ////

/**
 * Building regular notification title for message.
 * Defaults to "EN" when no locale is set.
 */
const getNotificationTitleForMessage = (hasAttachment, authorName, groupName, channelName) => {
    if (hasAttachment) {
        return `📸 ${authorName} (${groupName} - ${channelName})`;
    } else {
        return `💬 ${authorName} (${groupName} - ${channelName})`;
    }
}

/**
 * Building notification body for photo-message without text.
 * Defaults to "EN" when no locale is set.
 */
const getNotificationBodyForEmptyPhotoMessage = (locale) => {
    if (locale == constants.PUSH_LOCALE_DE) {
        return `Neues Foto`;
    } else {
        return `New photo`;
    }
}

/**
 * Building notification body for event.
 * Defaults to "EN" when no locale is set.
 */
const getNotificationBodyForNewEvent = (locale, openEvent, authorName, channelName) => {
    if (openEvent) {
        if (locale == constants.PUSH_LOCALE_DE) {
            return `${authorName} hat ein neues Event ${channelName} erstellt`;
        }
        return `${authorName} created a new event ${channelName}`;
    } else {
        if (locale == constants.PUSH_LOCALE_DE) {
            return `${authorName} hat dich zum Event ${channelName} eingeladen`;
        }
        return `${authorName} invited you to the event ${channelName}`;
    }
}

// CHANNEL / EVENT ////

/**
 * Event edit notificatin : Title
 */
const getNotificationTitleForEventEdit = (groupName, eventName) => {
    return `⚠️ Event ${eventName} in ${groupName}`;
}

/**
 * Event edit notification : Body
 */
const getNotificationBodyForEventEdit = (locale, authorName, date, location, eventEdits) => {
    if (eventEdits.includes(constants.EVENT_EDIT_TIME)) {
        if (locale == constants.PUSH_LOCALE_DE) {
            return `${authorName} hat das Datum auf ${date} geändert`;
        }
        return `${authorName} changed the date to ${date}`;

    } else if (eventEdits.includes(constants.EVENT_EDIT_DESCRIPTION)) {
        if (locale == constants.PUSH_LOCALE_DE) {
            return `${authorName} hat die Beschreibung geändert`;
        }
        return `${authorName} changed the description`;

    } else if (eventEdits.includes(constants.EVENT_EDIT_VENUE)) {

        if (locale == constants.PUSH_LOCALE_DE) {
            return location.length == 0 ? `${authorName} hat den Ort entfernt` : `${authorName} hat den Ort auf ${location} geändert`;
        }
        return location.length == 0 ? `${authorName} removed the location` : `${authorName} changed the location to ${location}`;
    }
}

/**
 * Building notification title for event.
 * Defaults to "EN" when no locale is set.
 */
const getNotificationTitleForNewEvent = (locale, openEvent, groupName, channelName) => {
    const prefix = openEvent ? "🗓️" : "🗓️🔒";

    if (openEvent) {
        return `${prefix} Event ${channelName} in ${groupName}`;
    } else {
        if (locale == constants.PUSH_LOCALE_DE) {
            return `${prefix} Event Einladung ${channelName} in ${groupName}`;
        } else {
            return `${prefix} Event invitation ${channelName} in ${groupName}`;
        }
    }
}

/**
 * Building notification title for channel.
 * Defaults to "EN" when no locale is set.
 */
const getNotificationTitleForNewChannel = (locale, openTopic, groupName, channelName) => {
    const prefix = openTopic ? "🆕" : "🆕🔒";

    if (locale == constants.PUSH_LOCALE_DE) {
        return `${prefix} Thema ${channelName} in ${groupName}`;
    } else {
        return `${prefix} Topic ${channelName} in ${groupName}`;
    }
}

/**
 * Building notification message.
 * Defaults to "EN" when no locale is set.
 */
const getNotificationBodyForNewChannel = (locale, openTopic, authorName, channelName) => {
    if (locale == constants.PUSH_LOCALE_DE) {
        if (openTopic) {
            return `${authorName} hat das Thema ${channelName} erstellt`;
        } else {
            return `${authorName} hat dich zum Thema ${channelName} hinzugefügt`;
        }

    } else {
        if (openTopic) {
            return `${authorName} created the topic ${channelName}`;
        } else {
            return `${authorName} added you to the topic ${channelName}`;
        }
    }
}

/**
 * Title for upcoming event notifications
 */
const getNotificationTitleForUpcomingEvent = (locale, groupName) => {
    if (locale == constants.PUSH_LOCALE_DE) {
        return `🗓 Event Erinnerung (${groupName})`;
    }

    return `🗓 Event Reminder (${groupName})`;
}

const getNotificationBodyForUpcomingEvent = (locale, eventChannelName, startTime) => {
    // When no start time is set, the event is happening the day after
    if (startTime == null) {
        return (locale == constants.PUSH_LOCALE_DE) ? `${eventChannelName} findet morgen statt` : `${eventChannelName} happens tomorrow`;
    }

    // When a startTime is present
    if (locale == constants.PUSH_LOCALE_DE) {
        return `${eventChannelName} beginnt heute um ${startTime}`;
    }

    return `${eventChannelName} starts today at ${startTime}`;
}

const getSystemMessageEventEditDate = (locale, authorName) => {
    if (locale == constants.PUSH_LOCALE_DE) {
        return `${authorName} hat das Datum des Events geändert`;
    } else {
        return `${authorName} changed the event date`;
    }
};

const getSystemMessageEventEditVenue = (locale, authorName) => {
    if (locale == constants.PUSH_LOCALE_DE) {
        return `${authorName} hat den Ort des Events geändert`;
    } else {
        return `${authorName} changed the event location`;
    }
};

const getSystemMessageEventEditDescription = (locale, authorName) => {
    if (locale == constants.PUSH_LOCALE_DE) {
        return `${authorName} hat die Beschreibung des Events geändert`;
    } else {
        return `${authorName} changed the event description`;
    }
};

const localizeDate = (locale, date) => {
    const options = { year: "numeric", month: '2-digit', day: 'numeric', hour12: false, hour: 'numeric', minute: 'numeric' };
    const localizedENDate = date.toLocaleDateString("en-US", options);

    if (locale == constants.PUSH_LOCALE_DE) {
        const dateSegments = localizedENDate.split('/');
        return `${dateSegments[1]}.${dateSegments[0]}.${dateSegments[2]}`; // DD.MM.YYYY, HH:MM
    }

    return localizedENDate // MM/DD/YYYY, HH:MM
}

module.exports = {
    getNotificationTitleForUpcomingEvent,
    getNotificationBodyForUpcomingEvent,
    getNotificationTitleForNewChannel,
    getNotificationBodyForNewChannel,
    getNotificationTitleForNewEvent,
    getNotificationBodyForNewEvent,
    getNotificationTitleForMessage,
    getNotificationTitleForReaction,
    getNotificationBodyForReaction,
    getNotificationBodyForEmptyPhotoMessage,
    getNotificationTitleForEventEdit,
    getNotificationBodyForEventEdit,
    getTitleForRSVPUpdate,
    getBodyForRSVPUpdate,
    getSystemMessageEventEditDate,
    getSystemMessageEventEditVenue,
    getSystemMessageEventEditDescription,
    localizeDate
};