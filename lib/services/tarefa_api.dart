
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/tarefa.dart';

class TarefaApi {
  static const String _url =
      'http://10.0.2.2:5000/api/tarefas';

  static Future<List<Tarefa>> listar() async {
    final resposta = await http
        .get(Uri.parse(_url))
        .timeout(const Duration(seconds: 15));

    if (resposta.statusCode != 200) {
      throw Exception('Erro ao listar tarefas: ${resposta.statusCode}');
    }

    final lista = jsonDecode(resposta.body) as List<dynamic>;

    return lista
        .map((item) => Tarefa.deApi(item as Map<String, dynamic>))
        .toList();
  }

  static Future<Tarefa> criar(Tarefa tarefa) async {
    final resposta = await http
        .post(
          Uri.parse(_url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(tarefa.paraApi()),
        )
        .timeout(const Duration(seconds: 15));

    if (resposta.statusCode != 201) {
      throw Exception('Erro ao criar tarefa: ${resposta.statusCode}');
    }

    return Tarefa.deApi(
      jsonDecode(resposta.body) as Map<String, dynamic>,
    );
  }

  static Future<void> atualizar(Tarefa tarefa) async {
    final id = tarefa.id;
    if (id == null) {
      throw Exception('A tarefa não possui ID no banco.');
    }

    final resposta = await http
        .put(
          Uri.parse('$_url/$id'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(tarefa.paraApi()),
        )
        .timeout(const Duration(seconds: 15));

    if (resposta.statusCode != 204) {
      throw Exception('Erro ao atualizar tarefa: ${resposta.statusCode}');
    }
  }

  static Future<void> excluir(int id) async {
    final resposta = await http
        .delete(Uri.parse('$_url/$id'))
        .timeout(const Duration(seconds: 15));

    if (resposta.statusCode != 204) {
      throw Exception('Erro ao excluir tarefa: ${resposta.statusCode}');
    }
  }
}
