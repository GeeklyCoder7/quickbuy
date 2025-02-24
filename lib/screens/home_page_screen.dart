import 'package:ecommerce_application/models/category_model.dart';
import 'package:ecommerce_application/widgets/category_section_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_application/utils/colors/app_colors.dart';

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

  //Variables to handle the state of the application
  bool isCategoryLoading = true;

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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCategories();
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
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("Hello World $index times"),
                );
              },
              childCount: 50,
            ),
          ),
        ],
      ),
    );
  }
}
