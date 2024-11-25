import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contact/providers/contact_provider.dart';
import 'package:contact/const/app_constant.dart';
import 'package:hugeicons/hugeicons.dart';
import 'widgets/custom_list_tile.dart';

class ContactList extends StatelessWidget {
  final bool isFavorite;
  final String searchQuery;
  final Set<int> selectedContacts;
  final Function(int) toggleSelection;

  const ContactList({
    Key? key,
    required this.isFavorite,
    required this.searchQuery,
    required this.selectedContacts,
    required this.toggleSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactProvider>(
      builder: (context, provider, child) {
        final contacts = provider.contacts
            .where((contact) => !isFavorite || contact.isFavorite)
            .where((contact) =>
                contact.name.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
        if (contacts.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(notFound),
                  width: 250,
                  height: 250,
                ),
                Text(
                  'Belum ada kontak nih',
                  style: TextStyle(fontSize: 27, color: Colors.black54),
                ),
                Text('Tambahkan kontak sekarang.',
                    style: TextStyle(fontSize: 18, color: Colors.black54)),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            final isSelected = selectedContacts.contains(contact.id);
            final previousContact = index > 0 ? contacts[index - 1] : null;
            final isNewGroup = previousContact == null ||
                contact.name[0].toUpperCase() !=
                    previousContact.name[0].toUpperCase();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNewGroup)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      contact.name[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Container(
                  color: isSelected ? Colors.grey[300] : Colors.white,
                  child: CustomListTile(
                    leading: const CircleAvatar(
                        radius: 25,
                        backgroundColor: primaryColor,
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedUser,
                          color: Colors.white60,
                          size: 30.0,
                        )),
                    title: Text(
                      contact.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: inter),
                    ),
                    subtitle: Text(
                      contact.phone,
                      style: const TextStyle(fontFamily: inter),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            size: 30.0,
                            contact.isFavorite ? Icons.star : Icons.star_border,
                            color: contact.isFavorite ? primaryColor : null,
                          ),
                          onPressed: () {
                            contact.isFavorite = !contact.isFavorite;
                            provider.updateContact(contact);
                          },
                        ),
                        if (isSelected)
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedTick02,
                            color: Colors.black,
                            size: 30.0,
                          )
                      ],
                    ),
                    onTap: () {
                      if (selectedContacts.isEmpty) {
                        Navigator.of(context).pushNamed('/edit_contact',
                            arguments: {
                              'contact': contact,
                              'noTransition': true
                            });
                      } else {
                        toggleSelection(contact.id!);
                      }
                    },
                    onLongPress: () => toggleSelection(contact.id!),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
