import 'package:flutter/cupertino.dart';
import '../screens/calendar_screen.dart';
import '../screens/notes_screen.dart';
import '../screens/todos_screen.dart';

class MyNavigator with ChangeNotifier {
  Widget currentPage = TodosScreen();
  int currentIndex = 1;
  int get index {
    return currentIndex;
  }

  void setCalendar() {
    currentPage = CalendarScreen();
    currentIndex = 0;
    notifyListeners();
  }

  void setTodos() {
    currentPage = TodosScreen();
    currentIndex = 1;
    notifyListeners();
  }

  void setNotes() {
    currentPage = NotesScreen();
    currentIndex = 2;
    notifyListeners();
  }
}
