// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_battle/screens/app_skeleton.dart';
import 'package:face_battle/screens/setup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'package:flutterfire_ui/auth.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      initialData: FirebaseAuth.instance.currentUser,
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        developer.log(snapshot.toString());

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }

        if (!snapshot.hasData) {
          return SignInScreen(
            providerConfigs: [
              EmailProviderConfiguration(),
            ],
          );
        }

        final user = snapshot.data!;

        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _db.collection('users').doc(user.uid).snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final user = snapshot.data!;

            if (!user.exists) {
              return SetupScreen();
            }

            return AppSkeleton();
          }),
        );
      },
    );
  }
}
