const { db, admin } = require('./admin');

const addCalendarEntry = async (groupId, channelId, channelName, groupName, eventDate, hasStartTime, timezoneSecondsOffset, users) => {
    const calendarEntry = {
        has_start_time: hasStartTime != null ? hasStartTime : false,
        timezone_seconds_offset: timezoneSecondsOffset != null ? timezoneSecondsOffset : 0,
        channel_id: channelId,
        group_id: groupId,
        channel_name: channelName,
        group_name: groupName,
        event_date: eventDate,
        users: users
    };

    return await db.collection("calendar")
        .doc(`${groupId}-${channelId}`)
        .set(calendarEntry);
}

const deleteCalendarEntry = async (groupId, channelId) => {
    const calendarEntryDoc = await db.collection("calendar")
        .doc(`${groupId}-${channelId}`)
        .get();

    if (calendarEntryDoc.exists) {
        return await calendarEntryDoc.ref.delete();
    }
}

const updateCalendarChannel = async (groupId, channelId, channelName, eventDate, hasStartTime, timezoneSecondsOffset) => {
    const calendarEntryDoc = await db.collection("calendar")
        .doc(`${groupId}-${channelId}`)
        .get()

    if (!calendarEntryDoc.exists) {
        return;
    }

    const calendarEntry = {
        has_start_time: hasStartTime != null ? hasStartTime : false,
        timezone_seconds_offset: timezoneSecondsOffset != null ? timezoneSecondsOffset : 0
    };

    if (channelName != null) calendarEntry.channel_name = channelName;
    if (eventDate != null) calendarEntry.event_date = eventDate;

    return await calendarEntryDoc.ref.update(calendarEntry);
}

const updateCalendarGroupName = async (groupId, groupName) => {
    const calendarGroup = await db.collection("calendar")
        .where("group_id", "==", groupId)
        .get()

    calendarGroup.docs.forEach(async (doc) => {
        await doc.ref.update({
            group_name: groupName
        });
    });
}

const updateCalendarUser = async (groupId, channelId, userId, didLeave) => {
    // Add calendar event
    const calendarDoc = await db.collection("calendar")
        .doc(`${groupId}-${channelId}`)
        .get()

    if (!calendarDoc.exists) {
        return;
    }

    if (didLeave) {
        return await calendarDoc.ref.update({
            users: admin.firestore.FieldValue.arrayRemove(userId)
        });
    } else {
        return await calendarDoc.ref.update({
            users: admin.firestore.FieldValue.arrayUnion(userId)
        });
    }
}

module.exports = { addCalendarEntry, updateCalendarChannel, updateCalendarGroupName, updateCalendarUser, deleteCalendarEntry };
