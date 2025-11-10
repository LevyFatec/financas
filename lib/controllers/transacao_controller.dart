import '../database/database_helper.dart';
import '../models/transacao_model.dart';

class TransacaoController {
  final dbHelper = DatabaseHelper();

  Future<int> adicionar(Transacao transacao) async {
    final db = await dbHelper.database;
    return await db.insert('transacoes', transacao.toMap());
  }

  Future<List<Transacao>> listar() async {
    final db = await dbHelper.database;
    final result = await db.query('transacoes', orderBy: 'data DESC');
    return result.map((e) => Transacao.fromMap(e)).toList();
  }

  Future<int> atualizar(Transacao transacao) async {
    final db = await dbHelper.database;
    return await db.update(
      'transacoes',
      transacao.toMap(),
      where: 'id = ?',
      whereArgs: [transacao.id],
    );
  }

  Future<int> deletar(int id) async {
    final db = await dbHelper.database;
    return await db.delete('transacoes', where: 'id = ?', whereArgs: [id]);
  }

  Future<double> calcularSaldo() async {
    final db = await dbHelper.database;
    final receitas = await db.rawQuery("SELECT SUM(valor) as total FROM transacoes WHERE tipo='receita'");
    final despesas = await db.rawQuery("SELECT SUM(valor) as total FROM transacoes WHERE tipo='despesa'");
    final r = receitas.first['total'] ?? 0.0;
    final d = despesas.first['total'] ?? 0.0;
    return (r as num).toDouble() - (d as num).toDouble();
  }
}
