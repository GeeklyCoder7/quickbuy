import 'package:ecommerce_application/models/address_model.dart';
import 'package:ecommerce_application/screens/saved_addresses_screen.dart';
import 'package:ecommerce_application/services/address_service.dart';
import 'package:ecommerce_application/utils/colors/app_colors.dart';
import 'package:ecommerce_application/widgets/app_bar_widget.dart';
import 'package:ecommerce_application/widgets/textfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddAddressScreen extends StatefulWidget {
  final AddressModel? existingAddress;
  const AddAddressScreen({super.key, this.existingAddress});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  //Firebase variables
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
  String currentUserId = FirebaseAuth.instance.currentUser!.uid.toString();

  //Text field variables
  final formKey = GlobalKey<FormState>();

  final TextEditingController receiverFullNameController =
      TextEditingController();
  final TextEditingController apartmentNoController = TextEditingController();
  final TextEditingController buildingNameController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController contactNoController = TextEditingController();

  bool setAsDefault = false;

  //Method for saving the address to the database
  Future<void> saveAddress() async {
    if (formKey.currentState!.validate()) {
      try {
        AddressModel newAddressModel = AddressModel(
          addressId: "",
          receiverFullName: receiverFullNameController.text.trim(),
          apartmentNo: apartmentNoController.text.trim().toString(),
          buildingName: buildingNameController.text.trim(),
          area: areaController.text.trim(),
          city: cityController.text.trim(),
          state: stateController.text.trim(),
          postalCode: postalCodeController.text.trim().toString(),
          contactNo: contactNoController.text.trim().toString(),
          isSetDefault: setAsDefault,
        );

        try {
          if (widget.existingAddress == null) {
            await AddressService().addNewAddress(newAddressModel);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Address added successfully"),
              ),
            );
          } else {
            AddressModel updatedAddressModel = AddressModel(
              addressId: widget.existingAddress!.addressId,
              receiverFullName: receiverFullNameController.text.trim(),
              apartmentNo: apartmentNoController.text.trim().toString(),
              buildingName: buildingNameController.text.trim(),
              area: areaController.text.trim(),
              city: cityController.text.trim(),
              state: stateController.text.trim(),
              postalCode: postalCodeController.text.trim().toString(),
              contactNo: contactNoController.text.trim().toString(),
              isSetDefault: setAsDefault,
            );

            await AddressService().updateAddress(updatedAddressModel, context);

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Address updated successfully"),
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: $e"),
            ),
          );
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Address added successfully"),
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$e"),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.existingAddress != null) {
      receiverFullNameController.text =
          widget.existingAddress!.receiverFullName;
      apartmentNoController.text = widget.existingAddress!.apartmentNo;
      buildingNameController.text = widget.existingAddress!.buildingName;
      areaController.text = widget.existingAddress!.area;
      cityController.text = widget.existingAddress!.city;
      stateController.text = widget.existingAddress!.state;
      postalCodeController.text = widget.existingAddress!.postalCode;
      contactNoController.text = widget.existingAddress!.contactNo;
      setAsDefault = widget.existingAddress!.isSetDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBarWidget(appBarTitle: 'Add address'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: formKey,
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      //Receiver's full name text field
                      TextfieldWidget(
                          hintText: "Full Name",
                          controller: receiverFullNameController),

                      //Apartment no. text field
                      TextfieldWidget(
                        hintText: "Apartment no.",
                        controller: apartmentNoController,
                        inputType: TextInputType.number,
                      ),

                      //Building name text field
                      TextfieldWidget(
                          hintText: "Building Name",
                          controller: buildingNameController),

                      //Area text field
                      TextfieldWidget(
                          hintText: "Area", controller: areaController),

                      //City name text field
                      TextfieldWidget(
                          hintText: "City", controller: cityController),

                      //State text field
                      TextfieldWidget(
                          hintText: "State", controller: stateController),

                      //Postal code text field
                      TextfieldWidget(
                        hintText: "Pin Code",
                        controller: postalCodeController,
                        inputType: TextInputType.number,
                      ),

                      //Contact no. text field
                      TextfieldWidget(
                        hintText: "Phone Number",
                        controller: contactNoController,
                        inputType: TextInputType.phone,
                      ),

                      //Set as default buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Set as Default address",
                            style: TextStyle(
                              color: AppColors.text,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Switch(
                            value: setAsDefault,
                            onChanged: (newValue) {
                              setState(() {
                                setAsDefault = newValue;
                              });
                            },
                            activeColor: AppColors.primary, // thumb when ON
                            activeTrackColor: AppColors.primary
                                .withOpacity(0.4), // track when ON
                            inactiveThumbColor:
                                Colors.grey.shade400, // thumb when OFF
                            inactiveTrackColor:
                                Colors.grey.shade300, // track when OFF
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                //Save address button
                Center(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () async {
                        await saveAddress();
                      },
                      borderRadius: BorderRadius.circular(20),
                      splashColor: Colors.white.withOpacity(0.2),
                      highlightColor: Colors.white.withOpacity(0.1),
                      child: Container(
                        width: 150,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.buy_button_color,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: Text(
                            "Save",
                            style: TextStyle(
                                color: AppColors.text,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
