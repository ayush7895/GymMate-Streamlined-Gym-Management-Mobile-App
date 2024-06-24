const functions = require('firebase-functions');
const admin = require('firebase-admin');
const moment = require('moment-timezone');
const axios = require('axios');
admin.initializeApp();
const db = admin.firestore();

exports.scheduledCheck = functions.pubsub.schedule('00 12 * * *')
  .timeZone('Asia/Kolkata')
  .onRun(async (context) => {
    const usersRef = db.collection('MYusers');
    const today = moment().tz('Asia/Kolkata').startOf('day');

    try {
      const userDocRefs = await usersRef.listDocuments();
      for (const userDocRef of userDocRefs) {
        console.log(`Checking user: ${userDocRef.id}`);
        const clientsRef = userDocRef.collection('clients');
        const clientDocRefs = await clientsRef.listDocuments();
        for (const clientDocRef of clientDocRefs) {
          const clientDoc = await clientDocRef.get();
          if (clientDoc.exists) {
            const clientData = clientDoc.data();
            const doj = moment(clientData.DOJ.toDate()).tz('Asia/Kolkata').startOf('day');
            const dayperiod = clientData.dayperiod;
            const diffDays = today.diff(doj, 'days');

            if (diffDays === dayperiod) {
              console.log(`isko bhej raha: ${userDocRef.id}`);
              const apiKey =  "*******************************"; //your textlocal api here 
              const message = `Hi there, thank you for sending your first test message from Textlocal. See how you can send effective SMS campaigns here: https://tx.gl/r/2nGVj/`;
              const numbers = `91${clientData.phoneNum.toString()}`;
              const sender = '600010';

              const url = `https://api.textlocal.in/send/?apikey=${encodeURIComponent(apiKey)}&numbers=${encodeURIComponent(numbers)}&message=${encodeURIComponent(message)}&sender=${encodeURIComponent(sender)}`;
              const params = {
                apikey: apiKey,
                numbers: numbers,
                message: message,
                test: "true",
                sender: sender
              };
              const response = await axios.post(url, params);
              console.log('SMS response:', response.data);
            }
            if (dayperiod-diffDays ===7) {
              console.log(`isko bhej raha: ${userDocRef.id}`);
              const apiKey =  "*******************************"; //your textlocal api here 
              const message = `Hi there, thank you for sending your first test message from Textlocal. See how you can send effective SMS campaigns here: https://tx.gl/r/2nGVj/`;
              const numbers = `91${clientData.phoneNum.toString()}`;
              const sender = '600010';

              const url = `https://api.textlocal.in/send/?apikey=${encodeURIComponent(apiKey)}&numbers=${encodeURIComponent(numbers)}&message=${encodeURIComponent(message)}&sender=${encodeURIComponent(sender)}`;
              const params = {
                apikey: apiKey,
                numbers: numbers,
                message: message,
                test: "true",
                sender: sender
              };
              const response = await axios.post(url, params);
              console.log('SMS response:', response.data);
            }
            if (dayperiod-diffDays ===3) {
              console.log(`isko bhej raha: ${userDocRef.id}`);
              const apiKey =  "*******************************"; //your textlocal api here 
              const message = `Hi there, thank you for sending your first test message from Textlocal. See how you can send effective SMS campaigns here: https://tx.gl/r/2nGVj/`;
              const numbers = `91${clientData.phoneNum.toString()}`;
              const sender = '600010';

              const url = `https://api.textlocal.in/send/?apikey=${encodeURIComponent(apiKey)}&numbers=${encodeURIComponent(numbers)}&message=${encodeURIComponent(message)}&sender=${encodeURIComponent(sender)}`;
              const params = {
                apikey: apiKey,
                numbers: numbers,
                message: message,
                test: "true",
                sender: sender
              };
              const response = await axios.post(url, params);
              console.log('SMS response:', response.data);
            }
          } else {
            console.log(`No data found for client: ${clientDocRef.id}`);
          }
        }
      }
    } catch (error) {
      console.error("Error fetching users' clients:", error);
    }
  });




  