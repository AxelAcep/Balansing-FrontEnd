// main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

// Import your custom User model
import 'package:balansing/models/user_model.dart' as app_user;

// Import your AuthService
import 'package:balansing/services/auth_services.dart';

// Import your new RiwayatProvider
import 'package:balansing/providers/KaderProvider.dart';

// Other screens
import 'package:balansing/screens/onboarding_screen.dart';
import 'package:balansing/screens/Kader/kader_dahboard_screen.dart';
import 'package:balansing/screens/Ibu/ibu_dashboard_screen.dart';
import 'package:balansing/models/filter_model.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await app_user.User.loadFromPrefs();

  runApp(
    // Gunakan MultiProvider untuk mendaftarkan semua provider
    MultiProvider(
      providers: [
        // Daftarkan provider untuk user model Anda
        ChangeNotifierProvider.value(value: app_user.User.instance),
        ChangeNotifierProvider(
          create: (_) => FilterModel(), // Daftarkan FilterModel
        ),
        
        // Daftarkan provider baru untuk riwayat
        ChangeNotifierProvider(create: (_) => RiwayatProvider()),
      ],
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
      home: Consumer<app_user.User>(
        builder: (context, user, child) {
          final authService = AuthService();

          if (authService.isUserTokenNullOrEmpty()) {
            print('DEBUG: User token is null or empty. Navigating to OnboardingScreen.');
            return const OnboardingScreen();
          } else {
            final String? userType = authService.getUserType();
            print('DEBUG: User token exists. User type: $userType');

            if (userType == 'KADER') {
              // Jika user adalah kader, kita bisa mengarahkannya ke halaman yang relevan
              // seperti KaderDashboardScreen yang mungkin mengandung RiwayatScreen.
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