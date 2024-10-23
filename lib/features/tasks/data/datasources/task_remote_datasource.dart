import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/app_strings.dart';
import '../models/task_model.dart';

class TasksRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String tasksCollection = 'tasks';

  String? get currentUserId => _auth.currentUser?.uid;

  Future<List<TaskModel>> getPaginatedTasks(
      int limit, String? lastDocumentId) async {
    var query = _firestore
        .collection(tasksCollection)
        .where('userId', isEqualTo: currentUserId)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDocumentId != null) {
      final lastDocSnapshot = await _firestore
          .collection(tasksCollection)
          .doc(lastDocumentId)
          .get();
      query = query.startAfterDocument(lastDocSnapshot);
    }

    final querySnapshot = await query.get();
    return querySnapshot.docs
        .map((doc) => TaskModel.fromMap(doc.data()))
        .toList();
  }

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

  Future<void> updateTask(TaskModel task) async {
    if (currentUserId == null) {
      throw Exception(AppStrings.userNotAuthenticated);
    }

    final taskDoc =
        await _firestore.collection(tasksCollection).doc(task.id).get();

    if (taskDoc.exists && taskDoc.data()?['userId'] == currentUserId) {
      await _firestore
          .collection(tasksCollection)
          .doc(task.id)
          .update(task.toMap());
    } else {
      throw Exception(AppStrings.taskNotFound);
    }
  }

  Future<void> deleteTask(String taskId) async {
    if (currentUserId == null) {
      throw Exception(AppStrings.userNotAuthenticated);
    }

    final taskDoc =
        await _firestore.collection(tasksCollection).doc(taskId).get();

    if (taskDoc.exists && taskDoc.data()?['userId'] == currentUserId) {
      await _firestore.collection(tasksCollection).doc(taskId).delete();
    } else {
      throw Exception(AppStrings.taskNotFound);
    }
  }
}
