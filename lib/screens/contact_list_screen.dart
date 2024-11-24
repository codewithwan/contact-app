import 'package:contact/const/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:contact/providers/contact_provider.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final Set<int> _selectedContacts = {};
  bool _isSearching = false;
  String _searchQuery = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<ContactProvider>(context, listen: false).loadContacts();
  }

  void _toggleSelection(int contactId) {
    setState(() {
      if (_selectedContacts.contains(contactId)) {
        _selectedContacts.remove(contactId);
      } else {
        _selectedContacts.add(contactId);
      }
    });
  }

  void _confirmDelete(BuildContext context, ContactProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(
            'Are you sure you want to delete ${_selectedContacts.length} contact(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              for (var contactId in _selectedContacts) {
                provider.deleteContact(contactId);
              }
              setState(() {
                _selectedContacts.clear();
              });
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.of(context)
          .pushReplacementNamed('/profile', arguments: {'noTransition': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          toolbarHeight: 70,
          title: _isSearching
              ? TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                    hintStyle: const TextStyle(
                        color: Colors.black54, fontFamily: inter),
                    // ignore: prefer_const_constructors
                    prefixIcon: HugeIcon(
                        icon: HugeIcons.strokeRoundedSearch01,
                        color: Colors.black),
                  ),
                  style:
                      const TextStyle(color: Colors.black, fontFamily: inter),
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                )
              : const Text(
                  'FullContact',
                  style: TextStyle(
                    fontFamily: inter,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0,
                  ),
                ),
          actions: [
            if (_selectedContacts.isNotEmpty)
              IconButton(
                icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedDelete01, color: Colors.black),
                onPressed: () => _confirmDelete(context,
                    Provider.of<ContactProvider>(context, listen: false)),
              ),
            IconButton(
              icon: Icon(
                _isSearching ? Icons.close : HugeIcons.strokeRoundedSearch01,
                color: Colors.black,
                size: 24.0,
              ),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchQuery = '';
                  }
                });
              },
            ),
          ],
          backgroundColor: primaryColor,
          bottom: const TabBar(
            labelStyle: TextStyle(fontFamily: inter, fontSize: 16.0),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: 'Semua Kontak'),
              Tab(text: 'Favorit'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Consumer<ContactProvider>(
              builder: (context, provider, child) {
                final contacts = provider.contacts
                    .where((contact) => contact.name
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()))
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
                            style:
                                TextStyle(fontSize: 18, color: Colors.black54)),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    final isSelected = _selectedContacts.contains(contact.id);
                    final previousContact =
                        index > 0 ? contacts[index - 1] : null;
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
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 16.0),
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
                                  fontWeight: FontWeight.bold,
                                  fontFamily: inter),
                            ),
                            subtitle: Text(contact.phone,
                                style: const TextStyle(fontFamily: inter)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    size: 30.0,
                                    contact.isFavorite
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: contact.isFavorite
                                        ? primaryColor
                                        : null,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      contact.isFavorite = !contact.isFavorite;
                                    });
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
                              if (_selectedContacts.isEmpty) {
                                Navigator.of(context).pushNamed('/edit_contact',
                                    arguments: {
                                      'contact': contact,
                                      'noTransition': true
                                    });
                              } else {
                                _toggleSelection(contact.id!);
                              }
                            },
                            onLongPress: () => _toggleSelection(contact.id!),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Consumer<ContactProvider>(
              builder: (context, provider, child) {
                final favoriteContacts = provider.contacts
                    .where((contact) => contact.isFavorite)
                    .where((contact) => contact.name
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()))
                    .toList();
                if (favoriteContacts.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage(notFound),
                          width: 250,
                          height: 250,
                        ),
                        Text('Masih kosong nih..',
                            style: TextStyle(
                                fontFamily: inter,
                                fontSize: 27,
                                color: Colors.black54)),
                        Text(
                          'Belum ada yang istimewa ya',
                          style: TextStyle(
                              fontFamily: inter,
                              fontSize: 18,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: favoriteContacts.length,
                  itemBuilder: (context, index) {
                    final contact = favoriteContacts[index];
                    final isSelected = _selectedContacts.contains(contact.id);
                    return Container(
                      color: isSelected ? Colors.grey[300] : Colors.white,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 16.0),
                        leading: const CircleAvatar(
                          radius: 25,
                          backgroundColor: primaryColor,
                          child: HugeIcon(
                              icon: HugeIcons.strokeRoundedUser,
                              color: Colors.white60,
                              size: 30.0),
                        ),
                        title: Text(
                          contact.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontFamily: inter),
                        ),
                        subtitle: Text(contact.phone),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                size: 30.0,
                                contact.isFavorite
                                    ? Icons.star
                                    : Icons.star_border,
                                color: contact.isFavorite ? primaryColor : null,
                              ),
                              onPressed: () {
                                setState(() {
                                  contact.isFavorite = !contact.isFavorite;
                                });
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
                          if (_selectedContacts.isEmpty) {
                            Navigator.of(context).pushNamed('/edit_contact',
                                arguments: {
                                  'contact': contact,
                                  'noTransition': true
                                });
                          } else {
                            _toggleSelection(contact.id!);
                          }
                        },
                        onLongPress: () => _toggleSelection(contact.id!),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: () {
            Navigator.of(context)
                .pushNamed('/add_contact', arguments: {'noTransition': true});
          },
          backgroundColor: primaryColor,
          child: const HugeIcon(
            icon: HugeIcons.strokeRoundedAdd01,
            color: Colors.white,
            size: 35,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0), // Add margin
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
              height: 80,
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
                                : Colors.black,
                          ),
                          Text(
                            'Daftar kontak',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: inter,
                              fontSize: 15,
                              color: _selectedIndex == 0
                                  ? primaryColor
                                  : Colors.black,
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
                            'Profile',
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
      ),
    );
  }
}
