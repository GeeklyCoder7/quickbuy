import 'package:ecommerce_application/screens/cart_screen.dart';
import 'package:ecommerce_application/screens/home_page_screen.dart';
import 'package:ecommerce_application/screens/orders_screen.dart';
import 'package:ecommerce_application/screens/profile_screen.dart';
import 'package:ecommerce_application/utils/colors/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavbarScreenWidget extends StatefulWidget {
  const BottomNavbarScreenWidget({super.key});

  @override
  State<BottomNavbarScreenWidget> createState() =>
      _BottomNavbarScreenWidgetState();
}

class _BottomNavbarScreenWidgetState extends State<BottomNavbarScreenWidget> {
  //This list will be used to store the different screens the app will have which we want navigate through
  final List<Widget> appScreenWidgetList = [
    HomePageScreen(),
    ProfileScreen(),
    OrdersScreen(),
    CartScreen(),
  ];

  //This index will be used to store the index of the current selected screen from the screens list
  int selectedScreenIndex = 0;

  //method to change the screen when the icon is tapped
  void changeScreen(int index) {
    setState(() {
      selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appScreenWidgetList[selectedScreenIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedScreenIndex,
        onTap: changeScreen,
        backgroundColor: AppColors.primary,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.shadow,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person)
          ),
          BottomNavigationBarItem(
            label: "Orders",
            icon: Icon(Icons.local_shipping_outlined),
            activeIcon: Icon(Icons.local_shipping)
          ),
          BottomNavigationBarItem(
            label: "Cart",
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart)
          )
        ],
      ),
    );
  }
}
