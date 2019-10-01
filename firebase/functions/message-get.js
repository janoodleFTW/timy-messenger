/**
 * Create the push notification payload JSON, include the user token
 *
 * API v1 reference: https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages
 *
 */
const getMessage = (token, title, body, data, apns, android) => {
    return {
        token: token,
        notification: {
            title: title,
            body: body
        },
        data: data,
        apns: apns,
        android: android
    };
}

module.exports = getMessage;
