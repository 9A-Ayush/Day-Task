import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../models/task_model.dart';

class TaskService {
  final SupabaseClient _supabase = SupabaseConfig.client;

  // Create a new task
  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final response = await _supabase
          .from('tasks')
          .insert(task.toJson())
          .select()
          .single();
      
      return TaskModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  // Get all tasks for the current user
  Future<List<TaskModel>> getTasks(String userId) async {
    try {
      final response = await _supabase
          .from('tasks')
          .select()
          .eq('user_id', userId)
          .order('date_time', ascending: true);
      
      return (response as List)
          .map((task) => TaskModel.fromJson(task))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }

  // Get a single task by ID
  Future<TaskModel> getTaskById(String taskId) async {
    try {
      final response = await _supabase
          .from('tasks')
          .select()
          .eq('id', taskId)
          .single();
      
      return TaskModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch task: $e');
    }
  }

  // Update a task
  Future<TaskModel> updateTask(String taskId, TaskModel task) async {
    try {
      final response = await _supabase
          .from('tasks')
          .update(task.toJson())
          .eq('id', taskId)
          .select()
          .single();
      
      return TaskModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  // Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      await _supabase
          .from('tasks')
          .delete()
          .eq('id', taskId);
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  // Stream tasks for real-time updates
  Stream<List<TaskModel>> streamTasks(String userId) {
    return _supabase
        .from('tasks')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('date_time', ascending: true)
        .map((data) => data.map((task) => TaskModel.fromJson(task)).toList());
  }
}
