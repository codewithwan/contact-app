import 'package:contact/const/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:contact/components/profile_details.dart';
import 'package:contact/components/profile_edit_form.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name = '';
  late String _phone = '';
  late String _email = '';
  late String _organization = '';

  int _selectedIndex = 1;
  bool _isEditing = false;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.of(context)
          .pushReplacementNamed('/', arguments: {'noTransition': true});
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('profile_name') ?? '';
      _phone = prefs.getString('profile_phone') ?? '';
      _email = prefs.getString('profile_email') ?? '';
      _organization = prefs.getString('profile_organization') ?? '';
      _isEditing = _name.isEmpty &&
          _phone.isEmpty &&
          _email.isEmpty &&
          _organization.isEmpty;
    });
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', _name);
    await prefs.setString('profile_phone', _phone);
    await prefs.setString('profile_email', _email);
    await prefs.setString('profile_organization', _organization);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text(
          'Profil saya',
          style: TextStyle(
            fontFamily: inter,
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        backgroundColor: primaryColor,
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileDetails(
              name: _name,
              phone: _phone,
              email: _email,
              organization: _organization,
              isEditing: _isEditing,
              onEdit: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
            if (_isEditing)
              ProfileEditForm(
                formKey: _formKey,
                name: _name,
                phone: _phone,
                email: _email,
                organization: _organization,
                onNameChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
                onPhoneChanged: (value) {
                  setState(() {
                    _phone = value;
                  });
                },
                onEmailChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
                onOrganizationChanged: (value) {
                  setState(() {
                    _organization = value;
                  });
                },
                onSave: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _saveProfile();
                    setState(() {
                      _isEditing = false;
                    });
                  }
                },
                onCancel: () {
                  setState(() {
                    _isEditing = false;
                  });
                },
              ),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomAppBar(
            color: Colors.white,
            height: _isEditing ? 0 : 80,
            notchMargin: 8.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Daftar Kontak
                Expanded(
                  child: InkWell(
                    onTap: () => _onItemTapped(0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          HugeIcons.strokeRoundedUserMultiple,
                          size: 30,
                          color: _selectedIndex == 0
                              ? primaryColor
                              : Colors.black54,
                        ),
                        Text(
                          'Daftar kontak',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: inter,
                            fontSize: 15,
                            color: _selectedIndex == 0
                                ? primaryColor
                                : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Tombol Tengah
                const Expanded(
                  child: SizedBox(),
                ),
                // Profile
                Expanded(
                  child: InkWell(
                    onTap: () => _onItemTapped(1),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          HugeIcons.strokeRoundedUser,
                          size: 30,
                          color: _selectedIndex == 1
                              ? primaryColor
                              : Colors.black54,
                        ),
                        Text(
                          'Profil',
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: inter,
                            color: _selectedIndex == 1
                                ? primaryColor
                                : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
