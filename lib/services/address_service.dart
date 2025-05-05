import 'package:ecommerce_application/models/address_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddressService {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  // Add a new address
  Future<void> addNewAddress(AddressModel addressModel) async {
    if (addressModel.isSetDefault) {
      await unsetDefaultAddress(); // unset previous default if new one is set
    }

    DatabaseReference newAddressRef = databaseReference
        .child("users")
        .child(currentUserId)
        .child("saved_addresses")
        .push();

    String addressId = newAddressRef.key!;
    addressModel.addressId = addressId;

    await newAddressRef.set(addressModel.toMap());
  }

  // Unset the currently set default address (if any)
  Future<void> unsetDefaultAddress() async {
    DatabaseReference userAddressesRef = databaseReference
        .child("users")
        .child(currentUserId)
        .child("saved_addresses");

    DataSnapshot snapshot = await userAddressesRef.get();
    if (snapshot.exists) {
      Map addresses = snapshot.value as Map;
      addresses.forEach((key, value) {
        if (value['isSetDefault'] == true) {
          userAddressesRef.child(key).update({'isSetDefault': false});
        }
      });
    }
  }

  //Method for changing the default address
  Future<void> setDefaultAddress(
      String selectedAddressId, BuildContext context) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      DatabaseReference addressRef = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(currentUserId)
          .child("saved_addresses");

      // Get all addresses
      DataSnapshot snapshot = await addressRef.get();
      if (snapshot.exists) {
        Map addressMap = snapshot.value as Map;

        for (var key in addressMap.keys) {
          // Set isSetDefault to false for all addresses
          await addressRef.child(key).update({
            'isSetDefault': false,
          });
        }

        // Set isSetDefault = true for the selected address
        await addressRef.child(selectedAddressId).update({
          'isSetDefault': true,
        });

        // Optional: Show feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Default address updated.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  //Method for deleting an address from the database
  Future<void> removeAddress(String addressId, BuildContext context) async {
    try {
      DatabaseReference savedAddressesNodeRef = databaseReference
          .child("users")
          .child(currentUserId)
          .child("saved_addresses")
          .child(addressId);
      if (await savedAddressesNodeRef.get().then((value) => value.exists)) {
        await savedAddressesNodeRef.remove();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Address removed successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Address not found")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  //Method for updating the existing address
  Future<void> updateAddress(
      AddressModel updatedAddressModel, BuildContext context) async {
    try {
      if (updatedAddressModel.isSetDefault) {
        await unsetDefaultAddress();
      }

      DatabaseReference addressRef = databaseReference
          .child("users")
          .child(currentUserId)
          .child("saved_addresses")
          .child(updatedAddressModel.addressId);

      await addressRef.update(updatedAddressModel.toMap());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  //Method for getting the default address id from the database
  Future<String> getDefaultAddressId() async {
    try {
      // Reference to the user's saved addresses in Firebase
      DatabaseReference addressRef = databaseReference
          .child("users")
          .child(currentUserId)
          .child("saved_addresses");

      // Get the saved addresses snapshot
      DataSnapshot snapshot = await addressRef.get();

      if (snapshot.exists) {
        // Loop through the addresses to find the one marked as default
        Map addresses = snapshot.value as Map;
        for (var key in addresses.keys) {
          if (addresses[key]['isSetDefault'] == true) {
            return key; // Return the addressId of the default address
          }
        }
      }

      // If no default address is found, return an empty string or handle appropriately
      throw Exception("No default address found");
    } catch (e) {
      throw Exception("Failed to fetch default address: $e");
    }
  }
}
