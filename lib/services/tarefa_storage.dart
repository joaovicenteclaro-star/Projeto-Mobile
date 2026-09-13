import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/tarefa.dart';

/// Responsável por salvar e carregar as tarefas usando o armazenamento
/// local do dispositivo (SharedPreferences).
class TarefaStorage {
  static const _chave = 'tarefas';

  static Future<List<Tarefa>> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final dados = prefs.getString(_chave);

    if (dados == null) {
      return [];
    }

    final lista = jsonDecode(dados) as List;

    return lista
        .map((item) => Tarefa.doMapa(item as Map<String, dynamic>))
        .toList();
  }

  static Future<void> salvar(List<Tarefa> tarefas) async {
    final prefs = await SharedPreferences.getInstance();
    final dados = jsonEncode(tarefas.map((t) => t.paraMapa()).toList());
    await prefs.setString(_chave, dados);
  }
}
