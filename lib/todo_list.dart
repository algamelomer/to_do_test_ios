import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'todo_model.dart';
import 'add_edit_todo.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  late Future<List<Todo>> _todoList;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');

  @override
  void initState() {
    super.initState();
    _updateTodoList();
  }

  void _updateTodoList() {
    setState(() {
      _todoList = DatabaseHelper.instance.queryAll().then((maps) {
        return maps.map((map) => Todo.fromMap(map)).toList();
      });
    });
  }

Widget _buildTodo(Todo todo) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 25.0),
    child: Column(
      children: [
        ListTile(
          title: Text(
            todo.title,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            '${_dateFormatter.format(DateTime.parse(todo.date))} - ${todo.description}',
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
          trailing: Checkbox(
            onChanged: (value) {
              // Handle checkbox state
            },
            value: false,
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditTodo(
                updateTodoList: _updateTodoList,
                todo: todo,
              ),
            ),
          ),
        ),
        Divider(),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddEditTodo(
              updateTodoList: _updateTodoList,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _todoList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No To-Do items found.'),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildTodo(snapshot.data![index]);
            },
          );
        },
      ),
    );
  }
}