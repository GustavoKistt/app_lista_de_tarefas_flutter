import 'package:lista_de_tarefas_app/data/database.dart';
import 'package:sqflite/sqflite.dart';

import '../components/task.dart';

class TaskDao {
  static String tableSql = 'CREATE TABLE $_tablename('
      '$_name TEXT, '
      '$_difficulty INTEGER, '
      '$_image TEXT)';

  static const String _tablename = "taskTable";
  static const String _name = "name";
  static const String _difficulty = "difficulty";
  static const String _image = "image";

  //Salva a tarefa no BD, Verifica se ela ja existe
  save(Task tarefa) async {
    print('Iniciando o Save: ');
    final Database bancoDeDados = await getDataBase();
    var itemExists = await find(tarefa.nome);
    Map<String, dynamic> taskMap = toMap(tarefa);
    if (itemExists.isEmpty) {
      print('A tarefa não existia.');
      return await bancoDeDados.insert(_tablename, taskMap);
    } else {
      print("A tarefa já existia!");
      return await bancoDeDados.update(_tablename, taskMap,
          where: '$_name = ?', whereArgs: [tarefa.nome]);
    }
  }

  //Transforma lista de Tarefas em MAPA para colocar no BD
  Map<String, dynamic> toMap(Task tarefa) {
    print("Convertendo Tarefa em Map: ");
    final Map<String, dynamic> mapaDeTarefas = Map();
    mapaDeTarefas[_name] = tarefa.nome;
    mapaDeTarefas[_difficulty] = tarefa.dificuldade;
    mapaDeTarefas[_image] = tarefa.foto;
    print('Mapa de Tarefas: $mapaDeTarefas');
    return mapaDeTarefas;
  }

  //Busca todas as terefas no BD, e transforma em lista de tarefas
  Future<List<Task>> findAll() async {
    print("estamos acessando o find all: ");
    final Database bancoDeDados = await getDataBase();
    final List<Map<String, dynamic>> result =
        await bancoDeDados.query(_tablename);
    print("procurando dados no db ... encontrado: $result");
    return toList(result);
  }

  //Transforma Map em lista de tarefas
  List<Task> toList(List<Map<String, dynamic>> mapaDeTarefas) {
    print('Convertendo to List');
    final List<Task> tarefas = [];
    for (Map<String, dynamic> linha in mapaDeTarefas) {
      final Task tarefa = Task(linha[_name], linha[_image], linha[_difficulty]);
      tarefas.add(tarefa);
    }
    print(' Lista de Tarefas $tarefas');
    return tarefas;
  }

  //Busca Tarefa especifica no BD
  Future<List<Task>> find(String nomeDaTarefa) async {
    print('Acessando find: ');
    final Database bancoDeDados = await getDataBase(); //abre o banco de dados
    final List<Map<String, dynamic>> result = await bancoDeDados
        .query(_tablename, where: '$_name = ?', whereArgs: [nomeDaTarefa]);
    print('Tarefa encontrada: ${toList(result)}');
    return toList(result);
  }

  //Deleta uma tarefa
  delete(String nomeDaTarefa) async {
    print('Deletando Tarefa: $nomeDaTarefa');
    final Database bancoDeDados = await getDataBase();
    return bancoDeDados.delete(
      _tablename,
      where: '$_name = ?',
      whereArgs: [nomeDaTarefa],
    );
  }
}
