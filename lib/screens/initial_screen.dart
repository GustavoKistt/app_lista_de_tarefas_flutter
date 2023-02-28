import 'package:flutter/material.dart';
import 'package:lista_de_tarefas_app/data/task_dao.dart';
import 'package:lista_de_tarefas_app/screens/form_screen.dart';
import '../components/task.dart';
import '../data/task_inherited.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          IconButton(onPressed: (){
            setState(() {
            });
          }, icon: Icon(Icons.refresh))
        ],
        title: const Text('Tarefas'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 8, bottom: 70),
        child: FutureBuilder<List<Task>>(
            future: TaskDao().findAll(),
            builder: (context, snapshot) {
              List<Task>? items = snapshot.data;
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(
                    child: Column(children: [CircularProgressIndicator(),
                    Text("Carregando"),],),);
              break;
              case ConnectionState.waiting:
              return Center(
              child: Column(children: [CircularProgressIndicator(),
              Text("waiting"),],),);
              break;
              case ConnectionState.active:
              return Center(
              child: Column(children: [CircularProgressIndicator(),
              Text("active"),],),);
              break;
              case ConnectionState.done:
              if (snapshot.hasData && items != null) {
              if (items.isNotEmpty) {
              return ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
              final Task tarefa = items[index];
              return tarefa;
              });
              }
              return Center(child: Column(
              children: [Icon(Icons.error_outline, size: 128),
              Text("Não há nenhuma Tarefa",
              style: TextStyle(fontSize: 32),)
              ],),
              );
              }
              return Text('Erro ao carregar Tarefas');
              break;
              }
              return Text('Erro Desconhecido');
              }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (contextNew) =>
                  FormScreen(
                    taskContext: context,
                  ),
            ),
          ).then((value) => setState((){
            print("Recarregando tela inicial");
          }));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
