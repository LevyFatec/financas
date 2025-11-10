import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'telas/home.dart';

// Notifiers globais
final ValueNotifier<ThemeMode> temaNotifier = ValueNotifier(ThemeMode.light);
final ValueNotifier<String> moedaNotifier = ValueNotifier('R\$');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carregar preferências salvas
  final prefs = await SharedPreferences.getInstance();
  final temaEscuro = prefs.getBool('temaEscuro') ?? false;
  final moeda = prefs.getString('moeda') ?? 'R\$';

  temaNotifier.value = temaEscuro ? ThemeMode.dark : ThemeMode.light;
  moedaNotifier.value = moeda;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: temaNotifier,
      builder: (_, tema, __) {
        return MaterialApp(
          title: 'Controle Financeiro',
          theme: ThemeData.light(useMaterial3: true),
          darkTheme: ThemeData.dark(useMaterial3: true),
          themeMode: tema,
          debugShowCheckedModeBanner: false,
          home: const Home(),
        );
      },
    );
  }
}
