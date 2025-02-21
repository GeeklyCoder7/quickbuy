import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors/app_colors.dart';

class AppBarWidget extends StatelessWidget {
  final String appBarTitle;
  const AppBarWidget({super.key, required this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        appBarTitle,
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
        ),
      ),
      backgroundColor: AppColors.primary,
      iconTheme: IconThemeData(color: Colors.white),
    );
  }
}
