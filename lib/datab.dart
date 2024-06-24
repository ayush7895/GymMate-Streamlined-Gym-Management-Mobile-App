import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/uihelp.dart';
import 'package:flutter/material.dart';

class DataBaseS {
  final String uid;
  DataBaseS({required this.uid});

  DocumentReference get userDocument =>
      FirebaseFirestore.instance.collection('MYusers').doc(uid);

Future<int> getActiveClients() async {
  try {
    QuerySnapshot querySnapshot = await userDocument.collection('clients')
        .where('period', isGreaterThan: 0)
        .get();
    return querySnapshot.docs.length;  // Returns the count of documents where period > 0
  } catch (e) {
    throw Exception('Error getting active clients: $e');
  }
}




  Future<int> getTotalClients() async {
    try {
      QuerySnapshot querySnapshot = await userDocument.collection('clients').get();
      return querySnapshot.docs.length;  // Returns the count of documents
    } catch (e) {
      throw Exception('Error getting total clients: $e');
    }
  }    

  Future<String> addClient(
      String clientId,
      String name,
      String email,
      int aadhar,
      int phoneNum,
      String sex,
      DateTime dob,
      DateTime doj,
      int payment,
      String address,
      int period,
      String medhis,
      BuildContext context) async {
    CollectionReference clients = userDocument.collection('clients');
     // Calculate dayperiod based on the period parameter.
  int dayperiod = period * 30;

  // Create the DOE by adding dayperiod days to the DOJ
  DateTime doe = doj.add(Duration(days: dayperiod));
    
    try {
      DocumentReference docRef = await clients.add({
        'name': name,
        'email': email,
        'Aadhar': aadhar,
        'phoneNum': phoneNum,
        'sex': sex,
        'DOB': Timestamp.fromDate(dob),
        'DOJ': Timestamp.fromDate(doj),
        'DOE': Timestamp.fromDate(doe) ,
        'payment': payment,
        'address': address,
        'period': period,
        'dayperiod':dayperiod,
        'medhis': medhis,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return "Client added with ID: ${docRef.id}";
    } catch (e) {
      throw Exception('Failed to add client: ${e.toString()}');
    }
  }

  Future<void> updateClient(
      String clientId,
      String name,
      String email,
      int aadhar,
      int phoneNum,
      String sex,
      DateTime dob,
      DateTime doj,
      int payment,
      String address,
      int period,
      String medhis,
      BuildContext context) async {
    DocumentReference clientDoc =
        userDocument.collection('clients').doc(clientId);
      
       // Calculate dayperiod based on the period parameter.
  int dayperiod = period * 30;

  // Create the DOE by adding dayperiod days to the DOJ
  DateTime doe = doj.add(Duration(days: dayperiod));
    try {
      await clientDoc.update({
        'name': name,
        'email': email,
        'Aadhar': aadhar,
        'phoneNum': phoneNum,
        'sex': sex,
        'DOB': Timestamp.fromDate(dob),
        'DOJ': Timestamp.fromDate(doj),
        'DOE': Timestamp.fromDate(doe) ,
        'payment': payment,
        'address': address,
        'period': period,
        'dayperiod':dayperiod,
        'medhis': medhis,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      await UiHelp1.showCustomAlertBox(context,
          title: 'Error', content: 'Failed to update client: ${e.toString()}');
    }
  }

  Future<void> deleteClient(String clientId, BuildContext context) async {
    DocumentReference clientDoc =
        userDocument.collection('clients').doc(clientId);
    try {
      await clientDoc.delete();
    } catch (e) {
      await UiHelp1.showCustomAlertBox(context,
          title: 'Error', content: 'Failed to Delete client: ${e.toString()}');
    }}


  Stream<QuerySnapshot> searchActiveClients(String query) {
   // Get today's date and convert it to a Timestamp
   DateTime now = DateTime.now();
   Timestamp todayTimestamp = Timestamp.fromDate(DateTime(now.year, now.month, now.day));

   return FirebaseFirestore.instance
      .collection('MYusers')
      .doc(uid)
      .collection('clients')
      // Check if DOE has passed or is today
      .where('DOE', isLessThanOrEqualTo: todayTimestamp)
      // Search for names that start with the query string
      .where('name', isGreaterThanOrEqualTo: query)
      .where('name', isLessThanOrEqualTo: query + '\uf8ff')
      .snapshots();
}

Future<void> updateClientPeriod(String clientId, int newPeriod, BuildContext context) async {
  DocumentReference clientDoc = userDocument.collection('clients').doc(clientId);
  int dayperiod = newPeriod * 30;
  DateTime doe = DateTime.now().add(Duration(days: dayperiod));
  try {
    // Update the document with the new period and a new createdAt timestamp
    await clientDoc.update({
      'period': newPeriod,
      'dayperiod':dayperiod,
      'DOE': Timestamp.fromDate(doe) ,
      'DOJ': FieldValue.serverTimestamp(), // Set a new server timestamp
    });
  } catch (e) {
    await UiHelp1.showCustomAlertBox(context, title: 'Error', content: 'Failed to update period: ${e.toString()}');
  }
}



   Stream<QuerySnapshot> searchClients(String query) {
    return FirebaseFirestore.instance
        .collection('MYusers')
        .doc(uid)
        .collection('clients')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .snapshots();
  }
}

