const MongoClient = require('mongodb').MongoClient;

class Datastore {
    constructor() {}

    /**
     * Initializes connection between client and MongoDB server. 
     * Initializes Datastore properties client, database
     * 
     * @param {string} url - URL of MongoDB server
     * @param {string} dbName - Name of specific database in MongoDB server
     */
    initialize(url, dbName) {
        return new Promise(async (resolve, reject) => {
            try {
                this.client = await MongoClient.connect(url, { useNewUrlParser: true, useUnifiedTopology: true });
                this.database = await this.client.db(dbName);
                console.log('[info] successfully connected to ' + dbName + ' at ' + url);
                
                return resolve();
            }
            catch (error) {
                return reject(error);
            }
        });
    }

    /**
     * Closes the connection with the MongoDB server
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

    /**
     * Inserts a document to the specified collection 
     * 
     * @param {object} document - Document object to insert
     * @param {string} tableName - Name of collection 
     * 
     * @returns {string} - Inserted documentId
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

    /**
     * Finds documents based on the query from the specified collection
     * 
     * @param {object} query 
     * @param {string} tableName - Name of collection
     * 
     * @returns {object[]} - Array of documents objects that match query
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

    /**
     * Updates document with new document object from the specified collection
     * 
     * @param {string} documentId 
     * @param {object} document
     * @param {string} tableName - Name of collection
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

    /**
     * Removes specified document based on Id from the specified collection
     * 
     * @param {string} documentId
     * @param {string} tableName - Name of collection
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

// We export a single instance of a datastore.
// it should be initialized in index.js; then
// successive imports will import initialized db.
let datastore = new Datastore();
module.exports = datastore;
