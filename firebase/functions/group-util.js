const { db } = require('./admin');

const getAllGroups = async () => {
    let groupDocs = await db
        .collection('groups')
        .get();

    if (groupDocs.empty) {
        console.log('Could not find any groups');
        return null;
    }

    return groupDocs;
}

const getGroupName = async (groupId) => {
    let groupDoc = await db
        .collection('groups')
        .doc(groupId)
        .get();

    return groupDoc.data().name;
}

module.exports = { getGroupName, getAllGroups };
