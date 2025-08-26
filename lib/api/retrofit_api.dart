import 'package:dio/dio.dart';


class RetroApi {
   Dio dioData(String token) {
    final dio = Dio();
    // String? token;
    // var t = SharedPreferenceHelper.read(Preferences.auth_token).then((value) {
    //   token = value;
    // });
    // print('*' * 200 + 'out');
    // print('$token  =token');
    dio.options.headers["Accept"] =
        "application/json"; // config your dio headers globally
    //dio.options.headers['Content-Type'] = "application/x-www-form-urlencoded";
    dio.options.followRedirects = false;
    dio.options.connectTimeout = const Duration(seconds: 10); //5s
    dio.options.receiveTimeout = const Duration(seconds: 10);
    // print('token in =$token');
    dio.options.headers["Authorization"] = "Bearer $token";
    return dio;
  }
}

class RetroApi2 {
  Dio dioData2() {
    final dio = Dio();
    dio.options.headers["Accept"] =
        "application/json"; // config your dio headers globally
    //dio.options.headers['Content-Type'] = "application/x-www-form-urlencoded";
    dio.options.followRedirects = false;
    dio.options.connectTimeout = const Duration(seconds: 10); //5s
    dio.options.receiveTimeout = const Duration(seconds: 10);
    return dio;
  }
}
