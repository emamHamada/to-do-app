import 'package:get/get.dart';
import 'package:to_do_app/db/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController {
  final RxList<Task> taskList = <Task>[].obs;

  Future<int> addTask({task}) {
    return DBHelper.insertToDtaBase(task);
  }

 Future<void> getTasks() async {
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }
  Future<void>updateAll({task})async{
    await DBHelper().updateAll(task);
    getTasks();
  }

  void deleteTask(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }
  void deleteAllTasks() async {
    await DBHelper.deleteAll();
    getTasks();
  }

 void updateTasks(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
