import 'package:ecommerce_application/models/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors/app_colors.dart';

class CategorySectionWidget extends StatefulWidget {
  final List<CategoryModel> categoriesList;

  const CategorySectionWidget({super.key, required this.categoriesList});

  @override
  State<CategorySectionWidget> createState() => _CategorySectionWidgetState();
}

class _CategorySectionWidgetState extends State<CategorySectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
      ),
      child: ListView.builder(
        itemCount: widget.categoriesList.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Column(
              children: [
                //Category circle image avatar
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                    widget.categoriesList[index].categoryImageUrl,
                  ),
                ),

                //Category name text widget
                Expanded(
                  child: Text(
                    widget.categoriesList.elementAt(index).categoryName,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 17,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
