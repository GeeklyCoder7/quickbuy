import 'package:ecommerce_application/models/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/colors/app_colors.dart';

class CategorySectionWidget extends StatefulWidget {
  final List<CategoryModel> categoriesList;
  final bool isLoading;

  const CategorySectionWidget(
      {super.key, required this.categoriesList, required this.isLoading});

  @override
  State<CategorySectionWidget> createState() => _CategorySectionWidgetState();
}

class _CategorySectionWidgetState extends State<CategorySectionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
      ),
      child: widget.isLoading ? showShimmerEffect() : showCategories(),
    );
  }

  //Method for showing the categories
  Widget showCategories() {
    return ListView.builder(
      itemCount: widget.categoriesList.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            children: [
              //Category circle image avatar
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.categoryBorder,
                      width: 0.5,
                    )),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    widget.categoriesList[index].categoryImageUrl,
                  ),
                ),
              ),

              //Category name text widget
              Expanded(
                child: Text(
                  widget.categoriesList.elementAt(index).categoryName,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //Method for showing the shimmer loading animation
  Widget showShimmerEffect() {
    return ListView.builder(
      itemCount: 5,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            children: [
              //Shimmer animation circle image
              Shimmer.fromColors(
                baseColor: Colors.grey[350]!,
                highlightColor: Colors.grey[50]!,
                period: Duration(milliseconds: 800),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.red,
                ),
              ),

              //Shimmer animation text widget
              Shimmer.fromColors(
                baseColor: Colors.grey[350]!,
                highlightColor: Colors.grey[50]!,
                period: Duration(milliseconds: 800),
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  height: 15,
                  width: 60,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
