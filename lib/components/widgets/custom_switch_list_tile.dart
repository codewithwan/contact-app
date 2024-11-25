import 'package:flutter/material.dart';
import 'package:contact/const/app_constant.dart';

class CustomSwitchListTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitchListTile({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: inter,
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      value: value,
      activeColor: primaryColor,
      onChanged: onChanged,
    );
  }
}
