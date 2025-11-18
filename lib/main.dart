import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'telas/home.dart';
import 'theme.dart';

// Notifiers
final ValueNotifier<ThemeMode> temaNotifier = ValueNotifier(ThemeMode.system);
final ValueNotifier<String> moedaNotifier = ValueNotifier('R\$');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('temaEscuro') ?? false;
  final moeda = prefs.getString('moeda') ?? 'R\$';

  temaNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
  moedaNotifier.value = moeda;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: temaNotifier,
      builder: (_, mode, __) {
        return MaterialApp(
          title: 'Controle Financeiro',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.getTheme(false), // Tema Claro
          darkTheme: AppTheme.getTheme(true), // Tema Escuro
          themeMode: mode,
          home: const Home(),
        );
      },
    );
  }
}