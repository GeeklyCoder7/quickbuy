import 'package:ecommerce_application/models/category_model.dart';
import 'package:ecommerce_application/widgets/category_section_widget.dart';
import 'package:ecommerce_application/widgets/random_products_section_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_application/utils/colors/app_colors.dart';

import '../models/product_model.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  //Database references
  DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

  //Variables to fetch data from database
  List<CategoryModel> categories = [];
  List<ProductModel> products = [];

  //Variables to handle the state of the application
  bool isCategoryLoading = true;
  bool isProductLoading = true;

  //Method for fetching the categories from the database
  Future<void> fetchCategories() async {
    try {
      DatabaseReference categoriesNodeReference =
          databaseReference.child("categories");
      DatabaseEvent event = await categoriesNodeReference.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value != null) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(snapshot.value as Map);

        List<CategoryModel> temporaryCategoriesList = [];

        for (var category in data.values) {
          Map<String, dynamic> categoryData =
              Map<String, dynamic>.from(category);
          temporaryCategoriesList.add(CategoryModel.fromMap(categoryData));
        }

        setState(() {
          isCategoryLoading = false;
          categories = temporaryCategoriesList;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$e"),
        ),
      );
      setState(() {
        isCategoryLoading = false;
      });
    }
  }

  //Method for fetching products from the database
  Future<void> fetchProducts() async {
    try {
      DatabaseReference productsNodeReference =
          databaseReference.child("products");
      DatabaseEvent event = await productsNodeReference.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists && snapshot.value != null) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(snapshot.value as Map);
        List<ProductModel> temporaryProductsList = [];

        for (var product in data.values) {
          Map<String, dynamic> productData = Map<String, dynamic>.from(product);
          temporaryProductsList.add(ProductModel.fromMap(productData));
        }
        setState(() {
          products = temporaryProductsList;
          isProductLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$e"),
        ),
      );
      setState(() {
        isProductLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCategories();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search something',
              hintStyle: TextStyle(
                color: AppColors.text,
                fontSize: 18,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          //Categories section that hides when the user scrolls
          SliverAppBar(
            pinned: false,
            floating: true,
            snap: true,
            stretch: true,
            stretchTriggerOffset: 100,
            backgroundColor: AppColors.background,
            expandedHeight: 110,
            flexibleSpace: FlexibleSpaceBar(
              background: AnimatedOpacity(
                duration: Duration(milliseconds: 400),
                opacity: 1,
                child: CategorySectionWidget(
                  categoriesList: categories,
                  isLoading: isCategoryLoading,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                children: [
                  RandomProductsSectionWidget(
                    productsList: products,
                    isProductLoading: isProductLoading,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
