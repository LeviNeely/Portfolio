//Take care of requirements
const axios = require('axios');
const admin = require('firebase-admin');
const inquirer = require('inquirer');

// Initialize Firebase Admin SDK
const serviceAccount = require('./currencyconversions-e8df9-firebase-adminsdk-9f9ip-8d1d976b70.json');
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

// Initialize Firestore
const db = admin.firestore();

//CurrencyConverter class
class CurrencyConverter {
    //The main functions
    async initialize() {
        try {
            //If it's been longer than a day
            if (!this.wasRecentlyUpdated()) {
                //Update the database with the most recent exchange rates
                this.updateDatabase();
            }
            //Fill the currencies with exchange rates
            this.currencies = await this.getCurrencies();
            //Prompt the user/print out the response
            this.startConversion();
        } catch (error) {
            console.error('Error initializing the converter:', error);
        }
    }

    // Fetch exchange rates from the API
    async fetchExchangeRates() {
        try {
            var rates = {}
            const response = await axios.get('https://api.exchangerate.host/latest?base=USD');
            for (let v in response.data.rates) {
                rates[v] = response.data.rates[v]
            }
            return rates;
        } catch (error) {
            console.error('Error fetching exchange rates:', error);
            return null;
        }
    }

    //Fill the currencies variable with data from the database
    async getCurrencies() {
        const databaseSnapshot = await db.collection('currencies').get();
        const currencies = {};
        databaseSnapshot.forEach(doc => {
            const data = doc.data();
            currencies[data.CurrencyCode] = data.ExchangeRate;
        });
        return currencies;
    }

    //Main loop: ask user for input, process input
    async startConversion() {
        var continueLoop = true;
        const questions = [
            {
                type: 'input',
                name: 'amount',
                message: 'Enter the amount in US dollars (enter 0 to quit):',
                validate: value => (!isNaN(parseFloat(value)) && (value >= 0)) || 'Please enter a valid number'
            },
            {
                type: 'input',
                name: 'currencyCode',
                message: 'Enter the desired currency code (if you entered 0, enter USD to quit):',
                validate: value => (value === 'USD' || (value in this.currencies)) || 'Invalid currency code'
            }
        ];

        //Await user input if continueLoop is true
        while (continueLoop) {
            //Ask the questions
            const answers = await inquirer.prompt(questions);

            //Get values from the answer from the user
            const amountUSD = parseFloat(answers.amount);
            const currencyCode = answers.currencyCode;

            // Check if the user entered 0 to exit the loop
            if (amountUSD === 0) {
                continueLoop = false;
                console.log('Goodbye');
            }
            //Otherwise, perform the request
            else {
                let convertedAmount;
                //If the user requests USD
                if (currencyCode === 'USD') {
                    //There's no need for conversion
                    convertedAmount = amountUSD.toFixed(2);
                } else {
                    const exchangeRate = this.currencies[currencyCode];
                    convertedAmount = (amountUSD * exchangeRate).toFixed(2);
                }
                console.log(`${amountUSD} USD is approximately ${convertedAmount} ${currencyCode}`);
            }
        }
    }

    //CRUD Methods
    //Create
    async createExchangeRate(currencyCode, exchangeRate) {
        try {
            //Create and set values for the new database entry
            const docRef = db.collection('currencies').doc(currencyCode);
            await docRef.set({
                CurrencyCode: currencyCode,
                ExchangeRate: exchangeRate
            });
            // console.log(`Exchange rate for ${currencyCode} added successfully.`);
        } catch (error) {
            console.error('Error adding exchange rate:', error);
        }
    }

    //Read/Retrieve
    async retrieveExchangeRate(currencyCode) {
        try {
            const docRef = db.collection('currencies').doc(currencyCode);
            const doc = await docRef.get();
            //Make sure the document exists inside the database
            if (doc.exists) {
                //Return the exchange rate
                return doc.data().ExchangeRate;
            } else {
                console.log('No such document!');
            }
        } catch (error) {
            console.error('Error getting exchange rate:', error);
        }
    }

    //Update
    async updateExchangeRate(currencyCode, newExchangeRate) {
        try {
            //If it's updating the lastTimeUpdated, then newExchangeRate will be a Date object
            if (typeof newExchangeRate == 'object') {
                const docRef = db.collection('currencies').doc(currencyCode);
                await docRef.update({Time: admin.firestore.FieldValue.serverTimestamp()});
            }
            //Otherwise, update the database with the new exchange rate
            else {
                const docRef = db.collection('currencies').doc(currencyCode);
                await docRef.update({ExchangeRate: newExchangeRate});
                // console.log(`Exchange rate for ${currencyCode} updated successfully.`);
            }
        } catch (error) {
            console.error('Error updating exchange rate:', error);
        }
    }

    //Delete
    async deleteExchangeRate(currencyCode) {
        try {
            const docRef = db.collection('currencies').doc(currencyCode);
            await docRef.delete();
            // console.log(`Exchange rate for ${currencyCode} deleted successfully.`);
        } catch (error) {
            console.error('Error deleting exchange rate:', error);
        }
    }

    //Updating the entire database if it has been more than a day
    async updateDatabase() {
        //Get the exchange rates from the api
        let results = await this.fetchExchangeRates();
        for (const currencyCode in results) {
            const documentSnapshot = await this.retrieveExchangeRate(currencyCode);
            //If the currencyCode is not in the database
            if (documentSnapshot.empty) {
                //Create a document in the database
                await this.createExchangeRate(currencyCode, results[currencyCode]);
            }
            //Otherwise, update the document
            else{
                await this.updateExchangeRate(currencyCode, results[currencyCode]);
            }
        }
        //Mark that the database has been updated
        const now = new Date();
        await this.updateExchangeRate('lastUpdateTime', now);
    }

    //Checking when last updated
    async wasRecentlyUpdated() {
        try {
            //Get the time of the last update from the database
            const docRef = db.collection('currencies').doc('lastUpdateTime');
            const doc = await docRef.get();
            if (doc.exists) {
                //Compare the current time with the time the database was last updated
                const now = new Date();
                const updateTime = doc.data().Time.toDate();
                const hoursSinceUpdate = (now - updateTime) / (1000 * 60 * 60);
                //If it's been longer than 24 hours since the last update
                if (hoursSinceUpdate > 24) {
                    //Return false
                    return false;
                }
                //Otherwise it has been recently updated, so return true
                else{
                    return true;
                }
            } else {
                console.log('Document not found.');
            }
        } catch (error) {
            console.error('Error getting document update time:', error);
        }
    }

}

// Create an instance of CurrencyConverter and start the conversion
const currencyConverter = new CurrencyConverter();
currencyConverter.initialize();
