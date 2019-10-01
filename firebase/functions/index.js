const updatedMessages = require('./message-update');
const newMessages = require('./message-new');
const newChannel = require('./channel-new');
const editChannel = require('./channel-edit');
const rsvpUpdate = require('./rsvp-update');
const newUser = require('./user-new');
const { notifyAboutUpcomingEventsToday, 
  notifyAboutUpcomingEventsTomorrow } = require('./cron/event-notify-about-upcoming-event');
const newChannelUser = require('./channel-new-user');
const deleteChannelUser = require('./channel-remove-user');
const updatedGroup = require('./group-update');
const deleteChannel = require('./channel-remove');

exports.newUser = newUser;
exports.newChannelUser = newChannelUser;
exports.deleteChannelUser = deleteChannelUser;

exports.newChannel = newChannel;
exports.editChannel = editChannel;
exports.deleteChannel = deleteChannel;

exports.newMessages = newMessages;
exports.updatedMessages = updatedMessages;

exports.rsvpUpdate = rsvpUpdate;

exports.updatedGroup = updatedGroup;

/// Crons make us of the scheduling APIs in firebase. 
/// These APIs aren't available on the free Spark Plan. 
/// To deploy crons you'll need to enable the `Blaze Plan` first.
/* 
// Crons
exports.notifyAboutUpcomingEventsToday = notifyAboutUpcomingEventsToday;
exports.notifyAboutUpcomingEventsTomorrow = notifyAboutUpcomingEventsTomorrow;
*/
