import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/datab.dart';  // Ensure correct path if necessary
import 'package:flutter_application_1/uihelp.dart'; // Ensure correct path if necessary
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class clientDeet extends StatefulWidget {
  final String clientId; // Assuming you pass the clientId that you want to update
  const clientDeet({Key? key, required this.clientId}) : super(key: key);

  @override
  State<clientDeet> createState() => _clientDeetState();
}

class _clientDeetState extends State<clientDeet> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController phonenumController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController paymentController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController periodController = TextEditingController();
  final TextEditingController medhisController = TextEditingController();
  DateTime? dob;
  DateTime? doj;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchClientData();
  }

 Future<void> fetchClientData() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No user is currently signed in.")));
    setState(() => isLoading = false);
    return;
  }
  
  try {
    DocumentSnapshot clientData = await FirebaseFirestore.instance
      .collection('MYusers')      // Assuming there is a users collection
      .doc(user.uid)            // Document for the logged-in user
      .collection('clients')    // Subcollection for clients under the user
      .doc(widget.clientId)     // Specific client ID
      .get();
    
    if (clientData.exists) {
      Map<String, dynamic> data = clientData.data() as Map<String, dynamic>;
      
      // Assign data to controllers
      nameController.text = data['name'] ?? '';
      emailController.text = data['email'] ?? '';
      aadharController.text = data['Aadhar'].toString();
      phonenumController.text = data['phoneNum'].toString();
      sexController.text = data['sex'] ?? '';
      dob = (data['DOB'] as Timestamp?)?.toDate();
      doj = (data['DOJ'] as Timestamp?)?.toDate();
      paymentController.text = data['payment'].toString();
      addressController.text = data['address'] ?? '';
      periodController.text = data['period'].toString();
      medhisController.text = data['medhis'] ?? '';
    } else {
      print("No data found for client ID: ${widget.clientId} under user ID: ${user.uid}");
    }
  } catch (e) {
    print('Failed to fetch client data: ${e.toString()}');
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to load data: ${e.toString()}")));
  } finally {
    setState(() {
      isLoading = false;
    });
  }
}



  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    aadharController.dispose();
    phonenumController.dispose();
    sexController.dispose();
    paymentController.dispose();
    addressController.dispose();
    periodController.dispose();
    medhisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Client', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(168, 195, 221, 0.7),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : buildForm(context),
    );
  }

  Widget buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          SizedBox(height: 20),
          Row(
            children: <Widget>[

              Expanded(
                flex: 3,
                child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  icon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),),
              SizedBox(width: 10),
              Expanded(flex: 2,
              child: TextField(
                controller: phonenumController,
                decoration: InputDecoration(
                  labelText: 'Phone No.',
                  icon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,),
        
              )
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              Expanded(flex: 3,
              
               child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(Icons.mail),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
              ),
              SizedBox(width: 10),
              Expanded(flex: 1,
              child: TextField(
                controller: sexController,
                decoration: InputDecoration(
                  labelText: 'Sex',
                  icon: Icon(Icons.people),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
     
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              Expanded(flex:3,
              child: TextField(
                controller: aadharController,
                decoration: InputDecoration(
                  labelText: 'Aadhar No.',
                  icon: Icon(Icons.document_scanner),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
                
              ),
              SizedBox(width: 10),
              Expanded(flex:2,
              child: TextField(
                controller: paymentController,
                decoration: InputDecoration(
                  labelText: 'Payment Amount',
                  icon: Icon(Icons.money),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
               
                
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              Expanded(
                child: _buildDatePicker("Date of Joining", (date) => setState(() => doj = date), doj),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _buildDatePicker("Date of Birth", (date) => setState(() => dob = date), dob),
              ),
            ],
          ),
          SizedBox(height: 20),
          TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  icon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
          ),
        
          SizedBox(height: 20),
          TextField(
                controller: medhisController,
                decoration: InputDecoration(
                  labelText: 'Medical History',
                  icon: Icon(Icons.medical_information),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
        
          SizedBox(height: 20),
          TextField(
                controller: periodController,
                decoration: InputDecoration(
                  labelText: 'Subscription duration/Period',
                  icon: Icon(Icons.hourglass_bottom),
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),
          SizedBox(height: 40),
         
        ],
      ),
    );
  }

  Widget _buildDatePicker(String label, ValueChanged<DateTime> onSelect, DateTime? selectedDate) {
    return ListTile(
      title: Text(label, style: TextStyle(fontSize: 15)),
      subtitle: Text(selectedDate == null ? 'Select Date' : DateFormat('yyyy-MM-dd').format(selectedDate), style: TextStyle(fontSize: 13)),
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (picked != null && picked != selectedDate) {
          onSelect(picked);
        }
      },
    );
  }

}