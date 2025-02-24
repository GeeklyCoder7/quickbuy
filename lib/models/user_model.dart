import 'package:flutter/foundation.dart';

class UserModel {
  String userId;
  String userEmail;

  UserModel({
    required this.userId,
    required this.userEmail,
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "userEmail": userEmail,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map["userId"] ?? "",
      userEmail: map["userEmail"] ?? "",
    );
  }
}
