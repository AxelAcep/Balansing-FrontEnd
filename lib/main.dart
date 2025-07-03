import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:balansing/screens/onboarding_screen.dart';
//import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:balansing/screens/main_screen.dart';
import 'package:balansing/services/auth_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://fqpalkzlylkiqmnsizji.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZxcGFsa3pseWxraXFtbnNpemppIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTA2NDE0MDcsImV4cCI6MjA2NjIxNzQwN30.RSl9KRyaBjYMPQvR48CsiAfileL4RS7YWqdUunqx5ug',
  );
  await initializeDateFormatting('id_ID', null)
      .then((_) => runApp(const MyApp())); 
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    
    return MultiProvider( 
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
      ], 
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xff0678FF)),
            useMaterial3: true,
            navigationBarTheme: NavigationBarThemeData(
              labelTextStyle: WidgetStatePropertyAll(GoogleFonts.poppins(
                  fontSize: 10, fontWeight: FontWeight.w700)),
            ),
          ),
          home: FutureBuilder(
              future: AuthService().isUserLoggedIn(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Container(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  print(snapshot.data);
                  return snapshot.data!
                      ? const MainScreen(pageIndex: 0)
                      : const OnboardingScreen();
                } else {
                  return const Text('No data');
                }
              })),
    );
  }
}
