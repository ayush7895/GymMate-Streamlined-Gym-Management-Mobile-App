import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/datab.dart'; // Ensure this path matches your actual database file

class RenewClient extends StatefulWidget {
  final String uid;
  const RenewClient({Key? key, required this.uid}) : super(key: key);

  @override
  _RenewClientState createState() => _RenewClientState();
}

class _RenewClientState extends State<RenewClient> {
  TextEditingController searchController = TextEditingController();
  DataBaseS? db;
  Timer? _debounce;
  Stream<QuerySnapshot>? clientStream;

  @override
  void initState() {
    super.initState();
    db = DataBaseS(uid: widget.uid);
    clientStream = db?.searchActiveClients("");
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          clientStream = db?.searchActiveClients(searchController.text);
        });
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _showEditPeriodDialog(String clientId, String currentPeriod) {
  final TextEditingController _periodController = TextEditingController(text: currentPeriod);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Update Period"),
        content: TextField(
          controller: _periodController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: "Enter new period",
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text("Update"),
            onPressed: () {
              int newPeriod = int.tryParse(_periodController.text) ?? 0;
              if (newPeriod > 0) {
                // Update the client's period using the database service
                db?.updateClientPeriod(clientId, newPeriod, context).then((_) {
                  Navigator.of(context).pop(); // Close the dialog
                  showSnackbar('Period updated successfully');
                }).catchError((error) {
                  print("Update failed: $error");
                  Navigator.of(context).pop(); // Close the dialog
                  showSnackbar('Failed to update period');
                });
              } else {
                showSnackbar('Invalid period entered');
              }
            },
          ),
        ],
      );
    }
  );
}

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 20, 23, 1),
      appBar: AppBar(
        title: const Text(
          'Renew Client',
          style: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 1),
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(168, 195, 221, 0.7),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search by name",
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: clientStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return InkWell(
                      onTap: () => _showEditPeriodDialog(document.id, data['period'].toString()),
                      child: Card(
                        elevation: 2.0,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        child: ListTile(
                          title: Text(data['name'], style: TextStyle(color: Colors.white)),
                          subtitle: Text('Mobile no.: ${data['phoneNum']}', style: TextStyle(color: Colors.grey)),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, size: 20.0, color: Colors.red),
                            onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Confirm"),
                                  content: const Text("Are you sure you want to delete this client?"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text("Delete"),
                                      onPressed: () {
                                        db?.deleteClient(document.id, context).then((_) {
                                          Navigator.of(context).pop(); // Close the dialog
                                          showSnackbar('Client deleted successfully');
                                        }).catchError((error) {
                                          print("Delete failed: $error");
                                          Navigator.of(context).pop(); // Close the dialog
                                          showSnackbar('Failed to delete client');
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
