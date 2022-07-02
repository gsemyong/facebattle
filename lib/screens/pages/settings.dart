// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_battle/styles/button_styles.dart';
import 'package:face_battle/styles/colors.dart';
import 'package:face_battle/styles/radii.dart';
import 'package:face_battle/styles/text_styles.dart';
import 'package:face_battle/widgets/dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? mySex;
  String? wantToCompare;
  String? wantToBeComparedBy;

  String? mySexRemote;
  String? wantToCompareRemote;
  String? wantToBeComparedByRemote;

  bool equalsRemote() {
    return (mySex == mySexRemote &&
        wantToCompare == wantToCompareRemote &&
        wantToBeComparedBy == wantToBeComparedByRemote);
  }

  @override
  void initState() {
    _db.collection('users').doc(_auth.currentUser!.uid).get().then((snapshot) {
      final Map<String, dynamic> user = snapshot.data()!;

      setState(() {
        mySex = user["sex"];
        wantToCompare = user["wantToCompare"];
        wantToBeComparedBy = user["wantToBeComparedBy"];

        mySexRemote = user["sex"];
        wantToCompareRemote = user["wantToCompare"];
        wantToBeComparedByRemote = user["wantToBeComparedBy"];
      });
    });

    _db
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        final Map<String, dynamic> user = snapshot.data()!;

        mySexRemote = user["sex"];
        wantToCompareRemote = user["wantToCompare"];
        wantToBeComparedByRemote = user["wantToBeComparedBy"];
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            height: 700,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
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
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: 310,
                      child: ElevatedButton(
                        onPressed: equalsRemote()
                            ? null
                            : () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: AppRadii.borderRadius,
                                        ),
                                        actionsAlignment:
                                            MainAxisAlignment.center,
                                        title: Text(
                                          "Are you sure?",
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.heading2,
                                        ),
                                        content: Text(
                                          "Your current stats will be deleted",
                                          textAlign: TextAlign.center,
                                          style: AppTextStyles.body.copyWith(
                                            color: AppColors.textLighter,
                                          ),
                                        ),
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _db
                                                  .collection('users')
                                                  .doc(_auth.currentUser!.uid)
                                                  .set(
                                                {
                                                  "sex": mySex,
                                                  "wantToCompare":
                                                      wantToCompare,
                                                  "wantToBeComparedBy":
                                                      wantToBeComparedBy,
                                                  "nice": 0,
                                                  "shows": 0,
                                                  "chosen": 0,
                                                },
                                                SetOptions(merge: true),
                                              );
                                            },
                                            style: AppButtonStyles.danger,
                                            child: Text(
                                              "Yes",
                                              style: AppTextStyles.button
                                                  .copyWith(
                                                      color: AppColors.text),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            style: AppButtonStyles.primary,
                                            child: Text(
                                              "No",
                                              style: AppTextStyles.button
                                                  .copyWith(
                                                      color: AppColors.text),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                        style: AppButtonStyles.primary,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FaIcon(
                                FontAwesomeIcons.floppyDisk,
                                color: AppColors.text,
                                size: 24,
                              ),
                            ),
                            Text(
                              "Save Settings",
                              style: AppTextStyles.button
                                  .copyWith(color: AppColors.text),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: 310,
                      child: ElevatedButton(
                        onPressed: () {
                          FirebaseAuth.instance.signOut();
                        },
                        style: AppButtonStyles.danger,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: FaIcon(
                                FontAwesomeIcons.arrowRightFromBracket,
                                color: AppColors.text,
                                size: 24,
                              ),
                            ),
                            Text(
                              "Sign Out",
                              style: AppTextStyles.button
                                  .copyWith(color: AppColors.text),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
