import 'package:ecommerce_application/models/address_model.dart';
import 'package:ecommerce_application/widgets/saved_address_card_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../utils/colors/app_colors.dart';
import 'add_address_screen.dart';

class SavedAddressesScreen extends StatefulWidget {
  const SavedAddressesScreen({super.key});

  @override
  State<SavedAddressesScreen> createState() => _SavedAddressesScreenState();
}

class _SavedAddressesScreenState extends State<SavedAddressesScreen> {
  //Variables to handle database
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  //Lists
  List<AddressModel> savedAddressesList = [];

  //Method for fetching the saved addresses
  Future<void> fetchSavedAddresses() async {
    try {
      DatabaseReference savedAddressesNodeRef = databaseReference
          .child("users")
          .child(currentUserId)
          .child("saved_addresses");

      DatabaseEvent event = await savedAddressesNodeRef.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value != null) {
        Map<dynamic, dynamic> rawMap = snapshot.value as Map;
        List<AddressModel> temporarySavedAddressesList = [];

        for (var entry in rawMap.entries) {
          Map<String, dynamic> addressData =
              Map<String, dynamic>.from(entry.value);
          temporarySavedAddressesList.add(AddressModel.fromMap(addressData));
        }

        setState(() {
          savedAddressesList.clear();
          savedAddressesList = temporarySavedAddressesList;
        });
      }
    } catch (e) {
      print("Address fetching error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Address fetching error: $e"),
        ),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSavedAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: AppColors.primary,
        title: Text(
          "Saved Addresses",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            // Address Cards Widget
            SavedAddressCardWidget(
              savedAddressesList: savedAddressesList,
              onAddressUpdated: () {
                fetchSavedAddresses();
                setState(() {});
              },
            ),

            SizedBox(height: 10),

            // Add new address text
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddAddressScreen()),
                ).then((_) {
                  fetchSavedAddresses();
                  setState(() {});
                });
              },
              child: Text(
                "+ Add new address",
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
