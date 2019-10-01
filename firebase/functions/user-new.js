const functions = require('firebase-functions');
const { db } = require('./admin');

const newUser = functions
    .region('europe-west1')
    .firestore
    .document('/users/{userId}')
    .onCreate(async (snapshot, context) => {
        const allGroups = await db.collection("/groups/")
            .where("members", "array-contains", context.params.userId)
            .get();
                
        var groupIds = [];
        for(const groupSnapshot of allGroups.docs) {
            groupIds.push(groupSnapshot.id);
        } 

        // Set all "joinedGroups" according to "members" in each group
        snapshot.ref.update({
            joinedGroups : groupIds
        });
});

module.exports  = newUser;