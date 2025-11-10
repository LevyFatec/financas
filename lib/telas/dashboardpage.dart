import 'package:flutter/material.dart';
import '../controllers/transacao_controller.dart';
import '../models/transacao_model.dart';
import 'add_transaction_page.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _controller = TransacaoController();
  double saldo = 0;
  List<Transacao> transacoes = [];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final lista = await _controller.listar();
    final total = await _controller.calcularSaldo();
    setState(() {
      transacoes = lista;
      saldo = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _carregarDados,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              "Saldo atual:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "R\$ ${saldo.toStringAsFixed(2)}",
              style: TextStyle(
                fontSize: 28,
                color: saldo >= 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text("Últimas transações:", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...transacoes.map((t) => ListTile(
              leading: Icon(
                t.tipo == 'receita' ? Icons.arrow_upward : Icons.arrow_downward,
                color: t.tipo == 'receita' ? Colors.green : Colors.red,
              ),
              title: Text(t.descricao),
              subtitle: Text("${t.categoria} - ${DateFormat('dd/MM/yyyy').format(t.data)}"),
              trailing: Text(
                "R\$ ${t.valor.toStringAsFixed(2)}",
                style: TextStyle(
                  color: t.tipo == 'receita' ? Colors.green : Colors.red,
                ),
              ),
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionPage()),
          );
          _carregarDados();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
