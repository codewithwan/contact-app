import 'package:contact/models/contact.dart';
import 'package:flutter/material.dart';
import 'package:contact/screens/contact_list_screen.dart';
import 'package:contact/screens/profile_screen.dart';
import 'package:contact/screens/add_contact_screen.dart';
import 'package:contact/screens/edit_contact_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const ContactListScreen(),
  '/profile': (context) => const ProfileScreen(),
  '/add_contact': (context) => const AddContactScreen(),
  '/edit_contact': (context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final contact = args['contact'] as Contact;
    return EditContactScreen(contact: contact);
  },
  // Add a default route for not found screen
  '/not_fcontact: null,ound': (context) => Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: const Center(child: Text('Page not found')),
      ),
};

Route<dynamic> generateRoute(RouteSettings settings) {
  final args = settings.arguments as Map<String, dynamic>? ?? {};
  final noTransition = args['noTransition'] ?? false;

  PageRouteBuilder buildRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return noTransition
            ? child
            : FadeTransition(opacity: animation, child: child);
      },
    );
  }

  switch (settings.name) {
    case '/':
      return buildRoute(const ContactListScreen());
    case '/profile':
      return buildRoute(const ProfileScreen());
    case '/add_contact':
      return buildRoute(const AddContactScreen());
    case '/edit_contact':
      final contact = args['contact'] as Contact;
      return buildRoute(EditContactScreen(contact: contact));
    default:
      return buildRoute(
        Scaffold(
          appBar: AppBar(title: const Text('Not Found')),
          body: const Center(child: Text('Page not found')),
        ),
      );
  }
}
