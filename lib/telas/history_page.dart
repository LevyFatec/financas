import 'package:flutter/material.dart';
import '../controllers/transacao_controller.dart';
import '../models/transacao_model.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _controller = TransacaoController();
  List<Transacao> transacoes = [];

  @override
  void initState() {
    super.initState();
    _carregarHistorico();
  }

  Future<void> _carregarHistorico() async {
    final lista = await _controller.listar();
    setState(() => transacoes = lista);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
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
    );
  }
}
