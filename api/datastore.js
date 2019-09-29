const MongoClient = require('mongodb').MongoClient;
const config = require('config');

/*
Initializes the connection between the client and the database server

@returns: client object
*/
var initializeConnection = function() {
    return new Promise(async (resolve, reject) => {
        try {
            let client = await MongoClient.connect(config.get('Database.url'), { useNewUrlParser: true, useUnifiedTopology: true });
            console.log("Successfully connected to MongoDB Server");

            return resolve(client);
        }
        catch (error) {
            return reject(error);
        }
    });
};

/*
Gets the Database Object from the Server

@params: client object
@returns: clientDb object
*/
var getDatabase = function(client) {
    return new Promise(async (resolve, reject) => {
        try {
            let clientDb = await client.db(config.get('Database.dbName'));
            console.log("Successfully connected to MAPP Database");

            return resolve(clientDb);
        }
        catch (error) {
            return reject(error);
        }
    });
};

/*
Inserts a document to the specified collection

@params: object document, tableName string
@returns: inserted documentId
*/
exports.insert = function(document, tableName) {
    return new Promise(async (resolve, reject) => {
        try {
            const client = await initializeConnection();
            const database = await getDatabase(client);
            const collection = await database.collection(tableName);

            let documentId = await collection.insertOne(document);

            await client.close();

            return resolve(documentId);
        }
        catch (error) {
            return reject(error);
        }
    });
};

/*
Finds documents based on the query from the specified collection

@params: query object, tableName string
@returns: results array
*/
exports.find = function(query, tableName) {
    return new Promise(async (resolve, reject) => {
        try {
            const client = await initializeConnection();
            const database = await getDatabase(client);
            const collection = await database.collection(tableName);

            let cursor = await collection.find(query);
            let results = await cursor.toArray();

            await client.close();

            return resolve(results);
        }
        catch (error) {
            return reject(error);
        }
    });
};

/*
Updates document with new document object from the specified collection

@params: documentId string, document object, tableName string
*/
exports.update = function(documentId, document, tableName) {
    return new Promise(async (resolve, reject) => {
        try {
            const client = await initializeConnection();
            const database = await getDatabase(client);
            const collection = await database.collection(tableName);

            await collection.replaceOne({ _id: documentId }, document);

            await client.close();

            return resolve();
        }
        catch (error) {
            return reject(error);
        }
    });
};

/*
Removes specified document based on Id from the specified collection

@params: documentId string, tableName string
*/
exports.remove = function(documentId, tableName) {
    return new Promise(async (resolve, reject) => {
        try {
            const client = await initializeConnection();
            const database = await getDatabase(client);
            const collection = await database.collection(tableName);

            await collection.deleteOne({ _id: documentId });

            await client.close();

            return resolve();
        }
        catch (error) {
            return reject(error);
        }
    });
};
