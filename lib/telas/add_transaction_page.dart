import 'package:flutter/material.dart';
import '../models/transacao_model.dart';
import '../controllers/transacao_controller.dart';
import '../widgets/input.dart';
import '../widgets/button.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>(); // Chave para validação
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Input(
                'Descrição',
                controller: _descricaoController,
                hint: 'Ex: Mercado',
                validator: (val) => val == null || val.isEmpty ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 16),
              Input(
                'Valor',
                controller: _valorController,
                hint: '0.00',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Informe o valor';
                  if (double.tryParse(val.replaceAll(',', '.')) == null) return 'Valor inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: tipo,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: const [
                  DropdownMenuItem(value: 'receita', child: Text('Receita')),
                  DropdownMenuItem(value: 'despesa', child: Text('Despesa')),
                ],
                onChanged: (v) => setState(() => tipo = v!),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: categoria,
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: ['Alimentação', 'Transporte', 'Lazer', 'Salário', 'Saúde', 'Outros']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => categoria = v!),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: formaPagamento,
                decoration: const InputDecoration(labelText: 'Pagamento'),
                items: ['Dinheiro', 'Cartão', 'Pix']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (v) => setState(() => formaPagamento = v!),
              ),
              const SizedBox(height: 24),

              Botoes(
                'Salvar Transação',
                icone: Icons.save,
                onPressed: () async {
                  // Validação RNF01.2
                  if (_formKey.currentState!.validate()) {
                    final valorDouble = double.parse(_valorController.text.replaceAll(',', '.'));

                    final nova = Transacao(
                      descricao: _descricaoController.text,
                      valor: valorDouble,
                      tipo: tipo,
                      categoria: categoria,
                      formaPagamento: formaPagamento,
                      data: DateTime.now(),
                    );

                    await _controller.adicionar(nova);
                    if (context.mounted) Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}