import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kpi_demo/authentication/ui/login_screen.dart';
import 'package:kpi_demo/kpi_dashboard/ui/kpi_dashboard_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        sliderTheme: const SliderThemeData(
          valueIndicatorTextStyle: TextStyle(
            color: Colors.black,
          ),
        ),
        brightness: Brightness.dark,
        primaryColor: const Color.fromRGBO(255, 194, 10, 1),
        colorScheme:
            ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(
          primary: const Color.fromRGBO(255, 194, 10, 1),
          secondary: const Color.fromRGBO(255, 255, 255, 1),
          background: const Color.fromARGB(255, 23, 23, 23),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color.fromRGBO(255, 194, 10, 1),
          textTheme: ButtonTextTheme.primary,
        ),
        useMaterial3: true,
      ),
      home: const KpiDashboardScreen(),
      routes: {
        '/kpi': (context) => const KpiDashboardScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}
