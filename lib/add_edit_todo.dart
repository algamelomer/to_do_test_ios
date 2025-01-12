import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'todo_model.dart';

class AddEditTodo extends StatefulWidget {
  final Function? updateTodoList;
  final Todo? todo;

  AddEditTodo({this.updateTodoList, this.todo});

  @override
  _AddEditTodoState createState() => _AddEditTodoState();
}

class _AddEditTodoState extends State<AddEditTodo> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _date;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.todo != null) {
      _title = widget.todo!.title;
      _description = widget.todo!.description;
      _date = widget.todo!.date;
      _dateController.text = _dateFormatter.format(DateTime.parse(_date));
    } else {
      _title = '';
      _description = '';
      _date = DateTime.now().toIso8601String(); // Default to today's date in ISO 8601 format
      _dateController.text = _dateFormatter.format(DateTime.now());
    }
  }

  _handleDatePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _date = date.toIso8601String(); // Store date in ISO 8601 format
        _dateController.text = _dateFormatter.format(date); // Format for display
      });
    }
  }

  _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('$_title, $_description, $_date');

      Todo todo = Todo(
        title: _title,
        description: _description,
        date: _date, // Use the ISO 8601 formatted date
      );

      if (widget.todo == null) {
        todo.id = null;
        DatabaseHelper.instance.insert(todo.toMap());
      } else {
        todo.id = widget.todo!.id;
        DatabaseHelper.instance.update(todo.toMap());
      }

      widget.updateTodoList!();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.todo == null ? 'Add Todo' : 'Edit Todo'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _title,
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        validator: (input) => input!.trim().isEmpty
                            ? 'Please enter a title'
                            : null,
                        onSaved: (input) => _title = input!,
                      ),
                      TextFormField(
                        initialValue: _description,
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        validator: (input) => input!.trim().isEmpty
                            ? 'Please enter a description'
                            : null,
                        onSaved: (input) => _description = input!,
                      ),
                      TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: 'Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: _handleDatePicker,
                        readOnly: true,
                      ),
                      SizedBox(height: 40.0),
                      Container(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: _submit,
                          child: Text(
                            widget.todo == null ? 'Add Todo' : 'Update Todo',
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}