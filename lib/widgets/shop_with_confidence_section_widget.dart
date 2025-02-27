import 'package:ecommerce_application/utils/colors/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShopWithConfidenceSectionWidget extends StatelessWidget {
  const ShopWithConfidenceSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //Replacement icon
        Column(
          children: [
            //Image
            CircleAvatar(
              backgroundColor: AppColors.image_background_color,
              radius: 35,
              child: Image(
                image: AssetImage(
                  "assets/images/icons/product_replacement_icon.png",
                ),
                fit: BoxFit.cover,
                height: 55,
              ),
            ),
            SizedBox(height: 5,),

            //Text
            Text(
              "7 days replacement",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 14,
              ),
            ),
          ],
        ),

        //Return icon
        Column(
          children: [
            //Image
            CircleAvatar(
              backgroundColor: AppColors.image_background_color,
              radius: 35,
              child: Image(
                image: AssetImage(
                  "assets/images/icons/product_return_icon.png",
                ),
                fit: BoxFit.cover,
                height: 55,
              ),
            ),
            SizedBox(height: 5,),

            //Text
            Text(
              "Easy returns",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 14,
              ),
            ),
          ],
        ),

        //COD icon
        Column(
          children: [
            //Image
            CircleAvatar(
              backgroundColor: AppColors.image_background_color,
              radius: 35,
              child: Image(
                image: AssetImage(
                  "assets/images/icons/cod_icon.png",
                ),
                fit: BoxFit.cover,
                height: 52,
              ),
            ),
            SizedBox(height: 5,),

            //Text
            Text(
              "Cash on Delivery",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.text,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
