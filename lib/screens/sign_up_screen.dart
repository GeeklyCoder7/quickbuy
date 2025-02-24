import 'package:ecommerce_application/models/user_model.dart';
import 'package:ecommerce_application/screens/add_address_screen.dart';
import 'package:ecommerce_application/screens/sign_in_screen.dart';
import 'package:ecommerce_application/utils/colors/app_colors.dart';
import 'package:ecommerce_application/widgets/app_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  //variables to hande the state of the application
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;
  bool _isLoading = false;

  //variables to store important firebase credentials
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref();

  //vairables to handle texfields
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  //Other varialbes to store the data
  String _userEmail = "";
  String _userPassword = "";
  String _userId = "";

  //Method for handling the sign-up
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    //Storing the text field values in the variables
    _userEmail = _userEmailController.text.trim();
    _userPassword = _userPasswordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      //Create user in the firebase authentication
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: _userEmail,
        password: _userPassword,
      );

      _userId = userCredential.user!.uid; //Get firebase user UID

      //Creating a user object
      UserModel newUser = UserModel(
          userId: _userId, userEmail: _userEmail);

      //Storing the data in the firebase realtime database
      await _databaseReference.child("users").child(_userId).set(newUser.toMap());

      _userEmailController.clear();
      _userPasswordController.clear();

      //Navigate to the sign-up screen
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => AddAddressScreen()),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBarWidget(appBarTitle: 'Create an account'),
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              //Email address texfield
              TextFormField(
                controller: _userEmailController,
                decoration: InputDecoration(
                  labelText: 'Email ID',
                  labelStyle: TextStyle(
                    color: AppColors.text,
                  ),
                  border: OutlineInputBorder(),
                  hintText: 'Enter your email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 30,
              ),
              //Password textfield
              TextFormField(
                obscureText: _isPasswordObscure,
                controller: _userPasswordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: AppColors.text,
                  ),
                  border: OutlineInputBorder(),
                  hintText: 'Set your password',
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordObscure
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isPasswordObscure = !_isPasswordObscure;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required!';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 30,
              ),
              //Confirm password textfield
              TextFormField(
                obscureText: _isConfirmPasswordObscure,
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(
                    color: AppColors.text,
                  ),
                  border: OutlineInputBorder(),
                  hintText: 'Confirm your password',
                  suffixIcon: IconButton(
                    icon: Icon(_isConfirmPasswordObscure
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordObscure = !_isConfirmPasswordObscure;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _userPasswordController.text) {
                    return "Passwords don't match";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 30,
              ),
              //Already have an account text widget
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignInScreen()));
                },
                child: Text(
                  'Already have an account? Sign In',
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              //Proceed button widget
              TextButton(
                onPressed: _signUp,
                child: Container(
                  width: 200,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Proceed',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
