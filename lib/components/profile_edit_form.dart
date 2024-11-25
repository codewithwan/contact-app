import 'package:flutter/material.dart';
import 'package:contact/const/app_constant.dart';
import 'package:flutter/services.dart';
import 'widgets/custom_text_form_field.dart';
import 'widgets/custom_button.dart';

class ProfileEditForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String name;
  final String phone;
  final String email;
  final String organization;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onPhoneChanged;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onOrganizationChanged;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const ProfileEditForm({
    Key? key,
    required this.formKey,
    required this.name,
    required this.phone,
    required this.email,
    required this.organization,
    required this.onNameChanged,
    required this.onPhoneChanged,
    required this.onEmailChanged,
    required this.onOrganizationChanged,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Name',
                style: TextStyle(
                  fontFamily: inter,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              initialValue: name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onChanged: onNameChanged,
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Phone',
                style: TextStyle(
                  fontFamily: inter,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              initialValue: phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                }
                final digitsOnly = value.replaceAll('-', '');
                if (digitsOnly.length < 9 || digitsOnly.length > 13) {
                  return 'Phone number must be between 9 and 13 digits';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _PhoneNumberFormatter(),
              ],
              onChanged: onPhoneChanged,
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Email',
                style: TextStyle(
                  fontFamily: inter,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              initialValue: email,
              onChanged: onEmailChanged,
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Organization',
                style: TextStyle(
                  fontFamily: inter,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              initialValue: organization,
              onChanged: onOrganizationChanged,
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomButton(
                  onPressed: onSave,
                  text: 'Simpan',
                  color: primaryColor,
                ),
                const SizedBox(width: 16),
                CustomButton(
                  onPressed: onCancel,
                  text: 'Batal',
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write('-');
      }
    }
    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
