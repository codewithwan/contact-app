import 'package:contact/const/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:contact/providers/contact_provider.dart';
import 'package:contact/components/contact_list.dart';

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
        resizeToAvoidBottomInset: false,
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
                  'Contactin',
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
            ContactList(
              isFavorite: false,
              searchQuery: _searchQuery,
              selectedContacts: _selectedContacts,
              toggleSelection: _toggleSelection,
            ),
            ContactList(
              isFavorite: true,
              searchQuery: _searchQuery,
              selectedContacts: _selectedContacts,
              toggleSelection: _toggleSelection,
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
            // color: Colors.transparent,
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
