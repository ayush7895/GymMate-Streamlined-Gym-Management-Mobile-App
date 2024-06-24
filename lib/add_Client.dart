import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/uihelp.dart';
import 'package:flutter_application_1/datab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart'; // Add this line for date formatting

class AddClient extends StatefulWidget {
  const AddClient({Key? key}) : super(key: key);

  @override
  State<AddClient> createState() => _AddClientState();
}

class _AddClientState extends State<AddClient> {
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
  bool isLoading = false;

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
        title: const Text('Add Client', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(168, 195, 221, 0.7),
      ),
      body: SingleChildScrollView(
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
                    flex: 4, 
                    child: UiHelp1.textf2(emailController, 'Email', Icons.mail, false),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2, 
                    child: UiHelp1.textf2(sexController, 'Sex',Icons.people, false),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3, 
                    child: UiHelp1.textf2(aadharController, 'Aadhar No.', Icons.document_scanner, false),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2, 
                    child: UiHelp1.textf2(paymentController, 'Payment Amount', Icons.money, false),
                  ),
                ],
              ),
              SizedBox(height: 7),
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
              SizedBox(height: 7),
              UiHelp1.textf2(addressController, 'Address', Icons.location_city, false),
              SizedBox(height: 20),
              UiHelp1.textf2(medhisController, 'Medical History', FontAwesomeIcons.bookMedical, false),
              SizedBox(height: 20),
              UiHelp1.textf2(periodController, 'Subscription Period', FontAwesomeIcons.hourglassHalf, false),
              SizedBox(height: 40),
            const SizedBox(height: 20),
            UiHelp1.button3(() => _addClient(), isLoading ? CircularProgressIndicator() : Text('Add Client', style: TextStyle(color: Colors.white),)),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(String label, ValueChanged<DateTime> onSelect, DateTime? selectedDate) {
    return ListTile(
      title: Text(label, style: TextStyle( fontSize: 15),),
      subtitle: Text(selectedDate == null ? 'Select Date' : DateFormat('yyyy-MM-dd').format(selectedDate), style: TextStyle(fontSize: 13),),
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

  void _addClient() async {
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
      String response = await DataBaseS(uid: user?.uid ?? "default-uid").addClient(
        '',
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Client added successfully: $response")));
      _clearFields(); 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to add client: ${e.toString()}")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  bool _formIsValid() {
    // Extend your validation logic here
    return nameController.text.isNotEmpty &&
           emailController.text.isNotEmpty &&
           phonenumController.text.isNotEmpty&&
           aadharController.text.length == 12 &&
           dob != null &&
           doj != null && periodController.text.isNotEmpty;

  }
  void _clearFields() {
  nameController.clear();
  emailController.clear();
  aadharController.clear();
  phonenumController.clear();
  sexController.clear();
  dob = null;
  doj = null;
  paymentController.clear();
  addressController.clear();
  periodController.clear();
  medhisController.clear();
}
}
