'use strict';

const { db } = require('../admin');
const functions = require('firebase-functions');
const { getAllGroups } = require('../group-util');
const { pushToUser } = require('../push-send');
const { usersInChannel, getUser } = require('../user-util');
const { getNotificationTitleForUpcomingEvent,
  getNotificationBodyForUpcomingEvent } = require('../localize-util');

/**
 * Returning a time string in the format h:mm
 *
 * @param {Timestamp} eventTimestamp: In UTC
 * @param {Int} timezoneSecondsOffset: Event timezone offset
 */
const timeStringForDate = (eventTimestamp, timezoneSecondsOffset) => {
  const offset = timezoneSecondsOffset * 1000;
  var eventStartDate = eventTimestamp.toDate();
  eventStartDate.setTime(eventStartDate.getTime() + offset);

  const hours = eventStartDate.getHours();
  var minutes = eventStartDate.getMinutes();
  minutes = (minutes < 10) ? `0${minutes}` : minutes;
  return `${hours}:${minutes}`;
}

/**
 * Will send a localized notification to all members subscribed to a channel.
 * The action is reported by setting the `notified_members` flag of the event channel to true.
 * 
 * @param {DocumentSnapshot} channelDocument 
 * @param {string} groupId 
 * @param {string} groupName
 * @param {bool} isTomorrow: Indicates if event is starting tomorrow or today.
 */
const pushToChannelMembers = async (channelDocument, groupId, groupName, isTomorrow = false) => {
  const channelUsers = await usersInChannel(groupId, channelDocument.id);
  const channelData = channelDocument.data();

  channelDocument.ref.update({
    notified_members: true
  });

  for (const userSnapshot of channelUsers.docs) {
    const uid = userSnapshot.data().uid;
    const userDoc = await getUser(uid);
    const locale = userDoc.data().locale;

    const localizedTimeString = timeStringForDate(channelData.start_date, channelData.timezone_seconds_offset);
    const title = getNotificationTitleForUpcomingEvent(locale, groupName);
    const body = getNotificationBodyForUpcomingEvent(locale, channelData.name, isTomorrow ? null : localizedTimeString);

    await pushToUser(userDoc.id, userDoc.data().token, title, body, "", groupId, channelDocument.id);
  }
}

/**
 * Returing event channels with a start date between now and hoursInFuture.
 * 
 * @param {string} groupId 
 * @param {int} hoursInFuture: -1 if we're looking for events with unset start time.
 */

const getUpcomingEventChannels = async (groupId, hoursInFuture) => {
  var channelDocs;
  const channelDocsQuery = db
    .collection('groups')
    .doc(groupId)
    .collection('channels')
    .where("type", "==", "EVENT")

  // Configure query according to event type:
  // - Configure event without start time
  // - Configure event with star time

  if (hoursInFuture == -1) {
    const startOffset = 97200000 // 3600000 * 27;
    const endOffset = 198000000 // 3600000 * 28;
    var endFilter = new Date();
    endFilter.setTime(endFilter.getTime() + endOffset);
    var startFilter = new Date();
    startFilter.setTime(startFilter.getTime() + startOffset);

    channelDocs = await channelDocsQuery
      .where('has_start_time', '==', false)
      .where('start_date', '>=', startFilter)
      .where('start_date', '<=', endFilter)
      .get();

  } else {
    const endOffset = 3600000 * hoursInFuture // (60m * 60s * 1000ms) * hoursInFuture
    var endFilter = new Date();
    endFilter.setTime(endFilter.getTime() + endOffset);

    channelDocs = await channelDocsQuery
      .where('start_date', '>=', new Date())
      .where('start_date', '<=', endFilter)
      .get();
  }

  return channelDocs;
}

const pushToEventChannelMembers = async (eventChannelDocs, groupId, groupName, isTomorrow) => {
  for (const channelDocument of eventChannelDocs) {
    const channel = channelDocument.data();

    if (channel.notified_members !== true) {
      await pushToChannelMembers(channelDocument, groupId, groupName, isTomorrow);
    }
  }
}

/**
 * Sending notifications to users in groups
 * 
 * @param {QuerySnapshot} groupDocuments: All groups
 * @param {int} hoursInFuture: Used to determine the range between now and hoursInFuture
 */
const processEventsInGroupDocuments = async (groupDocuments, hoursInFuture) => {
  for (const groupDocument of groupDocuments) {
    const groupName = groupDocument.data().name;
    const groupId = groupDocument.id
    const eventChannels = await getUpcomingEventChannels(groupId, hoursInFuture);
  
    if (!eventChannels.empty) {
      await pushToEventChannelMembers(eventChannels.docs, groupId, groupName, hoursInFuture == -1);
    }
  }
}

// Cron jobs
const runtimeOpts = {
  timeoutSeconds: 540, // firebase max of 9 minutes
}

/**
 * Fired every hour.
 * Will send notificaitons to all users wo are members of event channels with a start_date
 * starting between now and now + 2 hours where notified_members for the channel is not set.
 */
const notifyAboutUpcomingEventsToday =
  functions.runWith(runtimeOpts)
    .region('europe-west1')
    .pubsub
    .schedule('every 60 minutes')
    .timeZone('UTC')
    .onRun(async (context) => {
      const groups = await getAllGroups();
      await processEventsInGroupDocuments(groups.docs, 2);
    });

/**
 * Fired at 20:00 Europe/Berlin time. 
 * Will send notifications to all users who are members of event channels with a start_date 
 * (starting the next day and having not start time set).
 * 
 * NOTE: This will only work as long as events without a set time have a time default of 23:59.
 */
const notifyAboutUpcomingEventsTomorrow = functions.runWith(runtimeOpts)
  .region('europe-west1')
  .pubsub
  .schedule('every day 20:00')
  .timeZone('Europe/Berlin')
  .onRun(async (context) => {
    const groups = await getAllGroups();
    await processEventsInGroupDocuments(groups.docs, -1);
  });

module.exports = {
  notifyAboutUpcomingEventsTomorrow,
  notifyAboutUpcomingEventsToday
}
