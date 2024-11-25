import 'package:flutter/material.dart';
import 'package:contact/const/app_constant.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  final String initialValue;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFormField({
    Key? key,
    required this.initialValue,
    this.onSaved,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: primaryColor),
        ),
      ),
      style: const TextStyle(color: Colors.black87),
      validator: validator,
      onSaved: onSaved,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
    );
  }
}
