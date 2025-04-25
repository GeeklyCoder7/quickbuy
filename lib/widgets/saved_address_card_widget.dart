import 'package:ecommerce_application/models/address_model.dart';
import 'package:ecommerce_application/utils/colors/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SavedAddressCardWidget extends StatefulWidget {
  final List<AddressModel> savedAddressesList;

  const SavedAddressCardWidget({
    super.key,
    required this.savedAddressesList,
  });

  @override
  State<SavedAddressCardWidget> createState() => _SavedAddressCardWidgetState();
}

class _SavedAddressCardWidgetState extends State<SavedAddressCardWidget> {
  //Method for changing the default address
  Future<void> setDefaultAddress(String selectedAddressId) async {
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

        // Optional: Refresh the UI
        setState(() {});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return displaySavedAddress();
  }

  //Widget for displaying saved addresses
  Widget displaySavedAddress() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.savedAddressesList.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(2),
              ),
              side: BorderSide(
                color: Colors.grey.shade300,
                width: 0.5,
              )),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Receiver full name
                  Text(
                    widget.savedAddressesList[index].receiverFullName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),

                  //Receiver's full address text
                  Text(
                    "${widget.savedAddressesList[index].apartmentNo}, ${widget.savedAddressesList[index].buildingName}, \n${widget.savedAddressesList[index].area}, ${widget.savedAddressesList[index].city}, \n${widget.savedAddressesList[index].state} - ${widget.savedAddressesList[index].postalCode} \n${"Phone number: ${widget.savedAddressesList[index].contactNo}"}",
                    style: TextStyle(
                      color: AppColors.text,
                      fontSize: 14,
                    ),
                  ),

                  //Utility buttons row
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: widget.savedAddressesList[index].isSetDefault ? [
                    //Edit button
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        "Edit",
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    //Remove button
                    SizedBox(width: 15,),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        "Remove",
                        style: TextStyle(
                          color: AppColors.text,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    ] : [
                      //Edit button
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          "Edit",
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      //Remove button
                      SizedBox(width: 15,),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          "Remove",
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      //Set as default button
                      SizedBox(width: 15,),
                      OutlinedButton(
                        onPressed: () async {
                          String selectedAddressId = widget.savedAddressesList[index].addressId;
                          await setDefaultAddress(selectedAddressId);
                          setState(() {});
                        },
                        style: OutlinedButton.styleFrom(
                          padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          "Set as Default",
                          style: TextStyle(
                            color: AppColors.text,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
