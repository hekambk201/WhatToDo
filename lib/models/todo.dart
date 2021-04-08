class Task {
  final String id;
  String name;
  bool isDone;
  Task({
    this.id,
    this.name,
    this.isDone,
  });
}

class Todo {
  final String id;
  String name;
  double progress;
  List<Task> tasks;
  Todo({
    this.id,
    this.name,
    this.tasks,
  }) {
    calculateProgress();
  }
  void calculateProgress() {
    int tasksDone = 0;
    if (tasks.length >= 1) {
      tasks.forEach((task) {
        task.isDone == true ? tasksDone++ : tasksDone = tasksDone;
      });

      progress = (tasksDone / tasks.length).toDouble();
    } else
      progress = 0;
  }
}
