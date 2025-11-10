import 'package:flutter/material.dart';
import '../controllers/transacao_controller.dart';
import '../models/transacao_model.dart';
import 'package:intl/intl.dart';
import 'pie_chart_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _controller = TransacaoController();
  List<Transacao> transacoes = [];
  int mesSelecionado = DateTime.now().month;
  int anoSelecionado = DateTime.now().year;

  final List<int> anos = [2023, 2024, 2025, 2026];
  final List<String> meses = [
    "Janeiro",
    "Fevereiro",
    "Março",
    "Abril",
    "Maio",
    "Junho",
    "Julho",
    "Agosto",
    "Setembro",
    "Outubro",
    "Novembro",
    "Dezembro"
  ];

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    final lista = await _controller.listarPorMes(mesSelecionado, anoSelecionado);
    setState(() => transacoes = lista);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Transações'),
      ),
      body: Column(
        children: [
          // 🧩 Filtros - 1 parte
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<int>(
                    value: mesSelecionado,
                    items: List.generate(
                      12,
                          (i) => DropdownMenuItem(
                        value: i + 1,
                        child: Text(meses[i]),
                      ),
                    ),
                    onChanged: (v) {
                      setState(() => mesSelecionado = v!);
                      _carregarHistorico();
                    },
                  ),
                  const SizedBox(width: 12),
                  DropdownButton<int>(
                    value: anoSelecionado,
                    items: anos
                        .map((a) => DropdownMenuItem(value: a, child: Text(a.toString())))
                        .toList(),
                    onChanged: (v) {
                      setState(() => anoSelecionado = v!);
                      _carregarHistorico();
                    },
                  ),
                ],
              ),
            ),
          ),

          // 📋 Lista de transações - 6 partes
          Expanded(
            flex: 6,
            child: RefreshIndicator(
              onRefresh: _carregarHistorico,
              child: ListView.builder(
                itemCount: transacoes.length,
                itemBuilder: (context, index) {
                  final t = transacoes[index];
                  return ListTile(
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
                  );
                },
              ),
            ),
          ),

          // 🥧 Botão gráfico - 1 parte
          Expanded(
            flex: 1,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PieChartPage(
                        mes: mesSelecionado,
                        ano: anoSelecionado,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.pie_chart),
                label: const Text("Ver gráfico de despesas"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
