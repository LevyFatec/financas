import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/textos.dart';
import '../main.dart'; // para acessar os notifiers globais

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool temaEscuro = false;
  bool notificacoes = true;
  String moeda = 'R\$';

  final List<String> moedas = ['R\$', 'USD', 'EUR'];

  @override
  void initState() {
    super.initState();
    _carregarPreferencias();
  }

  Future<void> _carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      temaEscuro = prefs.getBool('temaEscuro') ?? false;
      notificacoes = prefs.getBool('notificacoes') ?? true;
      moeda = prefs.getString('moeda') ?? 'R\$';
    });
  }

  Future<void> _salvarTema(bool escuro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('temaEscuro', escuro);
    temaNotifier.value = escuro ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> _salvarMoeda(String novaMoeda) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('moeda', novaMoeda);
    moedaNotifier.value = novaMoeda;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Tema Escuro
          SwitchListTile(
            title: const Textos('Tema Escuro', Colors.black),
            subtitle: const Text('Ative para modo escuro'),
            value: temaEscuro,
            onChanged: (v) {
              setState(() => temaEscuro = v);
              _salvarTema(v);
            },
          ),
          const Divider(),

          // Notificações (apenas enfeite)
          SwitchListTile(
            title: const Textos('Notificações', Colors.black),
            subtitle: const Text('Não tem efeito real ainda'),
            value: notificacoes,
            onChanged: (v) => setState(() => notificacoes = v),
          ),
          const Divider(),

          // Moeda
          ListTile(
            title: const Textos('Moeda', Colors.black),
            subtitle: Text(moeda),
            trailing: DropdownButton<String>(
              value: moeda,
              items: moedas
                  .map((m) => DropdownMenuItem(
                value: m,
                child: Text(m),
              ))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  setState(() => moeda = v);
                  _salvarMoeda(v);
                }
              },
            ),
          ),
          const Divider(),

          // Sobre o App
          const SizedBox(height: 20),
          const Textos('Sobre o App', Colors.black),
          const SizedBox(height: 8),
          const Text(
            'Controle Financeiro\nVersão 1.0\nDesenvolvido por Levy Rocha',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
