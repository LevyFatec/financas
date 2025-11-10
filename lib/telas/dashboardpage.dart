import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/transacao_controller.dart';
import '../widgets/button.dart';
import '../widgets/textos.dart';
import 'add_transaction_page.dart';
import '../main.dart'; // para acessar moedaNotifier

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
    setState(() {
      saldo = s;
      receitas = r;
      despesas = d;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Financeiro'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // SALDO ATUAL
            Expanded(
              flex: 2,
              child: Card(
                color: Colors.blue.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Textos('Saldo Atual', Colors.black),
                      const SizedBox(height: 8),
                      ValueListenableBuilder<String>(
                        valueListenable: moedaNotifier,
                        builder: (_, moeda, __) {
                          return Textos(
                            '$moeda ${saldo.toStringAsFixed(2)}',
                            saldo >= 0 ? Colors.green : Colors.red,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // RECEITAS E DESPESAS
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.green.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.arrow_upward,
                                color: Colors.green, size: 40),
                            const Textos('Receitas', Colors.black),
                            const SizedBox(height: 8),
                            ValueListenableBuilder<String>(
                              valueListenable: moedaNotifier,
                              builder: (_, moeda, __) {
                                return Textos(
                                  '$moeda ${receitas.toStringAsFixed(2)}',
                                  Colors.green,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Card(
                      color: Colors.red.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.arrow_downward,
                                color: Colors.red, size: 40),
                            const Textos('Despesas', Colors.black),
                            const SizedBox(height: 8),
                            ValueListenableBuilder<String>(
                              valueListenable: moedaNotifier,
                              builder: (_, moeda, __) {
                                return Textos(
                                  '$moeda ${despesas.toStringAsFixed(2)}',
                                  Colors.red,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // BOTÃO ÚNICO
            Expanded(
              flex: 2,
              child: Center(
                child: Botoes(
                  "Adicionar Transação",
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddTransactionPage(),
                      ),
                    );
                    _atualizarResumo();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
