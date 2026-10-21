import 'package:flutter/material.dart';

import '../models/tarefa.dart';
import '../theme/app_colors.dart';
import '../utils/tarefa_utils.dart';
import 'detalhes_tarefa_page.dart';
import '../widgets/tarefa_item.dart';
import '../services/tarefa_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Tarefa> tarefas = [];
  bool carregando = true;

  Prioridade prioridadeSelecionada = Prioridade.media;
  DateTime? dataSelecionada;
  String filtroSelecionado = 'Todas';

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  
Future<void> _carregarTarefas() async {
  try {
    final resultado = await TarefaApi.listar();

    if (!mounted) return;

    setState(() {
      tarefas
        ..clear()
        ..addAll(resultado);
      carregando = false;
    });
  } catch (e) {
    if (!mounted) return;

    setState(() => carregando = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro ao carregar tarefas: $e')),
    );
  }
}

Future<void> adicionarTarefa(
  String titulo,
  Prioridade prioridade,
  DateTime? dataVencimento,
) async {
  try {
    final criada = await TarefaApi.criar(
      Tarefa(
        titulo: titulo,
        prioridade: prioridade,
        dataVencimento: dataVencimento,
      ),
    );

    if (!mounted) return;

    setState(() => tarefas.add(criada));
  } catch (e) {
    _mostrarErro('Não foi possível cadastrar a tarefa: $e');
  }
}

Future<void> editarTarefa(
  int indice,
  String novoTitulo,
  Prioridade novaPrioridade,
  DateTime? novaData,
) async {
  final original = tarefas[indice];

  final atualizada = Tarefa(
    id: original.id,
    titulo: novoTitulo,
    concluida: original.concluida,
    prioridade: novaPrioridade,
    dataVencimento: novaData,
  );

  try {
    await TarefaApi.atualizar(atualizada);

    if (!mounted) return;

    setState(() {
      tarefas[indice] = atualizada;
    });
  } catch (e) {
    _mostrarErro('Não foi possível editar a tarefa: $e');
  }
}

Future<void> alternarTarefa(int indice) async {
  final original = tarefas[indice];

  final atualizada = Tarefa(
    id: original.id,
    titulo: original.titulo,
    concluida: !original.concluida,
    prioridade: original.prioridade,
    dataVencimento: original.dataVencimento,
  );

  try {
    await TarefaApi.atualizar(atualizada);

    if (!mounted) return;

    setState(() {
      tarefas[indice] = atualizada;
    });
  } catch (e) {
    _mostrarErro('Não foi possível alterar a tarefa: $e');
  }
}

Future<bool> removerTarefa(int indice) async {
  final original = tarefas[indice];

  if (original.id == null) {
    _mostrarErro('A tarefa não possui ID no banco.');
    return false;
  }

  try {
    await TarefaApi.excluir(original.id!);

    if (!mounted) return false;

    setState(() {
      tarefas.removeAt(indice);
    });
    return true;
  } catch (e) {
    _mostrarErro('Não foi possível excluir a tarefa: $e');
    return false;
  }
}

