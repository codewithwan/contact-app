import 'package:contact/const/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                      _name.isNotEmpty ? _name[0].toUpperCase() : '',
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
                          _name,
                          style: const TextStyle(
                            fontFamily: inter,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        if (_phone.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            _phone,
                            style: const TextStyle(
                              fontFamily: inter,
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                        if (_email.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            _email,
                            style: const TextStyle(
                              fontFamily: inter,
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                        if (_organization.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            _organization,
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
            if (!_isEditing) ...[
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(HugeIcons.strokeRoundedUserAccount,
                    color: Colors.black87),
                title: const Text(
                  'Perbarui Profil',
                  style: TextStyle(fontFamily: inter, fontSize: 16),
                ),
                onTap: () {
                  setState(() {
                    _isEditing = true;
                  });
                },
              ),
              ListTile(
                leading: const Icon(HugeIcons.strokeRoundedSettings01,
                    color: Colors.black87),
                title: const Text(
                  'Pengaturan',
                  style: TextStyle(fontFamily: inter, fontSize: 16),
                ),
                onTap: () {
                  // Handle settings button press
                },
              ),
              ListTile(
                leading: const Icon(HugeIcons.strokeRoundedQrCode,
                    color: Colors.black87),
                title: const Text(
                  'Tampilkan QR saya',
                  style: TextStyle(fontFamily: inter, fontSize: 16),
                ),
                onTap: () {
                  // Handle show QR button press
                },
              ),
            ],
            if (_isEditing)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
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
                      TextFormField(
                        initialValue: _name,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 20.0),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: primaryColor),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black87),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _name = value;
                          });
                        },
                        onSaved: (value) {
                          _name = value!;
                        },
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
                      TextFormField(
                        initialValue: _phone,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 20.0),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: primaryColor),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black87),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _phone = value;
                          });
                        },
                        onSaved: (value) {
                          _phone = value!;
                        },
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
                      TextFormField(
                        initialValue: _email,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 20.0),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: primaryColor),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black87),
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
                        onSaved: (value) {
                          _email = value!;
                        },
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
                      TextFormField(
                        initialValue: _organization,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 20.0),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: const BorderSide(color: primaryColor),
                          ),
                        ),
                        style: const TextStyle(color: Colors.black87),
                        onChanged: (value) {
                          setState(() {
                            _organization = value;
                          });
                        },
                        onSaved: (value) {
                          _organization = value!;
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
                                _saveProfile();
                                setState(() {
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
                            child: const Text('Simpan',
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
