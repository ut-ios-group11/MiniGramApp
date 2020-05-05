import * as admin from 'firebase-admin';

export function sendNotification(message, collection, uid) {
    console.log('Attempting to send notifcation to ', collection, ' : ', uid)

    const db = admin.firestore()
    const doc = db.collection(collection).doc(uid)
    doc.get().then(snapshot => {
        const fcmTokens = snapshot.data().fcmTokens
        console.log('FCM Tokens: ', fcmTokens)
        if (fcmTokens) {
            for (const fcmToken of fcmTokens) {
                //Set up apn headers
                console.log('Sending Message To: ', fcmToken)
                message.token = fcmToken
                // Send message to tokens
                admin.messaging().send(message)
                .then(response => {
                        console.log('Successfully sent message:', response)
                    })
                    .catch(error => {
                        console.log('Error sending message: ', error)
                        if (error.code === 'messaging/invalid-registration-token' ||
                            error.code === 'messaging/registration-token-not-registered') {
                            console.log('Removing Token ', message.token)
                            doc.update({
                                    "fcmTokens": admin.firestore.FieldValue.arrayRemove(fcmToken)
                              }).then(() => {
                                // Document updated successfully.
                                console.log('Token Removed Succesfully')
                              })
                              .catch(tokenError => {
                                  console.log('error deleting token... ',tokenError)
                              })
                        }
                    })
            }
        } else {
            console.log("No FCM Tokens Found")
        }
    }).catch(error => {
        console.log("Error getting Notification User Doc at: ",collection,' : ',uid, ' with error: ', error)
    })
    return 0;
}

//Comment
export function newComment(posterId, senderName) {
    console.log(senderName, ' created a new comment for a post by', posterId)

    const message = {
        "apns": {
            "headers": {
                'apns-priority': '10'
            },
            "payload": {
                "aps": {
                    "alert": {
                        "title": '',
                        "body": `${ senderName } commented on your post`,
                    },
                    "badge": 1,
                    "sound": 'default'
                },
            }
        },
        "token": ''
    }
    sendNotification(message,"Users",posterId)
    return 0;
}