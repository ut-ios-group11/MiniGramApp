import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';


import * as notificationFunctions from './notifications/index'

admin.initializeApp(functions.config().firebase);

/*
    MARK:: New Comment
*/
export const commentCreated = functions.firestore
    .document('Posts/{postId}/Comments/{commentId}')
    .onCreate((comment_snapshot, context) => {
        const comment_data = comment_snapshot.data()
        
        const db = admin.firestore();
        console.log('New Comment')

        const senderName = comment_data.userName
        const messageText = comment_data.message
        // Get The User
        const post_doc = db.collection('Posts').doc(context.params.postId)
        post_doc.get().then(post_snapshot => {
            const post = post_snapshot.data()
            const posterId = post.userId
            notificationFunctions.newComment(posterId, senderName, messageText)
        }).catch( error => {
            console.log('Failed to retrieve match document: ',error)
        });
        return 0;
    });

export const modifiedPost = functions.firestore
    .document('Posts/{postId}')
    .onUpdate((change, context) => {

        const db = admin.firestore();
        console.log('Post Change Occurred');

        // Get an object representing current doc
        const currentPost = change.after.data()
        const previousPost = change.before.data()

        let newLikes = currentPost.likes.filter(item => previousPost.likes.indexOf(item) < 0);
        const posterId = currentPost.userId

        for (var senderId of newLikes) {
            const senderDoc = db.collection('Users').doc(senderId)
            senderDoc.get().then(senderSnapshot => {
                const senderName = senderSnapshot.data().userName
                notificationFunctions.newLike(posterId, senderName)
            }).catch( error => {
                console.log('Failed to retrieve snder document: ', error)
            });
        }
        return 0;
    });