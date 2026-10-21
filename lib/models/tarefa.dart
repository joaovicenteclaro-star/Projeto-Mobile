
enum Prioridade { baixa, media, alta }

class Tarefa {
  int? id;
  String titulo;
  bool concluida;
  Prioridade prioridade;
  DateTime? dataVencimento;

  Tarefa({
    this.id,
    required this.titulo,
    this.concluida = false,
    this.prioridade = Prioridade.media,
    this.dataVencimento,
  });

  void alternarConclusao() {
    concluida = !concluida;
  }

  Map<String, dynamic> paraApi() {
    return {
      'titulo': titulo,
      'concluida': concluida,
      'prioridade': prioridade.name,
      'dataVencimento': dataVencimento?.toIso8601String(),
    };
  }

  factory Tarefa.deApi(Map<String, dynamic> json) {
    return Tarefa(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      concluida: json['concluida'] as bool,
      prioridade: Prioridade.values.firstWhere(
        (p) => p.name == json['prioridade'],
        orElse: () => Prioridade.media,
      ),
      dataVencimento: json['dataVencimento'] == null
          ? null
          : DateTime.parse(json['dataVencimento'] as String),
    );
  }

  // Mantém compatibilidade com o armazenamento local existente.
  Map<String, dynamic> paraMapa() {
    return {
      'titulo': titulo,
      'concluida': concluida,
      'prioridade': prioridade.index,
      'dataVencimento': dataVencimento?.toIso8601String(),
    };
  }

  factory Tarefa.doMapa(Map<String, dynamic> mapa) {
    return Tarefa(
      titulo: mapa['titulo'] as String,
      concluida: mapa['concluida'] as bool,
      prioridade: Prioridade.values[mapa['prioridade'] as int],
      dataVencimento: mapa['dataVencimento'] == null
          ? null
          : DateTime.parse(mapa['dataVencimento'] as String),
    );
  }
}
