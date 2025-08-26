import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:sd_campus_app/api/api.dart';
import 'package:sd_campus_app/features/data/const_data.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/scheduler_data_source/scheduler_remote_data_source.dart';
import 'package:sd_campus_app/features/data/remote/models/my_scheduler_model.dart';
import 'package:sd_campus_app/models/classschedule.dart';

class SchedulerRemoteDataSourceImpl implements SchedulerRemoteDataSource {
  @override
  Future<Response> addSchedule(String task, String date) async {
    try {
      Response response = await dioAuthorizationData().post('${Apis.baseUrl}${Apis.addSchedulardetails}', data: {
        'task': task,
        'notify_at': date
      });
      return response;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<MySchedulerModel> getSchedule() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    final queryParameters = <String, dynamic>{
      "deviceId": androidInfo.id
    };
    try {
      var response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getScheduleDetails}', queryParameters: queryParameters);

      return MySchedulerModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> deleteScheduler(String id) async {
    try {
      // print('${Apis.baseUrl}${Apis.deleteScheduler}$id');
      var response = await dioAuthorizationData().delete('${Apis.baseUrl}${Apis.deleteScheduler}$id');
      return response;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<Response> updateScheduler(String id, String task, notifyAt, {bool isActive = false}) async {
    try {
      Response response = await dioAuthorizationData().put(
        '${Apis.baseUrl}${Apis.updateScheduler}$id',
        data: {
          "task": task,
          "notify_at": notifyAt,
          "is_active": isActive,
        },
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<ClassSchedulermodel> getMyClassSchedule() async {
    try {
      var response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.classScheduler}');
      return ClassSchedulermodel.fromJson(response.data);
    } catch (e) {
      // print(e.toString());
      rethrow;
    }
  }
}
