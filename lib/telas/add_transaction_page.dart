import 'package:flutter/material.dart';
import '../models/transacao_model.dart';
import '../controllers/transacao_controller.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  String tipo = 'receita';
  String categoria = 'Outros';
  String formaPagamento = 'Dinheiro';
  final _controller = TransacaoController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Transação')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: _valorController,
              decoration: const InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              value: tipo,
              items: const [
                DropdownMenuItem(value: 'receita', child: Text('Receita')),
                DropdownMenuItem(value: 'despesa', child: Text('Despesa')),
              ],
              onChanged: (v) => setState(() => tipo = v!),
              decoration: const InputDecoration(labelText: 'Tipo'),
            ),
            DropdownButtonFormField(
              value: categoria,
              items: const [
                DropdownMenuItem(value: 'Alimentação', child: Text('Alimentação')),
                DropdownMenuItem(value: 'Transporte', child: Text('Transporte')),
                DropdownMenuItem(value: 'Lazer', child: Text('Lazer')),
                DropdownMenuItem(value: 'Salário', child: Text('Salário')),
                DropdownMenuItem(value: 'Saúde', child: Text('Saúde')),
                DropdownMenuItem(value: 'Outros', child: Text('Outros')),
              ],
              onChanged: (v) => setState(() => categoria = v!),
              decoration: const InputDecoration(labelText: 'Categoria'),
            ),
            DropdownButtonFormField(
              value: formaPagamento,
              items: const [
                DropdownMenuItem(value: 'Dinheiro', child: Text('Dinheiro')),
                DropdownMenuItem(value: 'Cartão', child: Text('Cartão')),
                DropdownMenuItem(value: 'Pix', child: Text('Pix')),
              ],
              onChanged: (v) => setState(() => formaPagamento = v!),
              decoration: const InputDecoration(labelText: 'Forma de Pagamento'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_descricaoController.text.isEmpty || _valorController.text.isEmpty) return;

                final nova = Transacao(
                  descricao: _descricaoController.text,
                  valor: double.parse(_valorController.text),
                  tipo: tipo,
                  categoria: categoria,
                  formaPagamento: formaPagamento,
                  data: DateTime.now(),
                );

                await _controller.adicionar(nova);
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
