import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/datab.dart'; // Ensure this path matches your database file
import 'package:flutter_application_1/updatec.dart'; // Make sure this import is correct

class SearchClientPage extends StatefulWidget {
  final String uid;
  const SearchClientPage({Key? key, required this.uid}) : super(key: key);

  @override
  _SearchClientPageState createState() => _SearchClientPageState();
}

class _SearchClientPageState extends State<SearchClientPage> {
  TextEditingController searchController = TextEditingController();
  DataBaseS? db;
  Timer? _debounce;
  Stream<QuerySnapshot>? clientStream;

  @override
  void initState() {
    super.initState();
    db = DataBaseS(uid: widget.uid);
    clientStream = db?.searchClients("");
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      clientStream = db?.searchClients(searchController.text.trim());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(19, 20, 23, 1),
      appBar: AppBar(
        title: const Text('Search Client', style: TextStyle(color: Colors.white, fontFamily: 'Inter')),
        backgroundColor: const Color.fromRGBO(168, 195, 221, 0.7),
        centerTitle: true
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              cursorColor: Colors.white,
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search by Name',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () => searchController.clear(),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Color.fromRGBO(196, 196, 196, 0.27),
                contentPadding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 25.0),
              ),
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            ),
          ),
          SizedBox(height: 20),
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
                    return Card(
                      elevation: 2.0,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: ListTile(
                        title: Text(data['name'], style: TextStyle(color: Colors.white)),
                        subtitle: Text('Mobile no.: ${data['phoneNum']}', style: TextStyle(color: Colors.grey)),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.white),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => UpdateClient(clientId: document.id),
                              ),
                            );
                          },
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
