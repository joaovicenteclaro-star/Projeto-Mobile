import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../theme/app_colors.dart';

/// Funções compartilhadas entre TarefaItem e DetalhesTarefaPage,
/// para manter a lógica de prioridade e datas em um só lugar.

Color corDaPrioridade(Prioridade prioridade) {
  switch (prioridade) {
    case Prioridade.baixa:
      return AppColors.prioridadeBaixa;
    case Prioridade.media:
      return AppColors.prioridadeMedia;
    case Prioridade.alta:
      return AppColors.prioridadeAlta;
  }
}

String nomeDaPrioridade(Prioridade prioridade) {
  switch (prioridade) {
    case Prioridade.baixa:
      return 'Baixa';
    case Prioridade.media:
      return 'Média';
    case Prioridade.alta:
      return 'Alta';
  }
}

String formatarData(DateTime data) {
  final dia = data.day.toString().padLeft(2, '0');
  final mes = data.month.toString().padLeft(2, '0');
  return '$dia/$mes/${data.year}';
}
