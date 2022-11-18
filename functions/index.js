const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const messaging = admin.messaging();

exports.notifyTopic = functions.https.onCall(async (data, _) => {

    const topicMessage = {
        notification: {
            title: data.messageTitle,
            body: data.messageBody
        },
        topic: data.messageTopic
    };

    // Send a message to devices subscribed to the provided topic.
    messaging.send(topicMessage)
    .then((response) => {
        // Response is a message ID string.
        functions.logger.log('Successfully sent message:', response);
        return {success: true};
    })
    .catch((error) => {
        functions.logger.log('Error sending message:', error);
        return {error: error.code};
    });

});