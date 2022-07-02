// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_battle/styles/button_styles.dart';
import 'package:face_battle/styles/colors.dart';
import 'package:face_battle/styles/radii.dart';
import 'package:face_battle/styles/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _db.collection('users').doc(_auth.currentUser!.uid).snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        final user = snapshot.data!;

        if (user["image"] == "") {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 235,
                  child: Text(
                    "Add photo and get to know how your look compares to others",
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading3.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final storageRef = _storage.ref();
                    final imageRef =
                        storageRef.child('${_auth.currentUser!.uid}.jpg');

                    XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);

                    if (image == null) {
                      return;
                    }

                    imageRef
                        .putData(await image.readAsBytes(),
                            SettableMetadata(contentType: "image/jpg"))
                        .whenComplete(() async {
                      final String imageUrl = await imageRef.getDownloadURL();

                      _db.collection('users').doc(_auth.currentUser!.uid).set(
                          {"image": imageUrl, "shows": 0, "chosen": 0},
                          SetOptions(merge: true));
                    });
                  },
                  style: AppButtonStyles.primary,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FaIcon(
                          FontAwesomeIcons.cameraRetro,
                          color: AppColors.text,
                          size: 24,
                        ),
                      ),
                      Text(
                        "Add photo",
                        style: AppTextStyles.button
                            .copyWith(color: AppColors.text),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 1150) {
              double imageHeight = constraints.maxHeight * 0.9;
              double imageWidth = constraints.maxWidth * 0.5;

              return SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: constraints.maxHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            height: imageHeight,
                            width: imageWidth,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(48),
                              child: Image.network(
                                user["image"],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 310,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Tooltip(
                                  message: "Compare others to get more shows",
                                  preferBelow: false,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Shows",
                                        style: AppTextStyles.heading2,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '${user["shows"]}',
                                        style: AppTextStyles.heading2,
                                      )
                                    ],
                                  ),
                                ),
                                Tooltip(
                                  message: "How often people prefer you",
                                  preferBelow: false,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Pickrate",
                                        style: AppTextStyles.heading2,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '${user["shows"] == 0 ? 0 : ((user["chosen"] / user["shows"]) * 100).floor()}%',
                                        style: AppTextStyles.heading2,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          SizedBox(
                            width: 310,
                            child: Tooltip(
                              preferBelow: false,
                              message:
                                  "Additional features will be available soon",
                              child: ElevatedButton(
                                onPressed: null,
                                style: AppButtonStyles.accent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: FaIcon(
                                        FontAwesomeIcons.star,
                                        color: AppColors.text,
                                        size: 24,
                                      ),
                                    ),
                                    Text(
                                      "See details",
                                      style: AppTextStyles.button.copyWith(
                                        color: AppColors.text,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                          ),
                          SizedBox(
                            width: 310,
                            child: ElevatedButton(
                              style: AppButtonStyles.primary,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: FaIcon(
                                      FontAwesomeIcons.rotate,
                                      color: AppColors.text,
                                      size: 24,
                                    ),
                                  ),
                                  Text(
                                    "Change photo",
                                    style: AppTextStyles.button.copyWith(
                                      color: AppColors.text,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () async {
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
                                            onPressed: () async {
                                              Navigator.pop(context);

                                              final storageRef = _storage.ref();
                                              final imageRef = storageRef.child(
                                                  '${_auth.currentUser!.uid}.jpg');

                                              XFile? image =
                                                  await _picker.pickImage(
                                                      source:
                                                          ImageSource.gallery);

                                              if (image == null) {
                                                return;
                                              }

                                              imageRef
                                                  .putData(
                                                      await image.readAsBytes(),
                                                      SettableMetadata(
                                                          contentType:
                                                              "image/jpg"))
                                                  .whenComplete(() async {
                                                final String imageUrl =
                                                    await imageRef
                                                        .getDownloadURL();

                                                _db
                                                    .collection('users')
                                                    .doc(_auth.currentUser!.uid)
                                                    .set({
                                                  "image": imageUrl,
                                                  "shows": 0,
                                                  "chosen": 0
                                                }, SetOptions(merge: true));
                                              });
                                            },
                                            style:
                                                AppButtonStyles.danger.copyWith(
                                              fixedSize:
                                                  MaterialStateProperty.all(
                                                Size(100, 60),
                                              ),
                                            ),
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
                                            style: AppButtonStyles.primary
                                                .copyWith(
                                              fixedSize:
                                                  MaterialStateProperty.all(
                                                Size(100, 60),
                                              ),
                                            ),
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
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            double imageHeight = constraints.maxHeight * 0.7;
            double imageWidth = min(constraints.maxWidth * 0.9, 550);

            return SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    height: 850,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: imageWidth,
                          height: imageHeight,
                          child: ClipRRect(
                            borderRadius: AppRadii.borderRadius,
                            child:
                                Image.network(user["image"], fit: BoxFit.cover),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 310,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Tooltip(
                                message: "Compare others to get more shows",
                                preferBelow: false,
                                child: Column(
                                  children: [
                                    Text(
                                      "Shows",
                                      style: AppTextStyles.heading2,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${user["shows"]}',
                                      style: AppTextStyles.heading2,
                                    )
                                  ],
                                ),
                              ),
                              Tooltip(
                                message: "How often people prefer you",
                                preferBelow: false,
                                child: Column(
                                  children: [
                                    Text(
                                      "Pickrate",
                                      style: AppTextStyles.heading2,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${user["shows"] == 0 ? 0 : ((user["chosen"] / user["shows"]) * 100).floor()}%',
                                      style: AppTextStyles.heading2,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 310,
                          child: Tooltip(
                            preferBelow: false,
                            message:
                                "Additional features will be available soon",
                            child: ElevatedButton(
                              onPressed: null,
                              style: AppButtonStyles.accent,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: FaIcon(
                                      FontAwesomeIcons.star,
                                      color: AppColors.text,
                                      size: 24,
                                    ),
                                  ),
                                  Text(
                                    "See details",
                                    style: AppTextStyles.button.copyWith(
                                      color: AppColors.text,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: 310,
                          child: ElevatedButton(
                            style: AppButtonStyles.primary,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: FaIcon(
                                    FontAwesomeIcons.rotate,
                                    color: AppColors.text,
                                    size: 24,
                                  ),
                                ),
                                Text(
                                  "Change photo",
                                  style: AppTextStyles.button.copyWith(
                                    color: AppColors.text,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () async {
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
                                          onPressed: () async {
                                            Navigator.pop(context);

                                            final storageRef = _storage.ref();
                                            final imageRef = storageRef.child(
                                                '${_auth.currentUser!.uid}.jpg');

                                            XFile? image =
                                                await _picker.pickImage(
                                                    source:
                                                        ImageSource.gallery);

                                            if (image == null) {
                                              return;
                                            }

                                            imageRef
                                                .putData(
                                                    await image.readAsBytes(),
                                                    SettableMetadata(
                                                        contentType:
                                                            "image/jpg"))
                                                .whenComplete(() async {
                                              final String imageUrl =
                                                  await imageRef
                                                      .getDownloadURL();

                                              _db
                                                  .collection('users')
                                                  .doc(_auth.currentUser!.uid)
                                                  .set({
                                                "image": imageUrl,
                                                "shows": 0,
                                                "chosen": 0
                                              }, SetOptions(merge: true));
                                            });
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
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
