import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/transacao_controller.dart';

class PieChartPage extends StatefulWidget {
  final int mes;
  final int ano;

  const PieChartPage({super.key, required this.mes, required this.ano});

  @override
  State<PieChartPage> createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> {
  final _controller = TransacaoController();
  Map<String, double> despesas = {};

  @override
  void initState() {
    super.initState();
    _carregarDespesas();
  }

  Future<void> _carregarDespesas() async {
    final data = await _controller.despesasPorCategoria(widget.mes, widget.ano);
    setState(() => despesas = data);
  }

  @override
  Widget build(BuildContext context) {
    final total = despesas.values.fold(0.0, (a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Despesas por Categoria"),
      ),
      body: despesas.isEmpty
          ? const Center(child: Text("Nenhuma despesa encontrada neste mês."))
          : Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                sections: despesas.entries.map((e) {
                  final percent = (e.value / total * 100).toStringAsFixed(1);
                  return PieChartSectionData(
                    title: "${e.key}\n$percent%",
                    value: e.value,
                    radius: 100,
                    titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
                  );
                }).toList(),
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: despesas.entries.map((e) {
                return ListTile(
                  title: Text(e.key),
                  trailing: Text(
                    "R\$ ${e.value.toStringAsFixed(2)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
