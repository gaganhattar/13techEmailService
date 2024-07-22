// email limit handler

const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();
const tableName = process.env.TABLE_NAME;

exports.handler = async (event) => {
    const action = event.action;
    const email = event.email;

    if (action === 'add') {
        await addToBlacklist(email);
    } else if (action === 'remove') {
        await removeFromBlacklist(email);
    } else {
        return {
            statusCode: 400,
            body: JSON.stringify('Invalid action'),
        };
    }

    return {
        statusCode: 200,
        body: JSON.stringify(`${action}ed ${email}`),
    };
};

const addToBlacklist = async (email) => {
    const params = {
        TableName: tableName,
        Item: {
            email: email,
            date: new Date().toISOString().split('T')[0],
        },
    };
    await dynamodb.put(params).promise();
};

const removeFromBlacklist = async (email) => {
    const params = {
        TableName: tableName,
        Key: {
            email: email,
            date: new Date().toISOString().split('T')[0],
        },
    };
    await dynamodb.delete(params).promise();
};
