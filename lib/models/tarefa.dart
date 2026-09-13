enum Prioridade { baixa, media, alta }

class Tarefa {
  String titulo;
  bool concluida;
  Prioridade prioridade;
  DateTime? dataVencimento;

  Tarefa({
    required this.titulo,
    this.concluida = false,
    this.prioridade = Prioridade.media,
    this.dataVencimento,
  });

  void alternarConclusao() {
    concluida = !concluida;
  }

  /// Transforma a tarefa em um mapa simples, para poder salvar como texto.
  Map<String, dynamic> paraMapa() {
    return {
      'titulo': titulo,
      'concluida': concluida,
      'prioridade': prioridade.index,
      'dataVencimento': dataVencimento?.toIso8601String(),
    };
  }

  /// Reconstrói uma tarefa a partir do mapa salvo.
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
