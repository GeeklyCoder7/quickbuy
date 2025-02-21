import 'package:ecommerce_application/utils/colors/app_colors.dart';
import 'package:ecommerce_application/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBarWidget(appBarTitle: 'Add address'),
      ),
    );
  }
}
