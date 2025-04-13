import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mediwise/Health%20Mobile%20App/pages/health_app_main_page.dart';
import 'package:mediwise/Health%20Mobile%20App/pages/healthapp_home_page.dart';
import 'package:mediwise/Health%20Mobile%20App/pages/onboarding_screen.dart';
import 'package:mediwise/Health%20Mobile%20App/pages/portal_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final prefs = await SharedPreferences.getInstance();
  bool hasSeenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  User? currentUser = FirebaseAuth.instance.currentUser;
  String? userRole = prefs.getString('userRole');
  print('Initial Check - User: ${currentUser?.email}, Role: $userRole');

  runApp(MyApp(hasSeenOnboarding: hasSeenOnboarding));
}

class MyApp extends StatelessWidget {
  final bool hasSeenOnboarding;

  const MyApp({super.key, required this.hasSeenOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: hasSeenOnboarding ? const AuthWrapper() : const OnboardingScreen(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print(
            'Auth State: ${snapshot.connectionState}, User: ${snapshot.data?.email}');

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasData) {
          // User is logged in
          return FutureBuilder<String?>(
            future: _getUserRole(),
            builder: (context, roleSnapshot) {
              print(
                  'Role State: ${roleSnapshot.connectionState}, Role: ${roleSnapshot.data}');

              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }

              final role = roleSnapshot.data;
              if (role == 'patient') {
                print('Navigating to HealthAppMainPage');
                return const HealthAppMainPage();
              } else if (role == 'doctor') {
                print('Navigating to HealthappHomePage');
                return const HealthappHomePage(); // Changed to doctor home page
              } else {
                print('No valid role found, showing PortalSelectionPage');
                return const PortalSelectionPage();
              }
            },
          );
        } else {
          print('No user logged in, showing PortalSelectionPage');
          return const PortalSelectionPage();
        }
      },
    );
  }

  Future<String?> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userRole');
  }
}
