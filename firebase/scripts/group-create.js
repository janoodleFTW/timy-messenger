const admin = require('firebase-admin');

var serviceAccount = require("../your-firebase-sdk-config-file.json");

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: "https://your-firebase-project.firebaseio.com"
});

const db = admin.firestore();

(async () => {
    try {

        // Get all users of the database
        const users = await db.collection('/users').listDocuments();
        const members = [];
        for (let i = 0; i < users.length; i++) {
            members[i] = (await users[i].get()).data().uid;
        }

        // create a new 'dev' group
        const group = await db.collection('/groups').add({
            'abbreviation': 'DV',
            'color': 'fcba03',
            'name': 'dev',
            'members': members
        });

        // add all users to the 'dev' group
        for (let i = 0; i < users.length; i++) {
            const joinedGroups = (await users[i].get()).data().joinedGroups;
            joinedGroups.push(group.id);
            users[i].update({
                'joinedGroups' : joinedGroups
            });
        }

        // create a general channel
        db.collection('/groups')
            .doc(group.id)
            .collection('/channels')
            .add({
                'name': "general",
                'type': "TOPIC",
                'visibility': "OPEN"
            })

        console.log(`Group with id ${group.id} created`);

    } catch (e) {
        console.log(e);
    }
})();
