import '../database/database_helper.dart';
import '../models/transacao_model.dart';
import 'package:intl/intl.dart';

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

  Future<List<Transacao>> listarPorMes(int mes, int ano) async {
    final db = await dbHelper.database;
    final inicio = DateTime(ano, mes, 1);
    final fim = DateTime(ano, mes + 1, 0);
    final result = await db.query(
      'transacoes',
      where: 'data BETWEEN ? AND ?',
      whereArgs: [inicio.toIso8601String(), fim.toIso8601String()],
      orderBy: 'data DESC',
    );
    return result.map((e) => Transacao.fromMap(e)).toList();
  }

  Future<Map<String, double>> despesasPorCategoria(int mes, int ano) async {
    final db = await dbHelper.database;
    final inicio = DateTime(ano, mes, 1);
    final fim = DateTime(ano, mes + 1, 0);
    final result = await db.rawQuery('''
      SELECT categoria, SUM(valor) as total
      FROM transacoes
      WHERE tipo = 'despesa' AND data BETWEEN ? AND ?
      GROUP BY categoria
    ''', [inicio.toIso8601String(), fim.toIso8601String()]);

    Map<String, double> mapa = {};
    for (var row in result) {
      mapa[row['categoria'] as String] = (row['total'] as num).toDouble();
    }
    return mapa;
  }

  Future<double> calcularSaldo() async {
    final db = await dbHelper.database;
    final receitas = await db.rawQuery("SELECT SUM(valor) as total FROM transacoes WHERE tipo='receita'");
    final despesas = await db.rawQuery("SELECT SUM(valor) as total FROM transacoes WHERE tipo='despesa'");
    final r = receitas.first['total'] ?? 0.0;
    final d = despesas.first['total'] ?? 0.0;
    return (r as num).toDouble() - (d as num).toDouble();
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
}
