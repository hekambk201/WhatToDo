import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:slide_popup_dialog/slide_popup_dialog.dart' as slideDialog;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/todo.dart';
import '../providers/todos.dart';

import '../constants.dart';

class TaskItem extends StatelessWidget {
  final Todo todo;
  TaskItem(this.todo);

  Widget build(BuildContext context) {
    void _showEditTask(Todo currentTodo, Task currentTask) async {
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
                      'Edit Task name',
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
                        initialValue: currentTask.name,
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
                                .editask(currentTodo.id, currentTask.id, input);
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
        if (value == 'success') {
          await Provider.of<Todos>(context, listen: false).fetchAndSetTodos();
          AwesomeDialog(
            context: context,
            headerAnimationLoop: true,
            dialogType: DialogType.SUCCES,
            animType: AnimType.BOTTOMSLIDE,
            title: 'Success!',
            desc: 'Task name was updated successfully!',
          ).show();
        } else if (value == 'error') {
          AwesomeDialog(
            context: context,
            headerAnimationLoop: true,
            dialogType: DialogType.ERROR,
            animType: AnimType.BOTTOMSLIDE,
            title: 'ERROR!',
            desc: 'There was an error updating your task name.',
          ).show();
        }
      });
    }

    return Container(
      height: (MediaQuery.of(context).size.height / 10) * todo.tasks.length,
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: todo.tasks.length != null ? todo.tasks.length : 0,
        itemBuilder: (context, i) {
          var slidable = Slidable(
              child: ListTile(
                title: Text(
                  todo.tasks[i].name,
                  style: TextStyle(
                      color: todo.tasks[i].isDone ? Colors.grey : kLightColor,
                      fontWeight: todo.tasks[i].isDone
                          ? FontWeight.w400
                          : FontWeight.w600,
                      fontStyle: todo.tasks[i].isDone
                          ? FontStyle.italic
                          : FontStyle.normal,
                      decoration: todo.tasks[i].isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
                trailing: Consumer<Todos>(
                  builder: (context, todosProv, _) => IconButton(
                      icon: Icon(
                        todo.tasks[i].isDone
                            ? Icons.check_circle
                            : Icons.check_circle_outline,
                        color: kSecondaryColor,
                      ),
                      onPressed: () async {
                        await todosProv.toggleIsDoneStatus(
                            todo.id, todo.tasks[i].id);
                      }),
                ),
              ),
              actionPane: SlidableDrawerActionPane(),
              actions: <Widget>[
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.redAccent,
                  icon: Icons.delete,
                  onTap: () async {
                    await AwesomeDialog(
                        context: context,
                        headerAnimationLoop: false,
                        dialogType: DialogType.WARNING,
                        animType: AnimType.TOPSLIDE,
                        btnOkText: 'Yes',
                        btnCancelText: 'No',
                        title: 'Are you sure?',
                        desc:
                            'Are you sure that you want to delete ${todo.tasks[i].name}',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () async {
                          try {
                            await Provider.of<Todos>(context, listen: false)
                                .deleteTask(todo.id, todo.tasks[i].id);
                          } catch (error) {
                            return 'error';
                          }

                          return 'success';
                        }).show();
                  },
                ),
                IconSlideAction(
                  caption: 'Edit',
                  color: kLightColor,
                  icon: Icons.edit,
                  onTap: () => _showEditTask(todo, todo.tasks[i]),
                ),
              ]);
          return slidable;
        },
      ),
    );
  }
}
