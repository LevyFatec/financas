class Transacao {
  int? id;
  String descricao;
  double valor;
  String tipo; // receita ou despesa
  String categoria;
  String formaPagamento;
  DateTime data;

  Transacao({
    this.id,
    required this.descricao,
    required this.valor,
    required this.tipo,
    required this.categoria,
    required this.formaPagamento,
    required this.data,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'descricao': descricao,
    'valor': valor,
    'tipo': tipo,
    'categoria': categoria,
    'formaPagamento': formaPagamento,
    'data': data.toIso8601String(),
  };

  factory Transacao.fromMap(Map<String, dynamic> map) => Transacao(
    id: map['id'],
    descricao: map['descricao'],
    valor: (map['valor'] as num).toDouble(),
    tipo: map['tipo'],
    categoria: map['categoria'],
    formaPagamento: map['formaPagamento'],
    data: DateTime.parse(map['data']),
  );
}
