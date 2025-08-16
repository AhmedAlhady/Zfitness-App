import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/view/activity_tracker/activity_tracker_screen.dart';
import 'package:flutter_application_1/view/dashboard/dashboard_screen.dart';
import 'package:flutter_application_1/view/finish_workout/finish_workout_screen.dart';
import 'package:flutter_application_1/view/login/login_screen.dart';
import 'package:flutter_application_1/view/notification/notification_screen.dart';
import 'package:flutter_application_1/view/on_boarding/on_boarding_screen.dart';
import 'package:flutter_application_1/view/on_boarding/start_screen.dart';
import 'package:flutter_application_1/view/profile/complete_profile_screen.dart';
import 'package:flutter_application_1/view/signup/signup_screen.dart';
import 'package:flutter_application_1/view/welcome/welcome_screen.dart';
import 'package:flutter_application_1/view/workour_detail_view/workour_detail_view.dart';
import 'package:flutter_application_1/view/workout_schedule_view/workout_schedule_view.dart';
import 'package:flutter_application_1/view/your_goal/your_goal_screen.dart';

final Map<String, WidgetBuilder> routes = {
  OnBoardingScreen.routeName: (context) => const OnBoardingScreen(),
  LoginScreen.routeName: (context) => const LoginScreen(),
  StartScreen.routeName: (context) => const StartScreen(),
  SignupScreen.routeName: (context) => const SignupScreen(),
  CompleteProfileScreen.routeName: (context) => const CompleteProfileScreen(),
  YourGoalScreen.routeName: (context) => const YourGoalScreen(),
  WelcomeScreen.routeName: (context) => const WelcomeScreen(),
  DashboardScreen.routeName: (context) => const DashboardScreen(),
  FinishWorkoutScreen.routeName: (context) => const FinishWorkoutScreen(),
  NotificationScreen.routeName: (context) => const NotificationScreen(),
  ActivityTrackerScreen.routeName: (context) => const ActivityTrackerScreen(),
  WorkoutScheduleView.routeName: (context) => const WorkoutScheduleView(),
};
