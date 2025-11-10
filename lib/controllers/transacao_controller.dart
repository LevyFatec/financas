import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../models/transacao_model.dart';

class TransacaoController {
  final dbHelper = DatabaseHelper();

  /// Adiciona uma nova transação (receita ou despesa)
  Future<int> adicionar(Transacao transacao) async {
    final db = await dbHelper.database;
    return await db.insert('transacoes', transacao.toMap());
  }

  /// Lista todas as transações (opcionalmente limitado)
  Future<List<Transacao>> listar({int? limit}) async {
    final db = await dbHelper.database;
    final result = await db.query(
      'transacoes',
      orderBy: 'data DESC',
      limit: limit,
    );
    return result.map((e) => Transacao.fromMap(e)).toList();
  }

  /// Lista transações por mês e ano
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

  /// Atualiza uma transação existente
  Future<int> atualizar(Transacao transacao) async {
    final db = await dbHelper.database;
    return await db.update(
      'transacoes',
      transacao.toMap(),
      where: 'id = ?',
      whereArgs: [transacao.id],
    );
  }

  /// Deleta uma transação pelo ID
  Future<int> deletar(int id) async {
    final db = await dbHelper.database;
    return await db.delete('transacoes', where: 'id = ?', whereArgs: [id]);
  }

  /// Calcula o saldo total (receitas - despesas)
  Future<double> calcularSaldo() async {
    final db = await dbHelper.database;

    final receitas = await db.rawQuery(
        "SELECT SUM(valor) as total FROM transacoes WHERE tipo='receita'");
    final despesas = await db.rawQuery(
        "SELECT SUM(valor) as total FROM transacoes WHERE tipo='despesa'");

    final r = receitas.first['total'] ?? 0.0;
    final d = despesas.first['total'] ?? 0.0;

    return (r as double? ?? 0.0) - (d as double? ?? 0.0);
  }

  /// Soma o valor total de receitas ou despesas
  Future<double> somarPorTipo(String tipo) async {
    final db = await dbHelper.database;
    final result = await db.rawQuery(
        "SELECT SUM(valor) as total FROM transacoes WHERE tipo = ?", [tipo]);
    return (result.first['total'] as double?) ?? 0.0;
  }

  /// Retorna mapa com soma de despesas agrupadas por categoria (para o gráfico)
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

    final Map<String, double> mapa = {};
    for (var e in result) {
      mapa[e['categoria'] as String] = (e['total'] as num).toDouble();
    }
    return mapa;
  }
}
