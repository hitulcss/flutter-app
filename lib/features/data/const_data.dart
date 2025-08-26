import 'package:dio/dio.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';

Dio dioAuthorizationData() {
  var token = SharedPreferenceHelper.getString(Preferences.accesstoken);
  final dio = Dio();
  dio.options.headers["Accept"] = "application/json"; // config your dio headers globally
  dio.options.followRedirects = false;
  dio.options.connectTimeout = const Duration(seconds: 30); //5s
  dio.options.receiveTimeout = const Duration(seconds: 30);
  // print('token in = $token');
  dio.options.headers["Authorization"] = "Bearer $token";
  return dio;
}
