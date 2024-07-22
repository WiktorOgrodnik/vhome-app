import 'package:vhome_web_api/vhome_web_api.dart';

class VhomeRepository {
  VhomeRepository({
    required TasksetApi tasksetApi,
    required TaskApi taskApi,
  }) : _tasksetApi = tasksetApi, _taskApi = taskApi ;

  final TasksetApi _tasksetApi;
  final TaskApi _taskApi;

  String? _token;

  // Token

  void setToken(String token) {
    _token = token;
  }

  void unsetToken() {
    _token = null;
  }

  String? get getToken => _token;

  // Taskset

  Stream<void> get tasksetsOutdated => _tasksetApi.tasksetOutdated();

  Stream<List<Taskset>> getTasksets() => _tasksetApi.getTasksets(_token!);
  Future<void> addTaskset(String name) => _tasksetApi.addTaskset(_token!, name);
  Future<void> deleteTaskset(Taskset taskset) => _tasksetApi.deleteTaskset(_token!, taskset);

  // Tasks

  Stream<List<Task>> getTasks(int tasksetId) => _taskApi.getTasks(_token!, tasksetId);
  Future<void> toggleTaskCompletion(Task task, bool value) => _taskApi.changeCompleted(_token!, task, value);
  Future<void> addTask(Task task) => _taskApi.add(_token!, task.tasksetId, task.title, task.content);
  Future<void> deleteTask(Task task) => _taskApi.delete(_token!, task);
}
