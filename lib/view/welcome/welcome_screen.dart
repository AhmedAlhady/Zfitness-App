import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/view/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
// Import the firebase_auth package to access the current user
import 'package:firebase_auth/firebase_auth.dart';

import '../../common_widgets/round_gradient_button.dart';

class WelcomeScreen extends StatelessWidget {
  static String routeName = "/WelcomeScreen";

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    // --- Firebase Auth logic to get the current user ---
    // FirebaseAuth.instance.currentUser provides the currently logged-in user.
    // It will be null if no user is logged in.
    final User? user = FirebaseAuth.instance.currentUser;

    // Get the user's display name.
    // user?.displayName attempts to get the display name (which should be the full name from signup).
    // ?? user?.email provides a fallback to the user's email if display name is null.
    // ?? "User" provides a default fallback text if both display name and email are null.
    final String userName = user?.displayName ?? user?.email ?? "User";
    // ----------------------------------------------------

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          // Consider wrapping the Column in SingleChildScrollView if content might overflow on smaller screens
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                "assets/images/welcome_promo.png",
                width: media.width * 0.75,
                fit: BoxFit.fitWidth,
              ),
              SizedBox(height: media.width * 0.05),
              // --- Modify the Text widget to display the user's name ---
              // Removed 'const' because the text content is now dynamic.
              Text(
                "Welcome, $userName",
                style: const TextStyle( // Keep TextStyle as const if its properties are static
                  color: AppColors.blackColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              // ----------------------------------------------------
              SizedBox(height: media.width * 0.01),
              const Text(
                "You are all set now, let’s reach your\ngoals together with us",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.grayColor,
                  fontSize: 12,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              RoundGradientButton(
                title: "Go To Home",
                onPressed: () {
                  Navigator.pushNamed(context, DashboardScreen.routeName);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}