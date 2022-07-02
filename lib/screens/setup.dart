// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_battle/styles/button_styles.dart';
import 'package:face_battle/styles/colors.dart';
import 'package:face_battle/styles/text_styles.dart';
import 'package:face_battle/widgets/dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String mySex = "Male";
  String wantToCompare = "Female";
  String wantToBeComparedBy = "Female";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: 700,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 240,
                    child: Column(
                      children: [
                        Text(
                          "Setup",
                          style: AppTextStyles.heading1,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "You can change this later",
                          textAlign: TextAlign.center,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textLighter,
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 310,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "My sex is",
                              style: AppTextStyles.heading3,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Dropdown(
                              items: [
                                "Male",
                                "Female",
                              ],
                              onChange: (value) {
                                setState(() {
                                  mySex = value!;
                                });
                              },
                              value: mySex,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: 310,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "I want to compare",
                              style: AppTextStyles.heading3,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Dropdown(
                              items: [
                                "Male",
                                "Female",
                                "Both",
                              ],
                              onChange: (value) {
                                setState(() {
                                  wantToCompare = value!;
                                });
                              },
                              value: wantToCompare,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: 310,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "I want to be compared by",
                              style: AppTextStyles.heading3,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Dropdown(
                              items: [
                                "Male",
                                "Female",
                                "Both",
                              ],
                              onChange: (value) {
                                setState(() {
                                  wantToBeComparedBy = value!;
                                });
                              },
                              value: wantToBeComparedBy,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 310,
                    child: ElevatedButton(
                      onPressed: () {
                        _db.collection('users').doc(_auth.currentUser!.uid).set(
                          {
                            "uid": _auth.currentUser!.uid,
                            "sex": mySex,
                            "wantToCompare": wantToCompare,
                            "wantToBeComparedBy": wantToBeComparedBy,
                            "image": "",
                            "shows": 0,
                            "chosen": 0,
                            "nice": 0,
                          },
                        ).onError(
                            (e, _) => print("Error writing document: $e"));
                      },
                      style: AppButtonStyles.primary,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FaIcon(
                              FontAwesomeIcons.rocket,
                              color: AppColors.text,
                              size: 24,
                            ),
                          ),
                          Text(
                            "Let's go!",
                            style: AppTextStyles.button
                                .copyWith(color: AppColors.text),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
