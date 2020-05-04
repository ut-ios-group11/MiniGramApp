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
        // Get The User
        const post_doc = db.collection('Posts').doc(context.params.postId)
        post_doc.get().then(post_snapshot => {
            const post = post_snapshot.data()
            const posterId = post.userId
            notificationFunctions.newComment(posterId, senderName) // Id of person who made the post, name of person who commented on the post
        }).catch( error => {
            console.log('Failed to retrieve match document: ',error)
        });
        return 0;
    });
