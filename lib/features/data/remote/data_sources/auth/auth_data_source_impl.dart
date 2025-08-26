import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sd_campus_app/api/api.dart';
import 'package:sd_campus_app/features/data/const_data.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/auth/auth_data_source.dart';
import 'package:sd_campus_app/features/data/remote/models/stream_model.dart';

class AuthDataSourceImpl implements AuthDataSource {
  //Todo pls check what is the use of this in detail

//Todo pls check what is the use of this in detail

  @override
  // Future<Response> logout() async {
  //   try {
  //     Response response = await dioAuthorizationData().post('${Apis.baseUrl}${Apis.logout}');
  //     return response;
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  @override
  Future<Response> updateUserDetails(String fullName,String email, String userAddress) async {
    try {
      Response response = await dioAuthorizationData().put(
        '${Apis.baseUrl}${Apis.updateUserDetails}',
        data: {
          "FullName": fullName,
          "email":email,
          "Useraddress": userAddress,
        },
      );
      return response;
    } catch (error) {
      rethrow;
    }
  }

  @override
  Future<Response> updateUserProfilePhoto(XFile file) async {
    try {
      FormData data = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
          filename: file.name,
        ),
      });
      Response response = await dioAuthorizationData().put("${Apis.baseUrl}${Apis.updateUserProfilePhoto}", data: data);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<StreamModel> getStream() async {
    try {
      Response response = await dioAuthorizationData().get(Apis.baseUrl + Apis.getCategoryStream);
      StreamModel jsonResponse = StreamModel.fromJson(response.data);
      return jsonResponse;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> accountDelete() async {
    try {
      Response response = await dioAuthorizationData().post(Apis.baseUrl + Apis.deleteaccount);

      return response;
    } catch (error) {
      rethrow;
    }
  }
}
