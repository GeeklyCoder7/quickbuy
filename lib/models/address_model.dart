class AddressModel {
  String addressId;
  String receiverFullName;
  String apartmentNo;
  String buildingName;
  String area;
  String city;
  String state;
  String postalCode;
  String contactNo;
  bool isSetDefault;

  AddressModel({
    required this.addressId,
    required this.receiverFullName,
    required this.apartmentNo,
    required this.buildingName,
    required this.area,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.contactNo,
    required this.isSetDefault,
  });

  Map<String, dynamic> toMap() {
    return {
      'addressId': addressId,
      'receiverFullName': receiverFullName,
      'apartmentNo': apartmentNo,
      'buildingName': buildingName,
      'area': area,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'contactNo': contactNo,
      'isSetDefault': isSetDefault,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      addressId: map['addressId'],
      receiverFullName: map['receiverFullName'],
      apartmentNo: map['apartmentNo'],
      buildingName: map['buildingName'],
      area: map['area'],
      city: map['city'],
      state: map['state'],
      postalCode: map['postalCode'],
      contactNo: map['contactNo'],
      isSetDefault: map['isSetDefault'],
    );
  }
}
