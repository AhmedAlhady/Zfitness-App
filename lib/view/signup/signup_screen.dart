import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/view/login/login_screen.dart';
import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';

class SignupScreen extends StatefulWidget {
  static String routeName = "/SignupScreen";

  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isCheck = false;
  // Added a state variable for loading indicator
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with Firebase registration

      // --- Show Loading Indicator ---
      setState(() {
        _isLoading = true;
      });
      // ----------------------------

      try {
        // Attempt to create user with email and password
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        User? user = userCredential.user;

        if (user != null) {
          // --- Attempt to update the user's display name ---
          // This call is crucial for the name to appear on the Welcome screen.
          // Ensure it completes before navigating.
          await user.updateDisplayName('${_firstNameController.text.trim()} ${_lastNameController.text.trim()}');
          // -------------------------------------------------

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration successful!')),
          );

          // --- Hide Loading Indicator and Navigate ---
          setState(() {
            _isLoading = false;
          });
          // Navigate after the name update is attempted
          Navigator.pushNamed(context, LoginScreen.routeName);
          // ------------------------------------------

        } else {
           // Should theoretically not happen if createUserWithEmailAndPassword succeeds without throwing
           setState(() {
             _isLoading = false;
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text('Registration failed: User object is null.')),
             );
           });
        }


      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'weak-password') {
          errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'The account already exists for that email.';
        } else {
          errorMessage = 'Registration failed: ${e.message}';
        }

        // --- Hide Loading Indicator and Show Error ---
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
        // -------------------------------------------

      } catch (e) {
        // Handle other potential errors
        // --- Hide Loading Indicator and Show Error ---
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An unexpected error occurred: $e')),
        );
        // -------------------------------------------
      }

    } else {
      // Form validation failed
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields correctly')),
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 15),
                  Text("Hey there,", style: TextStyle(color: AppColors.blackColor, fontSize: 16)),
                  SizedBox(height: 5),
                  Text("Create an Account",
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 20,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700,
                      )),
                  SizedBox(height: 15),
                  RoundTextField(
                    controller: _firstNameController,
                    hintText: "First Name",
                    icon: "assets/icons/profile_icon.png",
                    textInputType: TextInputType.name,
                    // Validator ensures this is not null or empty input
                    validator: (value) => value == null || value.isEmpty ? 'Enter first name' : null,
                  ),
                  SizedBox(height: 15),
                  RoundTextField(
                    controller: _lastNameController,
                    hintText: "Last Name",
                    icon: "assets/icons/profile_icon.png",
                    textInputType: TextInputType.name,
                    // Validator ensures this is not null or empty input
                    validator: (value) => value == null || value.isEmpty ? 'Enter last name' : null,
                  ),
                  SizedBox(height: 15),
                  RoundTextField(
                    controller: _emailController,
                    hintText: "Email",
                    icon: "assets/icons/message_icon.png",
                    textInputType: TextInputType.emailAddress,
                     validator: (value) {
                       if (value == null || value.isEmpty) {
                         return 'Enter email';
                       }
                       if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Enter a valid email address';
                       }
                       return null;
                     },
                  ),
                  SizedBox(height: 15),
                  RoundTextField(
                    controller: _passwordController,
                    hintText: "Password",
                    icon: "assets/icons/lock_icon.png",
                    textInputType: TextInputType.text,
                    isObscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter password';
                      }
                       if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    rightIcon: TextButton(
                      onPressed: () {
                        // TODO: Implement password visibility toggle
                      },
                      child: Image.asset(
                        "assets/icons/hide_pwd_icon.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                        color: AppColors.grayColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () => setState(() => isCheck = !isCheck),
                        icon: Icon(
                          isCheck ? Icons.check_box_outlined : Icons.check_box_outline_blank_outlined,
                          color: AppColors.grayColor,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "By continuing you accept our Privacy Policy and\nTerm of Use",
                          style: TextStyle(color: AppColors.grayColor, fontSize: 10),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  // --- Show loading indicator or button ---
                  _isLoading
                      ? CircularProgressIndicator(color: AppColors.primaryColor1) // Show indicator
                      : RoundGradientButton( // Show button when not loading
                          title: "Register",
                          onPressed: _registerUser,
                        ),
                  // --------------------------------------
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Container(height: 1, color: AppColors.grayColor.withOpacity(0.5)),
                      ),
                      Text("  Or  ",
                          style: TextStyle(
                              color: AppColors.grayColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400)),
                      Expanded(
                        child: Container(height: 1, color: AppColors.grayColor.withOpacity(0.5)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialIcon("assets/icons/google_icon.png"),
                      SizedBox(width: 30),
                      _buildSocialIcon("assets/icons/facebook_icon.png"),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          const TextSpan(text: "Already have an account? "),
                          TextSpan(
                            text: "Login",
                            style: TextStyle(
                              color: AppColors.secondaryColor1,
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String iconPath) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.primaryColor1.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Image.asset(iconPath, width: 20, height: 20),
      ),
    );
  }
}