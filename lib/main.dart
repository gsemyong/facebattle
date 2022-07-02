// ignore_for_file: prefer_const_constructors

import 'package:face_battle/auth_gate.dart';
import 'package:face_battle/firebase_options.dart';
import 'package:face_battle/styles/button_styles.dart';
import 'package:face_battle/styles/colors.dart';
import 'package:face_battle/styles/radii.dart';
import 'package:face_battle/styles/text_styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FaceBattle",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.all(20),
          border: OutlineInputBorder(
            borderRadius: AppRadii.borderRadius,
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: AppButtonStyles.outlined,
        ),
        textButtonTheme: TextButtonThemeData(
          style: AppButtonStyles.text,
        ),
        textTheme: TextTheme(
          subtitle1: AppTextStyles.body,
          caption: AppTextStyles.body,
          button: AppTextStyles.body,
          bodyText2: AppTextStyles.body,
          headline5: AppTextStyles.heading1,
        ),
        tooltipTheme: TooltipThemeData(
          textStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        navigationRailTheme: NavigationRailThemeData(
          minWidth: 100,
          selectedLabelTextStyle: AppTextStyles.body.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: MaterialStateProperty.all(
            AppTextStyles.body.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        useMaterial3: true,
        colorSchemeSeed: AppColors.primary,
        fontFamily: "Zilla Slab",
      ),
      home: AuthGate(),
    );
  }
}
