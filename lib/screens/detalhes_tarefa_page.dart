import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../theme/app_colors.dart';
import '../utils/tarefa_utils.dart';

class DetalhesTarefaPage extends StatelessWidget {
  final Tarefa tarefa;

  const DetalhesTarefaPage({super.key, required this.tarefa});

  bool get atrasada {
    if (tarefa.dataVencimento == null || tarefa.concluida) {
      return false;
    }

    return tarefa.dataVencimento!.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final cor = corDaPrioridade(tarefa.prioridade);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes da tarefa')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tarefa.titulo,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
                decoration: tarefa.concluida
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _Selo(
                  texto: tarefa.concluida ? 'Concluída' : 'Pendente',
                  cor: tarefa.concluida
                      ? AppColors.prioridadeBaixa
                      : AppColors.slate,
                  icone: tarefa.concluida
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                ),
                _Selo(
                  texto: nomeDaPrioridade(tarefa.prioridade),
                  cor: cor,
                  icone: Icons.flag,
                ),
                if (atrasada)
                  const _Selo(
                    texto: 'Atrasada',
                    cor: AppColors.prioridadeAlta,
                    icone: Icons.warning_amber_rounded,
                  ),
              ],
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: AppColors.slate,
                ),
                const SizedBox(width: 8),
                Text(
                  tarefa.dataVencimento == null
                      ? 'Sem data de vencimento'
                      : 'Vencimento: ${formatarData(tarefa.dataVencimento!)}',
                  style: const TextStyle(fontSize: 15, color: AppColors.slate),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Selo extends StatelessWidget {
  final String texto;
  final Color cor;
  final IconData icone;

  const _Selo({required this.texto, required this.cor, required this.icone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 14, color: cor),
          const SizedBox(width: 6),
          Text(
            texto,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: cor,
            ),
          ),
        ],
      ),
    );
  }
}
