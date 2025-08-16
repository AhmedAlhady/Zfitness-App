import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/view/profile/complete_profile_screen.dart';
import 'package:flutter_application_1/view/profile/widgets/setting_row.dart';
import 'package:flutter_application_1/view/profile/widgets/title_subtitle_cell.dart';
import 'package:flutter/material.dart';
// Import Firebase Auth
import 'package:firebase_auth/firebase_auth.dart';
// Import Cloud Firestore
import 'package:cloud_firestore/cloud_firestore.dart';
// Import dart:async for FutureBuilder
import 'dart:async';
// Import dart:math for age calculation (optional, can use DateTime)
// import 'dart:math';
// Import intl for date parsing (if DOB is saved as String)
import 'package:intl/intl.dart';

import '../../common_widgets/round_button.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  bool positive = false;

  // State variables to hold fetched user data
  String _userName = "User";
  String _userHeight = "--"; // Default or loading state
  String _userWeight = "--"; // Default or loading state
  String _userAge = "--";    // Default or loading state
  // Added state variable to indicate if data is loading
  bool _isLoadingData = true;

  @override
  void initState() {
    super.initState();
    // Fetch user data when the screen initializes
    _loadUserProfileData();
  }

  // Function to fetch user data from Firebase Auth and Firestore
  void _loadUserProfileData() async {
    // Set loading state to true
    setState(() {
      _isLoadingData = true;
    });

    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // --- Fetch User Name from Firebase Auth ---
      // Use displayName (set during signup) or fallback to email/default
      final String userName = user.displayName ?? user.email ?? "User";
      // ------------------------------------------

      // --- Fetch Profile Data from Firestore ---
      try {
        // Get Firestore instance
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Get the user's profile document using their UID
        DocumentSnapshot userProfileDoc = await firestore.collection('user_profiles').doc(user.uid).get();

        // Check if the document exists and contains data
        if (userProfileDoc.exists && userProfileDoc.data() != null) {
          // Cast data to a Map
          Map<String, dynamic> data = userProfileDoc.data() as Map<String, dynamic>;

          // Extract data, providing default values if fields are missing
          final String height = data['height']?.toString() ?? "--"; // Use toString() in case it's a number
          final String weight = data['weight']?.toString() ?? "--"; // Use toString() in case it's a number
          final String dobString = data['date_of_birth']?.toString() ?? ""; // Get DOB as string

          // Calculate Age from Date of Birth string
          String age = "--"; // Default age
          if (dobString.isNotEmpty) {
            try {
              // Assuming DOB was saved as a simple string like "MM/DD/YYYY" or "YYYY-MM-DD"
              DateTime dob = DateTime.parse(dobString); // Assumes ISO 8601 format (YYYY-MM-DD) if no specific format used

              DateTime today = DateTime.now();
              int calculatedAge = today.year - dob.year;
              // Adjust age if the birthday hasn't occurred yet this year
              if (today.month < dob.month || (today.month == dob.month && today.day < dob.day)) {
                calculatedAge--;
              }
              age = calculatedAge.toString() + "yo"; // Format as "Xyo"
            } catch (e) {
              print("Error parsing DOB or calculating age: $e");
              age = "--"; // Show default if parsing fails
            }
          }

          // Update the state variables with fetched data
          setState(() {
            _userName = userName;
            _userHeight = height + "cm"; // Add unit
            _userWeight = weight + "kg"; // Add unit
            _userAge = age;
            _isLoadingData = false; // Data loaded
          });

        } else {
          // Document doesn't exist or is empty (user hasn't completed profile yet)
          print("User profile document not found in Firestore.");
          setState(() {
            _userName = userName; // Still display the name from Auth
            _userHeight = "--";
            _userWeight = "--";
            _userAge = "--";
            _isLoadingData = false; // Loading finished, but no data found
          });
        }

      } catch (e) {
        // Handle errors during Firestore data fetching
        print("Error fetching user profile data from Firestore: $e");
        setState(() {
          _userName = userName; // Still display the name from Auth
          _userHeight = "Error";
          _userWeight = "Error";
          _userAge = "Error";
          _isLoadingData = false; // Loading finished with error
        });
      }
    } else {
      // User is not logged in
      print("User not logged in on Profile Screen.");
      setState(() {
        _userName = "Guest"; // Display a guest name
        _userHeight = "--";
        _userWeight = "--";
        _userAge = "--";
        _isLoadingData = false; // Loading finished, user not logged in
      });
    }
  }

  List accountArr = [
    {
      "image": "assets/icons/p_personal.png",
      "name": "Personal Data",
      "tag": "1",
    },
    {"image": "assets/icons/p_achi.png", "name": "Achievement", "tag": "2"},
    {
      "image": "assets/icons/p_activity.png",
      "name": "Activity History",
      "tag": "3",
    },
    {
      "image": "assets/icons/p_workout.png",
      "name": "Workout Progress",
      "tag": "4",
    },
  ];

  List otherArr = [
    {"image": "assets/icons/p_contact.png", "name": "Contact Us", "tag": "5"},
    {
      "image": "assets/icons/p_privacy.png",
      "name": "Privacy Policy",
      "tag": "6",
    },
    {"image": "assets/icons/p_setting.png", "name": "Setting", "tag": "7"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(
            color: AppColors.blackColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/more");
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.lightGrayColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                "assets/icons/more_icon.png",
                width: 12,
                height: 12,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      body: _isLoadingData // Show loading indicator if data is loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView( // Show content once data is loaded
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            "assets/images/user.png", // Keep static user image for now
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // Display the fetched user name
                                _userName,
                                style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Text( // This text remains static
                                "Your Program",
                                style: TextStyle(
                                  color: AppColors.grayColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 70,
                          height: 25,
                          child: RoundButton(
                            title: "Edit",
                            type: RoundButtonType.primaryBG,
                            onPressed: () {
                              // Navigate to the Complete Profile screen for editing
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => CompleteProfileScreen()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TitleSubtitleCell(
                            // Display fetched Height
                            title: _userHeight,
                            subtitle: "Height",
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TitleSubtitleCell(
                            // Display fetched Weight
                            title: _userWeight,
                            subtitle: "Weight",
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: TitleSubtitleCell(
                            // Display fetched Age
                            title: _userAge,
                            subtitle: "Age",
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 2),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Account",
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: accountArr.length,
                            itemBuilder: (context, index) {
                              var iObj = accountArr[index];
                              return SettingRow(
                                icon: iObj["image"].toString(),
                                title: iObj["name"].toString(),
                                onPressed: () {
                                  print("Tapped on: ${iObj["name"]}");
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(color: Colors.black12, blurRadius: 2),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Other",
                            style: TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: otherArr.length,
                            itemBuilder: (context, index) {
                              var iObj = otherArr[index];
                              return SettingRow(
                                icon: iObj["image"].toString(),
                                title: iObj["name"].toString(),
                                onPressed: () {
                                  print("Tapped on: ${iObj["name"]}");
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
