import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/datab.dart';  // Ensure correct path if necessary
import 'package:flutter_application_1/uihelp.dart'; // Ensure correct path if necessary
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class UpdateClient extends StatefulWidget {
  final String clientId; // Assuming you pass the clientId that you want to update
  const UpdateClient({Key? key, required this.clientId}) : super(key: key);

  @override
  State<UpdateClient> createState() => _UpdateClientState();
}

class _UpdateClientState extends State<UpdateClient> {
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
        title: const Text('Update Client', style: TextStyle(color: Colors.white)),
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
                child: UiHelp1.textf2(nameController, 'Full Name', Icons.person, false),
              ),
              SizedBox(width: 10),
              Expanded(
                child: UiHelp1.textf2(phonenumController, 'Phone No.', Icons.phone, false),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              Expanded(
                child: UiHelp1.textf2(emailController, 'Email', Icons.mail, false),
              ),
              SizedBox(width: 10),
              Expanded(
                child: UiHelp1.textf2(sexController, 'Sex', Icons.people, false),
              ),
            ],
          ),
          SizedBox(height: 30),
          Row(
            children: <Widget>[
              Expanded(
                child: UiHelp1.textf2(aadharController, 'Aadhar No.', Icons.document_scanner, false),
              ),
              SizedBox(width: 10),
              Expanded(
                child: UiHelp1.textf2(paymentController, 'Payment Amount', Icons.money, false),
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
          UiHelp1.textf2(addressController, 'Address', Icons.location_city, false),
          SizedBox(height: 20),
          UiHelp1.textf2(medhisController, 'Medical History', FontAwesomeIcons.bookMedical, false),
          SizedBox(height: 20),
          UiHelp1.textf2(periodController, 'Subscription Period', FontAwesomeIcons.hourglassHalf, false),
          SizedBox(height: 40),
          UiHelp1.button3(() => _updateClient(), Text('Update Client', style: TextStyle(color: Colors.white))),
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

  void _updateClient() async {
    if (!_formIsValid()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please check your inputs and try again.")));
      return;
    }

    setState(() => isLoading = true);
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No user is currently signed in.")));
      setState(() => isLoading = false);
      return;
    }
    try {
      await DataBaseS(uid: user.uid).updateClient(
        widget.clientId,
        nameController.text,
        emailController.text,
        int.parse(aadharController.text),
        int.parse(phonenumController.text),
        sexController.text,
        dob!,
        doj!,
        int.parse(paymentController.text),
        addressController.text,
        int.parse(periodController.text),
        medhisController.text,
        context
      );
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Client updated successfully!")));
      Navigator.pop(context, true);  // Optionally, return true if you need to notify of updates
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update client: ${e.toString()}")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  bool _formIsValid() {
    // Basic validation can go here
    return true;  // Adjust according to real validation rules
  }
}

