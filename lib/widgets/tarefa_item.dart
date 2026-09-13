import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../theme/app_colors.dart';
import '../utils/tarefa_utils.dart';

class TarefaItem extends StatelessWidget {
  final Tarefa tarefa;
  final VoidCallback aoAlternar;
  final VoidCallback aoExcluir;
  final VoidCallback aoEditar;
  final VoidCallback aoDetalhar;

  const TarefaItem({
    super.key,
    required this.tarefa,
    required this.aoAlternar,
    required this.aoExcluir,
    required this.aoEditar,
    required this.aoDetalhar,
  });

  bool estaAtrasada() {
    if (tarefa.dataVencimento == null || tarefa.concluida) {
      return false;
    }

    return tarefa.dataVencimento!.isBefore(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final cor = corDaPrioridade(tarefa.prioridade);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 5, color: cor),
            Expanded(
              child: ListTile(
                onTap: aoDetalhar,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                leading: Checkbox(
                  value: tarefa.concluida,
                  activeColor: AppColors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  onChanged: (_) {
                    aoAlternar();
                  },
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 8),
                  child: Text(
                    tarefa.titulo,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: tarefa.concluida ? AppColors.slate : AppColors.ink,
                      decoration: tarefa.concluida
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
                subtitle: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _Pilula(
                      icone: Icons.flag,
                      texto: nomeDaPrioridade(tarefa.prioridade),
                      cor: cor,
                    ),
                    if (tarefa.dataVencimento != null)
                      _Pilula(
                        icone: Icons.calendar_today,
                        texto: formatarData(tarefa.dataVencimento!),
                        cor: AppColors.slate,
                      ),
                    if (estaAtrasada())
                      const _Pilula(
                        icone: Icons.warning_amber_rounded,
                        texto: 'Atrasada',
                        cor: AppColors.prioridadeAlta,
                      ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      color: AppColors.slate,
                      onPressed: aoEditar,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      color: AppColors.prioridadeAlta,
                      onPressed: aoExcluir,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pilula extends StatelessWidget {
  final IconData icone;
  final String texto;
  final Color cor;

  const _Pilula({required this.icone, required this.texto, required this.cor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 12, color: cor),
          const SizedBox(width: 4),
          Text(
            texto,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: cor,
            ),
          ),
        ],
      ),
    );
  }
}
