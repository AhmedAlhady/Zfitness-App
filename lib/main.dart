import 'package:flutter/material.dart';
import 'package:flutter_application_1/routes.dart';
import 'package:flutter_application_1/utils/app_colors.dart';
import 'package:flutter_application_1/view/login/login_screen.dart';
import 'package:flutter_application_1/view/on_boarding/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZFitness',
      debugShowCheckedModeBanner: false,
      initialRoute: StartScreen.routeName,
      routes: routes,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor1,
        useMaterial3: true,
        fontFamily: "Poppins",
      ),
    );
  }
}
