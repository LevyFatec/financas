import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/textos.dart';
import '../main.dart'; // Importante para acessar o temaNotifier e moedaNotifier

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Removemos variáveis locais desnecessárias para usar direto os notifiers globais

  Future<void> _salvarTema(bool escuro) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('temaEscuro', escuro);

    // 1. Atualiza o Notifier global para mudar o app todo
    temaNotifier.value = escuro ? ThemeMode.dark : ThemeMode.light;

    // 2. O PULO DO GATO: Força o switch a atualizar visualmente na tela
    setState(() {});
  }

  Future<void> _salvarMoeda(String novaMoeda) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('moeda', novaMoeda);
    moedaNotifier.value = novaMoeda;
    setState(() {}); // Atualiza o dropdown
  }

  @override
  Widget build(BuildContext context) {
    // Verifica se o tema atual é Escuro para posicionar o Switch corretamente
    final isDark = temaNotifier.value == ThemeMode.dark;

    return Scaffold(
      // AppBar removida se você já estiver usando dentro de uma Home com AppBar
      // Se estiver usando solta, pode descomentar a linha abaixo:
      // appBar: AppBar(title: const Text('Configurações')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // TEMA ESCURO
          SwitchListTile(
            title: const Textos('Tema Escuro', tamanho: 18),
            subtitle: const Textos(
                'Alterar aparência do app',
                tamanho: 14,
                cor: Colors.grey
            ),
            value: isDark, // Usa o valor calculado acima
            onChanged: (v) => _salvarTema(v),
          ),
          const Divider(),

          // MOEDA
          ListTile(
            title: const Textos('Moeda Padrão', tamanho: 18),
            trailing: ValueListenableBuilder<String>(
              valueListenable: moedaNotifier,
              builder: (_, valorAtual, __) {
                return DropdownButton<String>(
                  value: valorAtual,
                  underline: Container(), // Remove a linha padrão feia do dropdown
                  items: ['R\$', 'USD', 'EUR']
                      .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) _salvarMoeda(v);
                  },
                );
              },
            ),
          ),
          const Divider(),

          const SizedBox(height: 40),
          const Center(
            child: Textos(
              'Controle Financeiro v1.0\nPor Levy Rocha',
              align: TextAlign.center,
              cor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}