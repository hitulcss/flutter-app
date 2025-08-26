import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sd_campus_app/api/api.dart';
import 'package:sd_campus_app/api/base_client.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';

class AuthServices {
  Future<dynamic> loginServices(dynamic data) async {
    String? fcmtoken = await FirebaseMessaging.instance.getToken();
    data["fcmToken"] = fcmtoken;
    // print('token:-' + fcmtoken!);
    try {
      dynamic response = await BaseClient.post(url: Apis.baseUrl + Apis.signup, data: data);
      return response.data;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> registerServices(dynamic data) async {
    try {
      dynamic response = await BaseClient.post(url: Apis.baseUrl + Apis.register, data: data);
      return response.data;
    } catch (error) {
      // print(error);
      rethrow;
    }
  }

  Future<dynamic> postGooleAuthNumberServices(dynamic data) async {
    try {
      dynamic response = await BaseClient.post(url: Apis.baseUrl + Apis.postgoolgeaddnumber, data: data);
      return response.data;
    } catch (error) {
      // print(error);
      rethrow;
    }
  }

  Future<dynamic> resendOtpService({required String number, required bool isWhatsapp}) async {
    try {
      String? authToken = SharedPreferenceHelper.getString(Preferences.authtoken);
      String? accessToken = SharedPreferenceHelper.getString(Preferences.accesstoken);
      // print(authToken != 'N/A' ? authToken : accessToken);
      dynamic response = await BaseClient.post(url: Apis.baseUrl + Apis.resendotp, token: authToken != 'N/A' ? authToken : accessToken, data: {
        "user_phone": number,
        if (isWhatsapp) "otpType": "whatsapp"
      });
      return response.data;
    } catch (error) {
      // print(error);
      rethrow;
    }
  }

  Future<dynamic> verifyPhoneNumberService(dynamic data) async {
    String? fcmtoken = await FirebaseMessaging.instance.getToken();
    data["fcmToken"] = fcmtoken;
    // print('fcmtoken:-' + fcmtoken!);
    try {
      String? authToken = SharedPreferenceHelper.getString(Preferences.authtoken);
      dynamic response = await BaseClient.post(url: Apis.baseUrl + Apis.verifyOtp, data: data, token: authToken);
      return response.data;
    } catch (error) {
      // print(error);
      rethrow;
    }
  }

  Future<dynamic> googleAuthService(dynamic data) async {
    String? fcmtoken = await FirebaseMessaging.instance.getToken();
    data["fcmToken"] = fcmtoken;
    // print('token:-' + fcmtoken!);
    try {
      var response = await BaseClient.post(
        url: Apis.baseUrl + Apis.googleAuth,
        data: data,
      );
      return response;
    } catch (error) {
      // print(error);
      rethrow;
    }
  }

  Future<dynamic> updateLanguage(String language) async {
    try {
      var response = await BaseClient.put(
        url: Apis.baseUrl + Apis.updateUserLanguage,
        data: {
          'language': language
        },
      );
      return response;
    } catch (error) {
      // print(error);
      rethrow;
    }
  }

  Future<dynamic> updateStream({required String stream, String? subCategory}) async {
    try {
      var response = await BaseClient.post(
        url: Apis.baseUrl + Apis.updateUserStream,
        data: {
          'category': stream,
          "subCategory": subCategory
        },
      );
      return response;
    } catch (error) {
      // print(error);
    }
  }

  // Future<dynamic> logoutService() async {
  //   try {
  //     dynamic response = await BaseClient.post(url: Apis.baseUrl + Apis.logout);
  //     return response;
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  // Future<dynamic> updateUserDetailsService(
  //     String fullName, String userAddress) async {
  //   try {
  //     dynamic response = await BaseClient.put(
  //       url: Apis.baseUrl + Apis.updateUserProfileInfo,
  //       data: {
  //         "FullName": fullName,
  //         "Useraddress": userAddress,
  //       },
  //     );
  //     return response;
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  // Future<dynamic> updateUserProfilePhotoService(
  //     var fileBytes, String imageName) async {
  //   try {
  //     FormData data = FormData.fromMap({
  //       "file": MultipartFile.fromBytes(fileBytes, filename: imageName),
  //     });
  //     dynamic response = await BaseClient.put(
  //         url: "${Api.baseUrl}${Api.updateUserProfilePhoto}", data: data);
  //     // print(response);
  //     return response;
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  Future<dynamic> requestToLogoutService(dynamic data) async {
    try {
      dynamic response = await BaseClient.post(
        url: Apis.baseUrl + Apis.requestToLogout,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> resetPasswordVerificationService(dynamic data) async {
    try {
      dynamic response = await BaseClient.post(
        url: Apis.baseUrl + Apis.resetPassword,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> resetPasswordVerifyOtpService(dynamic data) async {
    try {
      dynamic response = await BaseClient.post(
        url: Apis.baseUrl + Apis.resetPasswordVerifyOtp,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> resendPasswordVerifyOtpService(dynamic data) async {
    try {
      dynamic response = await BaseClient.post(
        url: Apis.baseUrl + Apis.resendOtp,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getBannerApi() async {
    try {
      dynamic response = await BaseClient.get(
        url: Apis.baseUrl + Apis.banner,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getStreamService() async {
    try {
      dynamic response = await BaseClient.get(url: Apis.baseUrl + Apis.getCategoryStream);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> updatePasswordService(dynamic data) async {
    try {
      // print(data);
      dynamic response = await BaseClient.post(
        url: Apis.baseUrl + Apis.updatePassword,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
