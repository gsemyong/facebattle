// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:face_battle/styles/colors.dart';
import 'package:face_battle/styles/radii.dart';
import 'package:face_battle/styles/text_styles.dart';
import 'package:flutter/material.dart';

class Dropdown extends StatelessWidget {
  const Dropdown({
    Key? key,
    required this.onChange,
    required this.value,
    required this.items,
  }) : super(key: key);

  final void Function(String?)? onChange;
  final String? value;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        dropdownDecoration: BoxDecoration(
          borderRadius: AppRadii.borderRadius,
        ),
        buttonDecoration: BoxDecoration(
          borderRadius: AppRadii.borderRadius,
          border: Border.all(
            color: AppColors.textLighter,
          ),
        ),
        isExpanded: true,
        value: value,
        onChanged: onChange,
        items: items.map((item) {
          return DropdownMenuItem(
            alignment: Alignment.center,
            value: item,
            child: Text(
              item,
              style: AppTextStyles.body,
            ),
          );
        }).toList(),
      ),
    );
  }
}
