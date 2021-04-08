import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:provider/provider.dart';
import '../widgets/taskItem.dart';
import '../models/todo.dart';
import '../constants.dart';
import '../providers/todos.dart';

class TodosScreen extends StatefulWidget {
  @override
  _TodosScreenState createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  @override
  Widget build(BuildContext context) {
    Future<List<Todo>> fetchData() async {
      final response =
          await Provider.of<Todos>(context, listen: false).fetchAndSetTodos();
      return response;
    }

    Future<void> _refresh() async {
      await Provider.of<Todos>(context, listen: false).fetchAndSetTodos();
      setState(() {});
    }

    void _showAddTodo() async {
      final formKey = GlobalKey<FormState>();
      void _submit() {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
        }
      }

      await slideDialog
          .showSlideDialog(
        context: context,
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Text(
                'Add a new To-do List',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width / 15,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.3,
                child: TextFormField(
                  validator: (value) {
                    return value == null || value == ''
                        ? 'Name can not be null'
                        : null;
                  },
                  autofocus: false,
                  decoration: InputDecoration(labelText: 'Name'),
                  onSaved: (input) async {
                    try {
                      await Provider.of<Todos>(context, listen: false)
                          .addTodo(Todo(name: input, tasks: []));
                      setState(() {});
                      Navigator.pop(context, 'success');
                    } catch (error) {
                      print('error is $error');
                      Navigator.pop(context, 'error');
                    }
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FloatingActionButton.extended(
                backgroundColor: kPrimaryColor,
                label: Row(
                  children: <Widget>[
                    Icon(
                      FontAwesomeIcons.plus,
                      size: 22,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('Add List')
                  ],
                ),
                onPressed: _submit,
              )
            ],
          ),
        ),
      )
          .then((value) async {
        setState(() {});
        if (value == 'success') {
          await Provider.of<Todos>(context, listen: false).fetchAndSetTodos();
          AwesomeDialog(
            context: context,
            headerAnimationLoop: true,
            dialogType: DialogType.SUCCES,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Success!',
            desc: 'To-do List was added successfully!',
          ).show();
        } else if (value == 'error') {
          AwesomeDialog(
            context: context,
            headerAnimationLoop: true,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'ERROR!',
            desc: 'There was an error creating your new To-do List.',
          ).show();
        }
      });
    }

    void _showEditTodo(Todo currentTodo) async {
      final formKey = GlobalKey<FormState>();
      void _submit() {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
        }
      }

      await slideDialog
          .showSlideDialog(
              context: context,
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Edit List name',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 15,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: TextFormField(
                        initialValue: currentTodo.name,
                        validator: (value) {
                          return value == null || value == ''
                              ? 'Name can not be null'
                              : null;
                        },
                        autofocus: false,
                        decoration: InputDecoration(labelText: 'Name'),
                        onSaved: (input) async {
                          try {
                            await Provider.of<Todos>(context, listen: false)
                                .editTodo(currentTodo.id, input);
                            Navigator.pop(context, 'success');
                          } catch (error) {
                            print('error is $error');
                            Navigator.pop(context, 'error');
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FloatingActionButton.extended(
                      backgroundColor: kPrimaryColor,
                      label: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.save,
                            size: 22,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text('Save Changes')
                        ],
                      ),
                      onPressed: _submit,
                    )
                  ],
                ),
              ))
          .then((value) async {
        setState(() {});
        if (value == 'success') {
          await Provider.of<Todos>(context, listen: false).fetchAndSetTodos();
          AwesomeDialog(
            context: context,
            headerAnimationLoop: true,
            dialogType: DialogType.SUCCES,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Success!',
            desc: 'To-do List was updated successfully!',
          ).show();
        } else if (value == 'error') {
          AwesomeDialog(
            context: context,
            headerAnimationLoop: true,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'ERROR!',
            desc: 'There was an error updating your new To-do List.',
          ).show();
        }
      });
    }

    void _showAddTask(Todo currentTodo) async {
      final formKey = GlobalKey<FormState>();
      void _submit() {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
        }
      }

      await slideDialog
          .showSlideDialog(
              context: context,
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Add a new task',
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width / 15,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: TextFormField(
                        validator: (value) {
                          return value == null || value == ''
                              ? 'Name can not be null'
                              : null;
                        },
                        autofocus: false,
                        decoration: InputDecoration(labelText: 'Name'),
                        onSaved: (input) async {
                          try {
                            await Provider.of<Todos>(context, listen: false)
                                .addTask(currentTodo.id, input);
                            Navigator.pop(context, 'success');
                          } catch (error) {
                            print('error is $error');
                            Navigator.pop(context, 'error');
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FloatingActionButton.extended(
                      backgroundColor: kPrimaryColor,
                      label: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.plus,
                            size: 22,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text('Add Task')
                        ],
                      ),
                      onPressed: _submit,
                    )
                  ],
                ),
              ))
          .then((value) async {
        setState(() {});
        if (value == 'success') {
          await Provider.of<Todos>(context, listen: false).fetchAndSetTodos();
          AwesomeDialog(
            context: context,
            headerAnimationLoop: true,
            dialogType: DialogType.SUCCES,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Success!',
            desc: 'Task was added successfully!',
          ).show();
        } else if (value == 'error') {
          AwesomeDialog(
            context: context,
            headerAnimationLoop: true,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'ERROR!',
            desc: 'There was an error creating your new task.',
          ).show();
        }
      });
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodo,
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            List<Todo> todos = snapshot.data;
            return todos == null
                ? Center(
                    child: SpinKitFoldingCube(
                      color: kPrimaryColor,
                      size: MediaQuery.of(context).size.width / 15,
                    ),
                  )
                : Container(
                    child: todos.length == 0
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  'assets/images/empty-todo.png',
                                  height:
                                      MediaQuery.of(context).size.height / 3,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'You don\'t have any to-do lists yet!',
                                  style: TextStyle(
                                      color: kPrimaryColor.withOpacity(.7),
                                      fontStyle: FontStyle.italic,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              20),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _refresh,
                            child: Consumer<Todos>(
                                builder: (context, value, child) {
                              // var todos = value.allTodos;
                              return ListView.separated(
                                separatorBuilder: (context, index) => Divider(
                                  color: kPrimaryColor,
                                  thickness: .5,
                                ),
                                itemCount:
                                    todos.length != null ? todos.length : 0,
                                itemBuilder: (context, index) => Container(
                                  child: ExpansionTile(
                                    backgroundColor:
                                        kPrimaryColor.withOpacity(.2),
                                    initiallyExpanded: false,
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          todos[index].name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: kSecondaryColor),
                                        ),
                                        Consumer<Todos>(
                                          builder: (context, todoProvider, _) =>
                                              CircularPercentIndicator(
                                            center: Text(
                                              '${(todoProvider.allTodos[index].progress * 100).round()}',
                                              style: TextStyle(
                                                  color: kSecondaryColor,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            radius: 40,
                                            percent: todos[index].progress,
                                            progressColor: kPrimaryColor,
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            IconButton(
                                              icon: Icon(
                                                Icons.add,
                                                color: kPrimaryColor,
                                              ),
                                              onPressed: () =>
                                                  _showAddTask(todos[index]),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.edit,
                                                color: kLightColor,
                                              ),
                                              onPressed: () =>
                                                  _showEditTodo(todos[index]),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.redAccent,
                                              ),
                                              onPressed: () async {
                                                await AwesomeDialog(
                                                    context: context,
                                                    headerAnimationLoop: false,
                                                    dialogType:
                                                        DialogType.WARNING,
                                                    animType: AnimType.TOPSLIDE,
                                                    btnOkText: 'Yes',
                                                    btnCancelText: 'No',
                                                    title: 'Are you sure?',
                                                    desc:
                                                        'Are you sure that you want to delete this List?',
                                                    btnCancelOnPress: () {},
                                                    btnOkOnPress: () async {
                                                      try {
                                                        await Provider.of<
                                                                    Todos>(
                                                                context,
                                                                listen: false)
                                                            .deleteTodo(
                                                                todos[index]
                                                                    .id);
                                                      } catch (error) {
                                                        return 'error';
                                                      }

                                                      return 'success';
                                                    }).show();
                                              },
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    children: todos[index].tasks.length == 0 ||
                                            todos[index].tasks.length == null
                                        ? [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  200,
                                            ),
                                            Text(
                                              'You have no tasks in this list yet!',
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          25,
                                                  color: kSecondaryColor,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  40,
                                            ),
                                          ]
                                        : <Widget>[
                                            Consumer<Todos>(
                                                builder: (context, value,
                                                        child) =>
                                                    TaskItem(
                                                        value.allTodos[index]))
                                          ],
                                  ),
                                ),
                              );
                            }),
                          ),
                  );
          }),
    );
  }
}
