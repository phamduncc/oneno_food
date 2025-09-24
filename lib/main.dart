import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/home_screen.dart';
import 'services/language_service.dart';
import 'l10n/app_localizations_delegate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize language service
  await LanguageService.instance.loadSavedLanguage();
  
  runApp(const OnenoFoodApp());
}

class OnenoFoodApp extends StatefulWidget {
  const OnenoFoodApp({super.key});

  @override
  State<OnenoFoodApp> createState() => _OnenoFoodAppState();
}

class _OnenoFoodAppState extends State<OnenoFoodApp> {
  @override
  void initState() {
    super.initState();
    // Listen to language changes
    LanguageService.instance.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    LanguageService.instance.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oneno Food - Vietnamese Regional Specialties',
      debugShowCheckedModeBanner: false,
      
      // Localization
      locale: LanguageService.instance.currentLocale,
      supportedLocales: AppLocalizationsDelegate.supportedLocales,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: Colors.red[700],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          primary: Colors.red[700]!,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.red[700],
          foregroundColor: Colors.white,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[700],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red[700]!),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
