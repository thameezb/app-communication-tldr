const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const messaging = admin.messaging();

exports.notifyTopic = functions.https.onCall(async (data, _) => {
    try {
        const topicMessage = {
            notification: {
                title: data.messageTitle,
                body: data.messageBody
            }
        }

        await messaging.sendToTopic(data.messageTopic,topicMessage);

        return true;

    } catch (ex) {
        return ex;
    }
});