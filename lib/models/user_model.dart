import 'package:flutter/foundation.dart';

class UserModel {
  String userId;
  String userFullName;
  String userEmail;

  UserModel({
    required this.userId,
    required this.userFullName,
    required this.userEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "userFullName": userFullName,
      "userEmail": userEmail,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map["userId"] ?? "",
      userFullName: map["userFullName"] ?? "",
      userEmail: map["userEmail"] ?? "",
    );
  }
}
