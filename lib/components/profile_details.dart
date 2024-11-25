import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:contact/const/app_constant.dart';
// import 'widgets/custom_list_tile.dart';

class ProfileDetails extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final String organization;
  final bool isEditing;
  final VoidCallback onEdit;

  const ProfileDetails({
    Key? key,
    required this.name,
    required this.phone,
    required this.email,
    required this.organization,
    required this.isEditing,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  name.isNotEmpty ? name[0].toUpperCase() : '',
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
                      name,
                      style: const TextStyle(
                        fontFamily: inter,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (phone.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        _formatPhoneNumber(phone),
                        style: const TextStyle(
                          fontFamily: inter,
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                    if (email.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        email,
                        style: const TextStyle(
                          fontFamily: inter,
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                    if (organization.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        organization,
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
        if (!isEditing) ...[
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(HugeIcons.strokeRoundedUserAccount,
                color: Colors.black87),
            title: const Text('Perbarui Profil',
                style: TextStyle(fontFamily: inter, fontSize: 16)),
            onTap: onEdit,
          ),
          ListTile(
            leading: const Icon(HugeIcons.strokeRoundedSettings01,
                color: Colors.black87),
            title: const Text('Pengaturan',
                style: TextStyle(fontFamily: inter, fontSize: 16)),
            onTap: () {
              // Handle settings button press
            },
          ),
          ListTile(
            leading: const Icon(HugeIcons.strokeRoundedQrCode,
                color: Colors.black87),
            title: const Text('Tampilkan QR saya',
                style: TextStyle(fontFamily: inter, fontSize: 16)),
            onTap: () {
              // Handle show QR button press
            },
          ),
        ],
      ],
    );
  }

  String _formatPhoneNumber(String phone) {
    return phone;
  }
}
