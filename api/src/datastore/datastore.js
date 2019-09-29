const MongoClient = require('mongodb').MongoClient;
const config = require('config');

export default class Datastore {
    constructor() {}

    /*
    Initializes connection between client and MongoDB server.
    Initializes Datastore properties client, database
    */
    initialize() {
        return new Promise(async (resolve, reject) => {
            try {
                this.client = await MongoClient.connect(config.get('Database.url'), { useNewUrlParser: true, useUnifiedTopology: true });
                console.log("Successfully connected to MongoDB Server");
                
                this.database = await this.client.db(config.get('Database.dbName'));
                console.log("Successfully connected to MAPP Database");
    
                return resolve();
            }
            catch (error) {
                return reject(error);
            }
        });
    }

    /*
    Closes the connection with the MongoDB server
    */
    closeConnection() {
        return new Promise(async (resolve, reject) => {
            try {
                this.client.close();

                return resolve();
            }
            catch (error) {
                return reject(error);
            }
        });
    }

    /*
    Inserts a document to the specified collection

    @params: object document, tableName string
    @returns: inserted documentId
    */
    insert(document, tableName) {
        return new Promise(async (resolve, reject) => {
            try {
                const collection = await this.database.collection(tableName);

                let documentId = await collection.insertOne(document);

                return resolve(documentId);
            }
            catch (error) {
                return reject(error);
            }
        });
    }

    /*
    Finds documents based on the query from the specified collection

    @params: query object, tableName string
    @returns: results array
    */
    find(query, tableName) {
        return new Promise(async (resolve, reject) => {
            try {
                const collection = await this.database.collection(tableName);

                let cursor = await collection.find(query);
                let results = await cursor.toArray();

                return resolve(results);
            }
            catch (error) {
                return reject(error);
            }
        });
    }

    /*
    Updates document with new document object from the specified collection

    @params: documentId string, document object, tableName string
    */
    update(documentId, document, tableName) {
        return new Promise(async (resolve, reject) => {
            try {
                const collection = await this.database.collection(tableName);

                await collection.replaceOne({ _id: documentId }, document);

                return resolve();
            }
            catch (error) {
                return reject(error);
            }
        });
    }

    /*
    Removes specified document based on Id from the specified collection

    @params: documentId string, tableName string
    */
    remove(documentId, tableName) {
        return new Promise(async (resolve, reject) => {
            try {
                const collection = await this.database.collection(tableName);

                await collection.deleteOne({ _id: documentId });

                return resolve();
            }
            catch (error) {
                return reject(error);
            }
        });
    }
}
