import 'package:ecommerce_application/screens/home_page_screen.dart';
import 'package:ecommerce_application/screens/sign_up_screen.dart';
import 'package:ecommerce_application/utils/colors/app_colors.dart';
import 'package:ecommerce_application/widgets/app_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  //variables to hande the state of the application
  bool _isPasswordObscure = true;
  bool _isLoading = false;

  //vairables to handle texfields
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _userPasswordController = TextEditingController();

  //variables for handling firebase operations
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      //Authenticate user with firebase
      await _firebaseAuth.signInWithEmailAndPassword(
        email: _userEmailController.text.trim(),
        password: _userPasswordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Login Successful!'),
      ));

      setState(() {
        _isLoading = false;
      });

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => HomePageScreen()));
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AppBarWidget(appBarTitle: 'Sign In')),
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
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
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
                },
                child: Text(
                  "Don't have an account? Create One",
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 16,
                  ),
                ),
              ),
              //login button
              TextButton(
                onPressed: _signIn,
                child: Container(
                  width: 100,
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
                    'Log In',
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
