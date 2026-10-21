import 'dart:convert';
import 'http/http.dart' as http; // adicione a dependência 'http' no pubspec.yaml

class TarefaApiService {
  static const String baseUrl = 'http://SEU_IP_OU_LOCALHOST:5000/api/tarefas';

  static Future<List<Tarefa>> listar() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List lista = jsonDecode(response.body);
      return lista.map((json) => Tarefa.deApi(json)).toList();
    }
    throw Exception('Erro ao carregar tarefas');
  }

  static Future<Tarefa> criar(Tarefa tarefa) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tarefa.paraApi()),
    );
    if (response.statusCode == 201) {
      return Tarefa.deApi(jsonDecode(response.body));
    }
    throw Exception('Erro ao criar tarefa');
  }

  static Future<void> atualizar(Tarefa tarefa) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${tarefa.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(tarefa.paraApi()),
    );
    if (response.statusCode != 204) {
      throw Exception('Erro ao atualizar tarefa');
    }
  }

  static Future<void> excluir(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Erro ao excluir tarefa');
    }
  }
}