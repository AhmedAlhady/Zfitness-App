import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/view/signup/signup_screen.dart';
import 'package:flutter_application_1/view/profile/complete_profile_screen.dart';
import 'package:flutter_application_1/common_widgets/round_gradient_button.dart';
import 'package:flutter_application_1/common_widgets/round_textfield.dart';
import 'package:flutter_application_1/view/your_goal/your_goal_screen.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/LoginScreen";
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;
  bool _obscurePassword = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void handleLogin() async {
    setState(() {
      errorMessage = null;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Basic empty‐field check
    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "Email and password are required.";
      });
      return;
    }

    print("DEBUG: Attempting login with email: $email");

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        setState(() {
          errorMessage = null;
        });

        final userDoc = await FirebaseFirestore.instance
            .collection('user_profiles')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final data = userDoc.data()!;
          if (data['gender'] != null &&
              data['date_of_birth'] != null &&
              data['weight'] != null &&
              data['height'] != null) {
            Navigator.pushReplacementNamed(context, YourGoalScreen.routeName);
          } else {
            Navigator.pushReplacementNamed(
                context, CompleteProfileScreen.routeName);
          }
        } else {
          Navigator.pushReplacementNamed(
              context, CompleteProfileScreen.routeName);
        }

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Login successful!')));
      }
    } on FirebaseAuthException catch (e) {
      print("DEBUG: FirebaseAuthException code = ${e.code}, message = ${e.message}");
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled.';
          break;
        case 'invalid-credential':
          message = 'The credential is invalid or has expired.';
          break;
        default:
          message = 'Login failed: ${e.message}';
      }
      setState(() {
        errorMessage = message;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'An unexpected error occurred: $e';
      });
    }
  }

  void handleGoogleLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Google login clicked (Not implemented)")),
    );
  }

  void handleFacebookLogin() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Facebook login clicked (Not implemented)")),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            constraints: BoxConstraints(
              minHeight: media.height - MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: media.width * 0.03),
                  const Text(
                    "Hey there,",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: media.width * 0.01),
                  const Text(
                    "Welcome Back",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 20,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: media.width * 0.05),
                  RoundTextField(
                    hintText: "Email",
                    icon: "assets/icons/message_icon.png",
                    controller: emailController,
                    textInputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: media.width * 0.05),
                  RoundTextField(
                    hintText: "Password",
                    icon: "assets/icons/lock_icon.png",
                    controller: passwordController,
                    textInputType: TextInputType.text,
                    isObscureText: _obscurePassword,
                    rightIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.grayColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  const SizedBox(height: 10),
                  const Text(
                    "Forgot your password?",
                    style: TextStyle(color: AppColors.grayColor, fontSize: 10),
                  ),
                  const Spacer(),
                  RoundGradientButton(title: "Login", onPressed: handleLogin),
                  SizedBox(height: media.width * 0.01),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: AppColors.grayColor.withOpacity(0.5),
                        ),
                      ),
                      const Text(
                        "  Or  ",
                        style: TextStyle(
                          color: AppColors.grayColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: AppColors.grayColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: handleGoogleLogin,
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
                          child: Image.asset(
                            "assets/icons/google_icon.png",
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      GestureDetector(
                        onTap: handleFacebookLogin,
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
                          child: Image.asset(
                            "assets/icons/facebook_icon.png",
                            width: 20,
                            height: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SignupScreen.routeName);
                    },
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        children: [
                          const TextSpan(text: "Don’t have an account yet? "),
                          TextSpan(
                            text: "Register",
                            style: TextStyle(
                              color: AppColors.secondaryColor1,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
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
}
