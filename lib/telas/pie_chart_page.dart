import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../controllers/transacao_controller.dart';
import '../widgets/textos.dart';
import '../widgets/button.dart';

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
    final meses = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Despesas - ${meses[widget.mes - 1]} ${widget.ano}'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: despesas.isEmpty
            ? const Center(
          child: Textos('Nenhuma despesa neste mês.', Colors.grey),
        )
            : Column(
          children: [
            // 🥧 Gráfico principal - 3 partes
            Expanded(
              flex: 3,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 50,
                      sections: despesas.entries.map((e) {
                        final percent = (e.value / total * 100);
                        final color = _gerarCorPorCategoria(e.key);
                        return PieChartSectionData(
                          color: color,
                          title: "${percent.toStringAsFixed(1)}%",
                          value: e.value,
                          radius: 90,
                          titleStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 📋 Lista de categorias - 2 partes
            Expanded(
              flex: 2,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ListView(
                    children: despesas.entries.map((e) {
                      final cor = _gerarCorPorCategoria(e.key);
                      final percent = (e.value / total * 100);
                      final moeda = NumberFormat.currency(
                          locale: 'pt_BR', symbol: 'R\$');
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: cor,
                          child: const Icon(Icons.label, color: Colors.white),
                        ),
                        title: Text(e.key,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            '${percent.toStringAsFixed(1)}% do total'),
                        trailing: Textos(
                            moeda.format(e.value), Colors.black87),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 🔙 Botão de voltar - 1 parte
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Botoes(
                    'Voltar',
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Gera cor para cada categoria (visual padrão e consistente)
  Color _gerarCorPorCategoria(String categoria) {
    switch (categoria) {
      case 'Alimentação':
        return Colors.orange;
      case 'Transporte':
        return Colors.blue;
      case 'Lazer':
        return Colors.purple;
      case 'Saúde':
        return Colors.redAccent;
      case 'Salário':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
