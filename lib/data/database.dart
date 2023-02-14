
import 'package:lista_de_tarefas_app/data/task_dao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> getDataBase() async {
  final String path =
      join(await getDatabasesPath(), 'task.db'); //caminho do banco de dados

  return openDatabase(path, onCreate: (db, version) {
    //cria o banco de dados, caso não tenha o banco de dados, ele cria.
    db.execute(TaskDao.tableSql);
  }, version: 1);



}
