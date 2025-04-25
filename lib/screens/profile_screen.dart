import 'package:ecommerce_application/screens/user_wishlist_screen.dart';
import 'package:flutter/material.dart';
import '../utils/colors/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          "My Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Centers vertically
          children: [
            //Wishlist button
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserWishlistScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                minimumSize: Size(200, 45),
                side: BorderSide(color: AppColors.primary),
              ),
              child: Text(
                "My Wishlist",
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 20),

            //Address button
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                minimumSize: Size(200, 45),
                side: BorderSide(color: AppColors.primary),
              ),
              child: Text(
                "My Addresses",
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(height: 20),

            //Log out button
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                minimumSize: Size(200, 45),
                side: BorderSide(color: AppColors.primary),
              ),
              child: Text(
                "Log out",
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