void _mostrarErro(String mensagem) {
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(mensagem)),
  );
}


  int get tarefasConcluidas {
    return tarefas.where((tarefa) => tarefa.concluida).length;
  }

  int get tarefasPendentes {
    return tarefas.where((tarefa) => !tarefa.concluida).length;
  }

  List<Tarefa> get tarefasFiltradas {
    if (filtroSelecionado == 'Pendentes') {
      return tarefas.where((tarefa) => !tarefa.concluida).toList();
    }

    if (filtroSelecionado == 'Concluídas') {
      return tarefas.where((tarefa) => tarefa.concluida).toList();
    }

    return tarefas;
  }

  Widget _chipFiltro(String rotulo) {
    final selecionado = filtroSelecionado == rotulo;

    return Expanded(
      child: FilterChip(
        label: Text(rotulo),
        selected: selecionado,
        onSelected: (_) {
          setState(() {
            filtroSelecionado = rotulo;
          });
        },
        selectedColor: AppColors.teal,
        backgroundColor: AppColors.surface,
        checkmarkColor: Colors.white,
        labelStyle: TextStyle(
          color: selecionado ? Colors.white : AppColors.ink,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: selecionado ? AppColors.teal : AppColors.outline,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TaskFlow')),

      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  color: AppColors.surface,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Minhas tarefas',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                          letterSpacing: -0.4,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        '${tarefas.length} tarefas • $tarefasConcluidas concluídas',
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.slate,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: _ResumoCard(
                              titulo: 'Total',
                              valor: tarefas.length,
                              cor: AppColors.teal,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _ResumoCard(
                              titulo: 'Pendentes',
                              valor: tarefasPendentes,
                              cor: AppColors.prioridadeMedia,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _ResumoCard(
                              titulo: 'Concluídas',
                              valor: tarefasConcluidas,
                              cor: AppColors.prioridadeBaixa,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      _chipFiltro('Todas'),
                      const SizedBox(width: 8),
                      _chipFiltro('Pendentes'),
                      const SizedBox(width: 8),
                      _chipFiltro('Concluídas'),
                    ],
                  ),
                ),

                Expanded(
                  child: tarefas.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 96,
                                height: 96,
                                decoration: const BoxDecoration(
                                  color: AppColors.tealTint,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.task_alt,
                                  size: 44,
                                  color: AppColors.teal,
                                ),
                              ),

                              const SizedBox(height: 20),

                              const Text(
                                'Nenhuma tarefa ainda',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                ),
                              ),

                              const SizedBox(height: 8),

                              const Text(
                                'Toque no + para adicionar uma tarefa',
                                style: TextStyle(color: AppColors.slate),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(15),
                          itemCount: tarefasFiltradas.length,
                          itemBuilder: (context, indice) {
                            final tarefa = tarefasFiltradas[indice];
                            final indiceOriginal = tarefas.indexOf(tarefa);

                            return TarefaItem(
                              tarefa: tarefa,
                              aoAlternar: () {
                                alternarTarefa(indiceOriginal);
                              },
                              aoExcluir: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: const Text('Excluir tarefa?'),
                                      content: const Text(
                                        'Tem certeza que deseja excluir esta tarefa?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppColors.prioridadeAlta,
                                          ),
                                          onPressed: () async {
                                            final excluida =
                                                await removerTarefa(indiceOriginal);

                                            if (!context.mounted) return;
                                            Navigator.pop(context);

                                            if (excluida) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'Tarefa excluída!',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text('Excluir'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              aoEditar: () {
                                final controlador = TextEditingController(
                                  text: tarefa.titulo,
                                );

                                DateTime? novaData = tarefa.dataVencimento;
                                Prioridade novaPrioridade = tarefa.prioridade;

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: const Text('Editar tarefa'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: controlador,
                                            autofocus: true,
                                            decoration: const InputDecoration(
                                              hintText: 'Digite o novo nome',
                                            ),
                                          ),

                                          const SizedBox(height: 15),
                                          DropdownButtonFormField<Prioridade>(
                                            initialValue: tarefa.prioridade,
                                            decoration: const InputDecoration(
                                              labelText: 'Prioridade',
                                            ),
                                            items: _itensPrioridade(),
                                            onChanged: (valor) {
                                              if (valor != null) {
                                                tarefa.prioridade = valor;
                                              }
                                            },
                                          ),
                                          const SizedBox(height: 15),

                                          ElevatedButton.icon(
                                            onPressed: () async {
                                              final data = await showDatePicker(
                                                context: context,
                                                initialDate:
                                                    novaData ?? DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime(2030),
                                              );

                                              if (data != null) {
                                                novaData = data;
                                              }
                                            },
                                            icon: const Icon(
                                              Icons.calendar_today,
                                            ),
                                            label: const Text('Alterar data'),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            if (controlador.text
                                                .trim()
                                                .isNotEmpty) {
                                              editarTarefa(
                                                indiceOriginal,
                                                controlador.text.trim(),
                                                novaPrioridade,
                                                novaData,
                                              );

                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text('Salvar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              aoDetalhar: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetalhesTarefaPage(tarefa: tarefa),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final controlador = TextEditingController();

          dataSelecionada = null;

          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: const Text('Nova tarefa'),

                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controlador,
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Digite sua tarefa',
                      ),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<Prioridade>(
                      initialValue: prioridadeSelecionada,
                      decoration: const InputDecoration(
                        labelText: 'Prioridade',
                      ),
                      items: _itensPrioridade(),
                      onChanged: (valor) {
                        if (valor != null) {
                          prioridadeSelecionada = valor;
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final data = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2030),
                        );

                        if (data != null) {
                          setState(() {
                            dataSelecionada = data;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        dataSelecionada == null
                            ? 'Escolher data'
                            : 'Vencimento: ${formatarData(dataSelecionada!)}',
                      ),
                    ),
                  ],
                ),

                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      if (controlador.text.trim().isNotEmpty) {
                        adicionarTarefa(
                          controlador.text.trim(),
                          prioridadeSelecionada,
                          dataSelecionada,
                        );

                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Adicionar'),
                  ),
                ],
              );
            },
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Nova tarefa'),
      ),
    );
  }
}

List<DropdownMenuItem<Prioridade>> _itensPrioridade() {
  return [
    _itemPrioridade(Prioridade.baixa, 'Baixa'),
    _itemPrioridade(Prioridade.media, 'Média'),
    _itemPrioridade(Prioridade.alta, 'Alta'),
  ];
}

DropdownMenuItem<Prioridade> _itemPrioridade(
  Prioridade prioridade,
  String rotulo,
) {
  return DropdownMenuItem(
    value: prioridade,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: corDaPrioridade(prioridade),
          ),
        ),
        const SizedBox(width: 10),
        Text(rotulo),
      ],
    ),
  );
}

class _ResumoCard extends StatelessWidget {
  final String titulo;
  final int valor;
  final Color cor;

  const _ResumoCard({
    required this.titulo,
    required this.valor,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border(top: BorderSide(color: cor, width: 3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$valor',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.slate,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
