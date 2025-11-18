import 'package:flutter/material.dart';
import '../controllers/transacao_controller.dart';
import '../widgets/button.dart';
import '../widgets/textos.dart';
import 'add_transaction_page.dart';
import '../main.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final controller = TransacaoController();
  double saldo = 0.0;
  double receitas = 0.0;
  double despesas = 0.0;

  @override
  void initState() {
    super.initState();
    _atualizarResumo();
  }

  Future<void> _atualizarResumo() async {
    final s = await controller.calcularSaldo();
    final r = await controller.somarPorTipo('receita');
    final d = await controller.somarPorTipo('despesa');
    if(mounted) {
      setState(() {
        saldo = s;
        receitas = r;
        despesas = d;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      // AppBar já vem do Home
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // CARD SALDO
            Card(
              color: colorScheme.primaryContainer,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Textos('Saldo Atual', cor: colorScheme.onPrimaryContainer, tamanho: 18),
                    const SizedBox(height: 8),
                    ValueListenableBuilder<String>(
                      valueListenable: moedaNotifier,
                      builder: (_, moeda, __) {
                        return Textos(
                          '$moeda ${saldo.toStringAsFixed(2)}',
                          cor: saldo >= 0 ? Colors.green[700] : Colors.red[700],
                          tamanho: 32,
                          peso: FontWeight.bold,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // RESUMO
            Row(
              children: [
                Expanded(child: _buildInfoCard('Receitas', receitas, Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _buildInfoCard('Despesas', despesas, Colors.red)),
              ],
            ),

            const Spacer(),

            // BOTÃO
            Botoes(
              "Nova Transação",
              icone: Icons.add,
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddTransactionPage()),
                );
                _atualizarResumo();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String titulo, double valor, Color corIcone) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              titulo == 'Receitas' ? Icons.arrow_circle_up : Icons.arrow_circle_down,
              color: corIcone,
              size: 30,
            ),
            const SizedBox(height: 8),
            Textos(titulo, tamanho: 14),
            const SizedBox(height: 4),
            ValueListenableBuilder<String>(
              valueListenable: moedaNotifier,
              builder: (_, moeda, __) {
                return Textos(
                  '$moeda ${valor.toStringAsFixed(2)}',
                  cor: corIcone,
                  peso: FontWeight.bold,
                  tamanho: 16,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}