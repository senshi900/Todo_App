import 'package:flutter/material.dart';
import 'package:flutter_supabase/model/todo_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Task> tasks = []; // A list to hold Task objects

  @override
  void initState() {
    super.initState();
    fetchTasks(); // Fetch tasks when the widget is first created
  }

  Future<void> fetchTasks() async {
    final response = await supabase
        .from('tasks')
        .select()
        .order('id')
        .execute();

    if (response == null) {
      print('Error fetching tasks: ${response}');
    } else {
      final List<Task> fetchedTasks = List.from(response.data)
          .map((taskData) => Task.fromMap(taskData))
          .toList();

      setState(() {
        tasks = fetchedTasks;
      });
    }
  }

  Future<void> addTask(String title) async {
    final response = await supabase
        .from('tasks')
        .insert({'title': title, 'is_completed': false})
        .execute();

    if (response!= null) {
      fetchTasks();
    } else {
      print('Error adding task: ${response}');
    }
  }
  Future<void> updatetask(int id,bool iscomplete) async {
    final response = await supabase
        .from('tasks')
        .update({'is_completed': iscomplete}).match({"id":id})
        .execute();

  }
  Future<void> deleteTask(int id) async {
    final response = await supabase
        .from('tasks')
        .delete()
        .match({'id': id})
        .execute();

    if (response != null) {
      fetchTasks();
    } else {
    }
  }

  void _showDialog({String? task, int? index}) {
    TextEditingController _textFieldController =
        TextEditingController(text: task);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(task == null ? 'Add Task' : 'Edit Task'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Type your task here"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(task == null ? 'ADD' : 'UPDATE'),
              onPressed: () async {
                if (task == null) {
                  await addTask(_textFieldController.text);
                } else {
                  // await deleteTask();
                 await addTask(_textFieldController.text);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffd6d7ef),
      appBar: AppBar(
        backgroundColor: Color(0xff9395d3),
        title: Text("TODO APP"),
        actions: [
          IconButton(
            onPressed: () async {
              await supabase.auth.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: tasks.isEmpty
        ? Center(child: Text("You have not Tasks :("))
        : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Container(
                width: double.infinity,
                height: 90,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Checkbox(
                      tristate: true,
                      
                      value: task.isCompleted,
                      onChanged: (bool? value) {
                        setState(() {
                       
                          
 
                        });
                           task.isCompleted=value;
                          updatetask(task.id,task.isCompleted!);
 
                        print(value);
                      },
                      activeColor: Colors.green,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(35),
                        child: Text(
                          task.title,
                          style: TextStyle(color: Color(0xff9395d3)),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Color(0xff9395d3)),
                      onPressed: () {
                        _showDialog(task: task.title, index: index);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Color(0xff9395d3)),
                      onPressed: () {
                        deleteTask(task.id);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialog(index: tasks.length),
        child: Icon(Icons.add),
      ),
    );
  }
}
