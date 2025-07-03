// main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

// Import your custom User model (no prefix needed for this one as it's your primary)
import 'package:balansing/models/user_model.dart' as app_user;

// Import your AuthService
import 'package:balansing/services/auth_services.dart';

// Supabase and gotrue
import 'package:supabase_flutter/supabase_flutter.dart';
// FIX HERE: Add 'as supabase_auth' prefix to the gotrue User import

// Other screens
import 'package:balansing/screens/onboarding_screen.dart';
import 'package:balansing/screens/Kader/kader_dahboard_screen.dart';
import 'package:balansing/screens/Ibu/ibu_dashboard_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fqpalkzlylkiqmnsizji.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZxcGFsa3pseWxraXFtbnNpemppIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA2NDE0MDcsImV4cCI6MjA2NjIxNzQwN30.RSl9KRyaBjYMPQvR48CsiAfileL4RS7YWqdUunqx5ug',
  );

  await initializeDateFormatting('id_ID', null);

  // Load data into your custom User model instance
  await app_user.User.loadFromPrefs();

  runApp(
    ChangeNotifierProvider.value(
      value: app_user.User.instance, // This refers to your custom User model
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff0678FF)),
        useMaterial3: true,
        navigationBarTheme: NavigationBarThemeData(
          labelTextStyle: WidgetStatePropertyAll(GoogleFonts.poppins(
              fontSize: 10, fontWeight: FontWeight.w700)),
        ),
      ),
      home: Consumer<app_user.User>( // This 'User' refers to your custom User model
        builder: (context, user, child) {
          final authService = AuthService();

          if (authService.isUserTokenNullOrEmpty()) {
            print('DEBUG: User token is null or empty. Navigating to OnboardingScreen.');
            return const OnboardingScreen();
          } else {
            final String? userType = authService.getUserType();
            print('DEBUG: User token exists. User type: $userType');

            if (userType == 'KADER') {
              return const KaderDashboardScreen();
            } else if (userType == 'IBU') {
              return const IbuDashboardScreen();
            } else {
              print('DEBUG: Unknown user type or empty. Navigating to OnboardingScreen.');
              return const OnboardingScreen();
            }
          }
        },
      ),
    );
  }
}