import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/view/your_goal/your_goal_screen.dart';
import '../../common_widgets/round_gradient_button.dart';
import '../../common_widgets/round_textfield.dart';

class CompleteProfileScreen extends StatefulWidget {
  static String routeName = "/CompleteProfileScreen";
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String? selectedGender;
  bool _isLoading = false;

  @override
  void dispose() {
    dobController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  void _onNextTapped() async {
    final formValid = _formKey.currentState?.validate() ?? false;

    if (selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please choose a gender')),
      );
      return;
    }

    if (!formValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User not logged in')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final String height = heightController.text.trim();
      final String weight = weightController.text.trim();
      final String dob = dobController.text.trim();
      final String gender = selectedGender!;

      Map<String, dynamic> profileData = {
        'gender': gender,
        'date_of_birth': dob,
        'weight': weight,
        'height': height,
        'created_at': FieldValue.serverTimestamp(),
      };

      DocumentReference userProfileDocRef = FirebaseFirestore.instance
          .collection('user_profiles')
          .doc(user.uid);

      await userProfileDocRef.set(profileData, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile data saved successfully!')),
      );

      // Navigate to the YourGoalScreen after saving profile data
      Navigator.pushReplacementNamed(context, YourGoalScreen.routeName);

    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error saving profile data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication Error: ${e.message}')),
      );
    } catch (e) {
      print("Error saving profile data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile data: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  "assets/images/complete_profile.png",
                  width: media.width,
                ),
                const SizedBox(height: 15),
                const Text(
                  "Let’s complete your profile",
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "It will help us to know more about you!",
                  style: TextStyle(
                    color: AppColors.grayColor,
                    fontSize: 12,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGrayColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Image.asset(
                          "assets/icons/gender_icon.png",
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          color: AppColors.grayColor,
                        ),
                      ),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedGender,
                            items: ["Male", "Female"].map((gender) {
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(
                                  gender,
                                  style: const TextStyle(
                                    color: AppColors.grayColor,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedGender = value;
                              });
                            },
                            isExpanded: true,
                            hint: const Text(
                              "Choose Gender",
                              style: TextStyle(
                                color: AppColors.grayColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                RoundTextField(
                  controller: dobController,
                  hintText: "Date of Birth",
                  icon: "assets/icons/calendar_icon.png",
                  textInputType: TextInputType.text,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter your DOB' : null,
                ),
                const SizedBox(height: 15),
                RoundTextField(
                  controller: weightController,
                  hintText: "Your Weight",
                  icon: "assets/icons/weight_icon.png",
                  textInputType: TextInputType.number,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter your weight' : null,
                ),
                const SizedBox(height: 15),
                RoundTextField(
                  controller: heightController,
                  hintText: "Your Height",
                  icon: "assets/icons/swap_icon.png",
                  textInputType: TextInputType.number,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter your height' : null,
                ),
                const SizedBox(height: 25),
                _isLoading
                    ? CircularProgressIndicator(color: AppColors.primaryColor1)
                    : RoundGradientButton(
                        title: "Next >",
                        onPressed: _onNextTapped,
                      ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
