import 'package:flutter/material.dart';
import 'package:contact/models/contact.dart';
import 'package:contact/services/contact_service.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> _contacts = [];

  List<Contact> get contacts => _contacts;

  Future<void> loadContacts() async {
    _contacts = await ContactService.getContacts();
    notifyListeners();
  }

  Future<void> fetchContacts() async {
    _contacts = await ContactService.getContacts();
    _contacts.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  Future<void> addContact(Contact contact) async {
    await ContactService.addContact(contact);
    await fetchContacts();
  }

  Future<void> updateContact(Contact contact) async {
    await ContactService.updateContact(contact);
    await fetchContacts();
  }

  Future<void> deleteContact(int id) async {
    await ContactService.deleteContact(id);
    await fetchContacts();
  }
}
