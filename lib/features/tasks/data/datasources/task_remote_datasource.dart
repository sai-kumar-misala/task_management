import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/app_strings.dart';
import '../models/task_model.dart';

class TasksRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String tasksCollection = 'tasks';

  String? get currentUserId => _auth.currentUser?.uid;

  Future<void> createTask(TaskModel task) async {
    if (currentUserId == null) {
      throw Exception(AppStrings.userNotAuthenticated);
    }

    final taskWithUser = TaskModel(
      id: task.id,
      userId: currentUserId!,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      status: task.status,
    );

    await _firestore
        .collection(tasksCollection)
        .doc(task.id)
        .set(taskWithUser.toMap());
  }

  Stream<List<TaskModel>> getTasks() {
    if (currentUserId == null) {
      throw Exception(AppStrings.userNotAuthenticated);
    }

    return _firestore
        .collection(tasksCollection)
        .where('userId', isEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => TaskModel.fromMap(doc.data())).toList();
    });
  }

  Stream<TaskModel?> getTaskById(String taskId) {
    final user = _auth.currentUser;
    if (user == null) throw Exception(AppStrings.userNotAuthenticated);

    return _firestore.collection('tasks').doc(taskId).snapshots().map((doc) {
      if (!doc.exists) return null;
      final data = doc.data();
      if (data == null) return null;
      if (data['userId'] != user.uid) {
        throw Exception(AppStrings.userNotAuthenticated);
      }
      return TaskModel.fromMap(data);
    });
  }
}
