import 'package:ecommerce_application/models/product_model.dart';
import 'package:ecommerce_application/utils/colors/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RandomProductsSectionWidget extends StatefulWidget {
  final List<ProductModel> productsList;
  const RandomProductsSectionWidget({super.key, required this.productsList});

  @override
  State<RandomProductsSectionWidget> createState() =>
      _RandomProductsSectionWidgetState();
}

class _RandomProductsSectionWidgetState
    extends State<RandomProductsSectionWidget> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.productsList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 20,
        childAspectRatio: 0.55,
      ),
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          shadowColor: AppColors.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          color: Colors.white,
          child: Column(
            children: [
              //Product image
              Container(
                height: 180,
                color: Colors.white,
                width: double.infinity,
                child: Image(
                  image: NetworkImage(
                    widget.productsList.elementAt(index).productImageUrl,
                  ),
                  fit: BoxFit.contain,
                ),
              ),

              //Product name
              Flexible(
                flex: 6,
                child: Text(
                  widget.productsList.elementAt(index).productName,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
              ),

              //Product price
              SizedBox(
                height: 10,
              ),
              Text(
                "₹ ${widget.productsList.elementAt(index).productPrice}",
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 15,
                ),
              ),

              //Product rating
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  5,
                  (index) {
                    return Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    );
                  },
                ),
              ),

              //Add to cart button
              TextButton(
                onPressed: () {},
                child: Container(
                  width: 80,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 5,),
                      Text(
                        "Add",
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.button_text,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
