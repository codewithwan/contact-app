import 'package:contact/const/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:contact/models/contact.dart';
import 'package:contact/providers/contact_provider.dart';
import 'package:contact/components/custom_text_form_field.dart';
import 'package:contact/components/custom_switch_list_tile.dart';
import 'package:flutter/services.dart';

class EditContactScreen extends StatefulWidget {
  final Contact contact;

  EditContactScreen({super.key, required this.contact});

  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _phone;
  late String _email;
  late String _organization;
  late bool _isFavorite;
  bool _isEditing = false;
  late Contact _updatedContact;

  @override
  void initState() {
    super.initState();
    _name = widget.contact.name;
    _phone = widget.contact.phone;
    _email = widget.contact.email ?? '';
    _organization = widget.contact.organization ?? '';
    _isFavorite = widget.contact.isFavorite;
    _updatedContact = widget.contact;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(HugeIcons.strokeRoundedArrowLeft01, size: 30),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 70,
        title: const Text(
          'Detail Kontak',
          style: TextStyle(
            fontFamily: inter,
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: _isEditing ? _buildEditForm() : _buildContactDetails(),
    );
  }

  Widget _buildContactDetails() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Text(
                    widget.contact.name.isNotEmpty
                        ? widget.contact.name[0].toUpperCase()
                        : '',
                    style: const TextStyle(
                      fontFamily: inter,
                      fontSize: 40,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _updatedContact.name,
                        style: const TextStyle(
                          fontFamily: inter,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (_updatedContact.phone.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          _updatedContact.phone,
                          style: const TextStyle(
                            fontFamily: inter,
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                      if (_updatedContact.email != null &&
                          _updatedContact.email!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          _updatedContact.email!,
                          style: const TextStyle(
                            fontFamily: inter,
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                      if (_updatedContact.organization != null &&
                          _updatedContact.organization!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          _updatedContact.organization!,
                          style: const TextStyle(
                            fontFamily: inter,
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(HugeIcons.strokeRoundedUserAccount,
                color: Colors.black87),
            title: const Text(
              'Perbarui Kontak',
              style: TextStyle(fontFamily: inter, fontSize: 16),
            ),
            onTap: () {
              setState(() {
                _isEditing = true;
              });
            },
          ),
          ListTile(
            leading:
                const Icon(HugeIcons.strokeRoundedCall, color: Colors.black87),
            title: const Text(
              'Hubungi Telepon',
              style: TextStyle(fontFamily: inter, fontSize: 16),
            ),
            onTap: () {
              // Handle call action
            },
          ),
          ListTile(
            leading: const Icon(HugeIcons.strokeRoundedMail01,
                color: Colors.black87),
            title: const Text(
              'Hubungi Email',
              style: TextStyle(fontFamily: inter, fontSize: 16),
            ),
            onTap: () {
              // Handle email action
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Nama',
                style: TextStyle(
                  fontFamily: inter,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              initialValue: _name,
              onSaved: (value) {
                _name = value!;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Nomor HP',
                style: TextStyle(
                  fontFamily: inter,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              initialValue: _phone,
              onSaved: (value) {
                _phone = value!;
              },
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
              initialValue: _email,
              onSaved: (value) {
                _email = value!;
              },
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Instansi',
                style: TextStyle(
                  fontFamily: inter,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              initialValue: _organization,
              onSaved: (value) {
                _organization = value!;
              },
            ),
            const SizedBox(height: 16),
            CustomSwitchListTile(
              title: 'Favorit',
              value: _isFavorite,
              onChanged: (bool value) {
                setState(() {
                  _isFavorite = value;
                });
              },
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1,
              height: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final contact = Contact(
                        id: widget.contact.id,
                        name: _name,
                        phone: _phone,
                        email: _email,
                        organization: _organization,
                        isFavorite: _isFavorite,
                      );
                      Provider.of<ContactProvider>(context, listen: false)
                          .updateContact(contact);
                      setState(() {
                        _updatedContact = contact;
                        _isEditing = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 15.0,
                    ),
                  ),
                  child: const Text('Perbarui',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: inter,
                          color: Colors.white)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isEditing = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 15.0,
                    ),
                  ),
                  child: const Text('Batal',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: inter,
                          color: Colors.white)),
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
