// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:face_battle/styles/colors.dart';

import 'pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppSkeleton extends StatefulWidget {
  const AppSkeleton({Key? key}) : super(key: key);

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1300) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  labelType: NavigationRailLabelType.selected,
                  onDestinationSelected: (index) => setState(() {
                    _selectedPage = index;
                  }),
                  selectedIndex: _selectedPage,
                  destinations: [
                    NavigationRailDestination(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      label: Text("Dashboard"),
                      icon: FaIcon(FontAwesomeIcons.chartSimple),
                    ),
                    NavigationRailDestination(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      label: Text("Compare"),
                      icon: FaIcon(
                        FontAwesomeIcons.peopleArrowsLeftRight,
                      ),
                    ),
                    NavigationRailDestination(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      label: Text("Settings"),
                      icon: FaIcon(
                        FontAwesomeIcons.gear,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: IndexedStack(
                    index: _selectedPage,
                    children: [
                      DashboardPage(),
                      ComparePage(),
                      SettingsPage(),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          body: IndexedStack(
            index: _selectedPage,
            children: [
              DashboardPage(),
              ComparePage(),
              SettingsPage(),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (value) => setState(() {
              _selectedPage = value;
            }),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            selectedIndex: _selectedPage,
            destinations: [
              NavigationDestination(
                tooltip: "",
                label: "Dashboard",
                icon: FaIcon(FontAwesomeIcons.chartSimple),
              ),
              NavigationDestination(
                tooltip: "",
                label: "Compare",
                icon: FaIcon(
                  FontAwesomeIcons.peopleArrowsLeftRight,
                ),
              ),
              NavigationDestination(
                tooltip: "",
                label: "Settings",
                icon: FaIcon(
                  FontAwesomeIcons.gear,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
