import 'package:dio/dio.dart';
import 'package:sd_campus_app/features/data/remote/models/my_scheduler_model.dart';
import 'package:sd_campus_app/models/classschedule.dart';

abstract class SchedulerRemoteDataSource {
  Future<Response> addSchedule(String task, String date);

  Future<MySchedulerModel> getSchedule();

  Future<Response> deleteScheduler(String id);

  Future<Response> updateScheduler(String id, String task, notifyAt, {bool isActive = false});
  Future<ClassSchedulermodel> getMyClassSchedule();
}
