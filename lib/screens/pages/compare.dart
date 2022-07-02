// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_battle/styles/button_styles.dart';
import 'package:face_battle/styles/colors.dart';
import 'package:face_battle/styles/radii.dart';
import 'package:face_battle/styles/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quiver/iterables.dart';

class ComparePage extends StatefulWidget {
  const ComparePage({Key? key}) : super(key: key);

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  List<List<Map<String, dynamic>>>? usersPairs;

  void getUserPairs() {
    _db.collection('users').doc(_auth.currentUser!.uid).get().then(
      (snapshot) {
        final user = snapshot.data()!;

        _db
            .collection('users')
            .where(
              "sex",
              whereIn: user["wantToCompare"] == "Both"
                  ? ["Male", "Female"]
                  : [user["wantToCompare"]],
            )
            .where(
              "wantToBeComparedBy",
              isNotEqualTo: user["sex"] == "Male" ? "Female" : "Male",
            )
            .orderBy("wantToBeComparedBy")
            .orderBy("nice", descending: true)
            .limit(50)
            .get()
            .then((snapshot) {
          List<Map<String, dynamic>> users = snapshot.docs.map(
            (doc) {
              return doc.data();
            },
          ).where(
            (user) {
              return user["uid"] != _auth.currentUser!.uid &&
                  user["image"] != "";
            },
          ).toList();

          print(users);

          if (users.length % 2 != 0) {
            users.removeLast();
          }

          if (users.length < 2) {
            setState(() {
              usersPairs = [];
            });
          }

          users.shuffle();

          setState(() {
            usersPairs = partition(users, 2).toList();
          });
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();

    getUserPairs();
  }

  @override
  Widget build(BuildContext context) {
    if (usersPairs == null) {
      return Container();
    }

    if (usersPairs!.isEmpty) {
      return Center(
        child: SizedBox(
            width: 275,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "There is no one to compare :(",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading2,
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    getUserPairs();
                  },
                  style: AppButtonStyles.primary,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FaIcon(
                          FontAwesomeIcons.arrowsRotate,
                          color: AppColors.text,
                          size: 24,
                        ),
                      ),
                      Text(
                        "Refresh",
                        style: AppTextStyles.button
                            .copyWith(color: AppColors.text),
                      ),
                    ],
                  ),
                )
              ],
            )),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1150) {
          double imageHeight = constraints.maxHeight * 0.9;
          double imageWidth = constraints.maxWidth * 0.5 - 50;

          return SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: constraints.maxHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Bounceable(
                    onTap: () {
                      _db
                          .collection('users')
                          .doc(
                            usersPairs![0][0]["uid"],
                          )
                          .set(
                        {
                          "nice": FieldValue.increment(-5),
                          "shows": FieldValue.increment(1),
                          "chosen": FieldValue.increment(1),
                        },
                        SetOptions(merge: true),
                      );

                      _db
                          .collection('users')
                          .doc(
                            usersPairs![0][1]["uid"],
                          )
                          .set(
                        {
                          "nice": FieldValue.increment(-5),
                          "shows": FieldValue.increment(1),
                        },
                        SetOptions(merge: true),
                      );

                      _db.collection('users').doc(_auth.currentUser!.uid).set(
                        {"nice": FieldValue.increment(1)},
                        SetOptions(merge: true),
                      );

                      setState(() {
                        usersPairs!.removeAt(0);

                        if (usersPairs!.isEmpty) {
                          usersPairs = null;

                          getUserPairs();
                        }
                      });
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: SizedBox(
                        width: imageWidth,
                        height: imageHeight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(36),
                          child: Image.network(
                            usersPairs![0][0]["image"],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Bounceable(
                    onTap: () {
                      _db
                          .collection('users')
                          .doc(
                            usersPairs![0][1]["uid"],
                          )
                          .set(
                        {
                          "nice": FieldValue.increment(-5),
                          "shows": FieldValue.increment(1),
                          "chosen": FieldValue.increment(1),
                        },
                        SetOptions(merge: true),
                      );

                      _db
                          .collection('users')
                          .doc(
                            usersPairs![0][0]["uid"],
                          )
                          .set(
                        {
                          "nice": FieldValue.increment(-5),
                          "shows": FieldValue.increment(1),
                        },
                        SetOptions(merge: true),
                      );

                      _db.collection('users').doc(_auth.currentUser!.uid).set(
                        {"nice": FieldValue.increment(1)},
                        SetOptions(merge: true),
                      );

                      setState(() {
                        usersPairs!.removeAt(0);

                        if (usersPairs!.isEmpty) {
                          usersPairs = null;

                          getUserPairs();
                        }
                      });
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: SizedBox(
                        width: imageWidth,
                        height: imageHeight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(36),
                          child: Image.network(
                            usersPairs![0][1]["image"],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }

        double imageWidth = math.min(constraints.maxWidth * 0.9, 550);
        double imageHeight = constraints.maxHeight * 0.5 - 40;

        return SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Bounceable(
                  onTap: () {
                    _db
                        .collection('users')
                        .doc(
                          usersPairs![0][0]["uid"],
                        )
                        .set(
                      {
                        "nice": FieldValue.increment(-5),
                        "shows": FieldValue.increment(1),
                        "chosen": FieldValue.increment(1),
                      },
                      SetOptions(merge: true),
                    );

                    _db
                        .collection('users')
                        .doc(
                          usersPairs![0][1]["uid"],
                        )
                        .set(
                      {
                        "nice": FieldValue.increment(-5),
                        "shows": FieldValue.increment(1),
                      },
                      SetOptions(merge: true),
                    );

                    _db.collection('users').doc(_auth.currentUser!.uid).set(
                      {"nice": FieldValue.increment(1)},
                      SetOptions(merge: true),
                    );

                    setState(() {
                      usersPairs!.removeAt(0);

                      if (usersPairs!.isEmpty) {
                        usersPairs = null;

                        getUserPairs();
                      }
                    });
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: SizedBox(
                      width: imageWidth,
                      height: imageHeight,
                      child: ClipRRect(
                        borderRadius: AppRadii.borderRadius,
                        child: Image.network(
                          usersPairs![0][0]["image"],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                Bounceable(
                  onTap: () {
                    _db
                        .collection('users')
                        .doc(
                          usersPairs![0][1]["uid"],
                        )
                        .set(
                      {
                        "nice": FieldValue.increment(-5),
                        "shows": FieldValue.increment(1),
                        "chosen": FieldValue.increment(1),
                      },
                      SetOptions(merge: true),
                    );

                    _db
                        .collection('users')
                        .doc(
                          usersPairs![0][0]["uid"],
                        )
                        .set(
                      {
                        "nice": FieldValue.increment(-5),
                        "shows": FieldValue.increment(1),
                      },
                      SetOptions(merge: true),
                    );

                    _db.collection('users').doc(_auth.currentUser!.uid).set(
                      {"nice": FieldValue.increment(1)},
                      SetOptions(merge: true),
                    );

                    setState(() {
                      usersPairs!.removeAt(0);

                      if (usersPairs!.isEmpty) {
                        usersPairs = null;

                        getUserPairs();
                      }
                    });
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: SizedBox(
                      width: imageWidth,
                      height: imageHeight,
                      child: ClipRRect(
                        borderRadius: AppRadii.borderRadius,
                        child: Image.network(
                          usersPairs![0][1]["image"],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
