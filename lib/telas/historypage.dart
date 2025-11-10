import 'package:flutter/material.dart';
import '../controllers/transacao_controller.dart';


class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});


  @override
  Widget build(BuildContext context) {
    final TransacaoController controller = TransacaoController();


    return FutureBuilder(
      future: controller.listar(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) return const Center(child: CircularProgressIndicator());
        final list = snapshot.data as List? ?? [];
        if (list.isEmpty) return const Center(child: Text('Sem transações'));
        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final t = list[index];
            return ListTile(
              title: Text(t.descricao),
              subtitle: Text('${t.categoria} • ${t.formaPagamento}'),
              trailing: Text((t.tipo == 'receita' ? '+' : '-') + ' R\$ ${t.valor.toStringAsFixed(2)}'),
            );
          },
        );
      },
    );
  }
}