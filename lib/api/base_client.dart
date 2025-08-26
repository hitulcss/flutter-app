import 'package:dio/dio.dart';
import 'package:sd_campus_app/api/app_exception.dart';
import 'package:sd_campus_app/features/data/remote/models/base_model.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';

Dio dioAuthorizationData({String? token}) {
  if (token == 'N/A') token = null;
  var localToken = SharedPreferenceHelper.getString(Preferences.accesstoken);
  final dio = Dio();
  dio.options.headers['Content-Type'] = "application/x-www-form-urlencoded";
  dio.options.headers["Accept"] = "application/json"; // config your dio headers globally
  dio.options.followRedirects = false;
  dio.options.connectTimeout = const Duration(seconds: 10); //5s
  dio.options.receiveTimeout = const Duration(seconds: 10);
  // print('token in = ${token ?? localToken}');
  dio.options.headers["Authorization"] = "Bearer ${token ?? localToken}";
  return dio;
}

class BaseClient {
  static Future<dynamic> get({required String url, String? token, dynamic queryParameters}) async {
    try {
      final response = await dioAuthorizationData(token: token).get(url, queryParameters: queryParameters).timeout(const Duration(seconds: 10));
      return response.data;
    } on DioException catch (error) {
      throw dioError(error.type, error);
    }
  }

  static Future<dynamic> post({required String url, dynamic data, String? token}) async {
    try {
      final response = await dioAuthorizationData(token: token).post(url, data: data).timeout(const Duration(seconds: 10));
      return response;
    } on DioException catch (error) {
      //print(error.type.toString());
      throw dioError(error.type, error);
    }
  }

  static Future<dynamic> put({required String url, dynamic data}) async {
    try {
      final response = await dioAuthorizationData().put(url, data: data).timeout(const Duration(seconds: 10));
      return response.data;
    } on DioException catch (error) {
      // print(error.type.toString());
      throw dioError(error.type, error);
    }
  }

  static Future<dynamic> delete({required String url}) async {
    try {
      final response = await dioAuthorizationData().delete(url).timeout(const Duration(seconds: 10));
      return response;
    } on DioException catch (error) {
      // print(error.type.toString());
      throw dioError(error.type, error);
    }
  }

  //Dio Error handling
  static dynamic dioError(DioExceptionType errorType, DioException error) {
    switch (errorType) {
      case DioExceptionType.connectionTimeout:
        throw FetchDataException(message: 'No Internet Connection');

      case DioExceptionType.sendTimeout:
        throw FetchDataException(message: "Send Time Out");

      case DioExceptionType.receiveTimeout:
        throw FetchDataException(message: "Receive Time Out");

      case DioExceptionType.connectionError:
        throw returnResponse(error.response ??
            Response<dynamic>(data: {
              "status": false,
              "msg": "No Internet Connection"
            }, requestOptions: RequestOptions(path: '')));

      case DioExceptionType.cancel:
        throw FetchDataException(message: "Cancel Request");

      default:
        throw FetchDataException(message: errorType.name);
    }
  }

  //User defined error
  static dynamic returnResponse(Response<dynamic> response) {
    // print("------- Return response http base client -------");
    // print(response.data);
    BaseModel responseBody = BaseModel.fromJson(response.data);
    switch (response.statusCode) {
      case 400:
        throw BadRequestException(message: responseBody.msg);
      case 404:
        throw UnauthorisedException(message: responseBody.msg);
      case 401:
        throw FetchDataException(message: responseBody.msg.isNotEmpty ? responseBody.msg : 'Something went wrong');
      default:
        throw FetchDataException(message: 'Error occurred while communicating with server with status code ${responseBody.msg}');
    }
  }
}
