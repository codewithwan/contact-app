import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:contact/providers/contact_provider.dart';
import 'package:contact/const/app_routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContactProvider()),
      ],
      child: MaterialApp(
        title: 'Contact App',
        routes: appRoutes, // Use the routes from app_routes.dart
        onGenerateRoute: generateRoute, // Handle unknown routes
      ),
    );
  }
}
