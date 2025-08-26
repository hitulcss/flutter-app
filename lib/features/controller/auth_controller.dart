// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart' as googleauth;
import 'package:sd_campus_app/features/data/remote/models/base_model.dart';
import 'package:sd_campus_app/features/data/remote/models/google_auth_model.dart';
import 'package:sd_campus_app/features/data/remote/models/login_model.dart';
import 'package:sd_campus_app/features/data/remote/models/stream_model.dart';
import 'package:sd_campus_app/features/data/remote/models/verified_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/features/services/remote_services/auth_services.dart';
import 'package:sd_campus_app/models/banner.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';

class AuthController {
  AuthServices authServices = AuthServices();

  Future<LoginModel> login(dynamic data) async {
    try {
      var response = await authServices.loginServices(data);
      BaseModel baseResponse = BaseModel.fromJson(response);
      LoginModel user = LoginModel.fromJson(response);
      if (baseResponse.status) {
        await SharedPreferenceHelper.setString(Preferences.accesstoken, user.data!.refreshToken);
        // await SharedPreferenceHelper.setString(Preferences.name, user.data.fullName);
        // await SharedPreferenceHelper.setString(Preferences.email, user.data.email);
        // await SharedPreferenceHelper.setString(Preferences.phoneNUmber, user.data.phoneNumber);
        // await SharedPreferenceHelper.setString(Preferences.language, user.data.language);
        // Languages.isEnglish = user.data.language == "hi" ? false : true;
        // await SharedPreferenceHelper.setString(Preferences.profileImage, user.data.profilePhoto);
        // await SharedPreferenceHelper.setString(Preferences.address, user.data.address);
        // await SharedPreferenceHelper.setString(Preferences.enrollId, user.data.enrollId);
        // SharedPreferenceHelper.setStringList(Preferences.course, user.data.stream);
        // SharedPreferenceHelper.setString(Preferences.myReferralCode, user.data.myReferralCode);
        // if (user.data.mobileVerified) {
        //   await SharedPreferenceHelper.setBoolean(Preferences.isloggedin, true);
        // }
        user.msg!.isNotEmpty ? flutterToast(user.msg!) : print('empty');
      } else {
        // if (baseResponse.msg == 'google_signin') {
        //You have Already registered with Google,Please signIn with Google
        // flutterToast('registered with Google, Please signIn with Google');
        // } else {
        flutterToast(baseResponse.msg);
        // }
      }
      return user;
    } catch (error) {
      // print(error);
      error.toString().contains('Communication') ? flutterToast(error.toString().split('Communication')[1]) : flutterToast(error.toString());
      rethrow;
    }
  }

  Future<BaseModel> register(dynamic data) async {
    try {
      dynamic response = await authServices.registerServices(data);
      BaseModel user = BaseModel.fromJson(response);
      if (user.status) {
        await SharedPreferenceHelper.setString(Preferences.email, user.data['email']);
        await SharedPreferenceHelper.setString(Preferences.authtoken, user.data['token']);
        await SharedPreferenceHelper.setString(Preferences.myReferralCode, user.data['myReferralCode']);
        //flutterToast(user.data['mobileNumberVerificationOTP'].toString());
      }
      user.msg.isNotEmpty ? flutterToast(user.msg) : print('empty');
      return user;
    } catch (error) {
      flutterToast(error.toString());
      rethrow;
    }
  }

  Future<bool> postGoolglAuthNumber(dynamic number) async {
    dynamic data = {
      "userMobileNumber": number
    };
    try {
      dynamic response = await authServices.postGooleAuthNumberServices(data);
      // print(response);
      BaseModel user = BaseModel.fromJson(response);
      if (user.status) {
        SharedPreferenceHelper.setString(Preferences.phoneNUmber, number.toString());
        //flutterToast(user.data[0]['mobileNumberVerificationOTP'].toString());
      }
      user.msg.isNotEmpty ? flutterToast(user.msg) : print('empty');
      return user.status;
    } catch (error) {
      // print(error.toString());
      flutterToast(error.toString());
      return false;
    }
  }

  Future<bool> resendOtp({required String number,required bool isWhatsapp}) async {
    try {
      dynamic responseJson = await authServices.resendOtpService(number: number, isWhatsapp: isWhatsapp);
      print(responseJson);
      BaseModel response = BaseModel.fromJson(responseJson);
      if (response.status) {
        //flutterToast(response.data['mobileNumberVerificationOTP'].toString());
      }
      flutterToast(response.msg);
      return response.status;
    } catch (error) {
      flutterToast(error.toString());
      rethrow;
    }
  }

  Future<VerifedModel> verifyPhoneNumber(dynamic data) async {
    try {
      dynamic responseJson = await authServices.verifyPhoneNumberService(data);
      // print(responseJson);

      BaseModel response = BaseModel.fromJson(responseJson);
      VerifedModel verifedModel = VerifedModel.fromJson(responseJson);
      if (response.status) {
        await SharedPreferenceHelper.setBoolean(Preferences.isloggedin, true);
        SharedPreferenceHelper.setString(Preferences.userid, verifedModel.data!.id);
        SharedPreferenceHelper.setString(Preferences.accesstoken, verifedModel.data!.token);
        SharedPreferenceHelper.setString(Preferences.enrollId, verifedModel.data!.enrollId);
        await SharedPreferenceHelper.setString(Preferences.name, verifedModel.data!.name);
        SharedPreferenceHelper.setBoolean(Preferences.isnewUser, verifedModel.data!.isNew!);
        SharedPreferenceHelper.setBoolean(Preferences.isNameAdded, verifedModel.data!.name == "Name" ? false : true);
        SharedPreferenceHelper.setBoolean(Preferences.isStreamAdded, verifedModel.data!.stream!.isEmpty ? false : true);
        await SharedPreferenceHelper.setString(Preferences.email, verifedModel.data!.email);
        await SharedPreferenceHelper.setString(Preferences.phoneNUmber, verifedModel.data!.mobileNumber);
        await SharedPreferenceHelper.setString(Preferences.language, verifedModel.data!.language);
        // Languages.isEnglish = verifedModel.data!.language == "hi" ? false : true;
        await SharedPreferenceHelper.setString(Preferences.profileImage, verifedModel.data!.profilePhoto);
        await SharedPreferenceHelper.setString(Preferences.address, verifedModel.data!.address);
        // await SharedPreferenceHelper.setString(Preferences.enrollId, user.data.enrollId);
        SharedPreferenceHelper.setStringList(Preferences.course, verifedModel.data!.stream!);
        SharedPreferenceHelper.setString(Preferences.myReferralCode, verifedModel.data?.myReferralCode);
        SharedPreferenceHelper.setBoolean(Preferences.isVerified, verifedModel.data?.isVerified ?? false);
        SharedPreferenceHelper.setString(Preferences.selectedStream, verifedModel.data?.currentCategory?.title);
      }
      flutterToast(response.msg);
      return verifedModel;
    } catch (error) {
      flutterToast(error.toString());
      rethrow;
    }
  }

  Future<GoogleAuthRespose> googleAuth() async {
    try {
      String email = "";
      googleauth.GoogleSignInAccount? result;
      final googleSignIn = googleauth.GoogleSignIn();
      result = await googleSignIn.signIn();
      print('----------------------------------------------');
      print(result);
      email = result?.email ?? '';
      // print(result!.email);
      await googleSignIn.signOut();
      //await _googleSignIn.disconnect();
      if (result?.email.isNotEmpty ?? false) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo? androidDeviceInfo;
        IosDeviceInfo? iOSDeviceInfo;
        if (Platform.isAndroid) {
          androidDeviceInfo = await deviceInfo.androidInfo;
        } else if (Platform.isIOS) {
          iOSDeviceInfo = await deviceInfo.iosInfo;
        }
        // print('----------------------------------------------');
        dynamic data = {
          'deviceConfig': androidDeviceInfo!.id.isNotEmpty && Platform.isAndroid ? androidDeviceInfo.id : iOSDeviceInfo!.identifierForVendor,
          'deviceName': androidDeviceInfo.brand.isNotEmpty && Platform.isAndroid ? androidDeviceInfo.brand : iOSDeviceInfo!.model,
          'email': email,
          'profilePhoto': result?.photoUrl ?? '',
          'usernameFromGoogle': result?.displayName ?? '',
        };
        dynamic response = await authServices.googleAuthService(data);
        // print(response);
        BaseModel baseModel = BaseModel.fromJson(response.data);
        if (!baseModel.status && baseModel.msg.contains("user Logged in device")) {
          return GoogleAuthRespose(
            isloginother: true,
            isphonenumberverif: false,
            isgoogleresponse: false,
            email: email,
          );
        }
        if (baseModel.msg.contains("email_sign")) {
          //You have Already registered with this email, Please signIn using Email and password.
          // flutterToast('Please signIn using Email and password.');
          return GoogleAuthRespose(
            isloginother: false,
            isphonenumberverif: false,
            isgoogleresponse: false,
            email: 'Please signIn using Email and password.',
          );
        }
        GoogleAuthModel user = GoogleAuthModel.fromJson(response.data);
        // print('----------------------------------------------');
        user.msg.isNotEmpty ? flutterToast(user.msg) : print('empty');

        if (user.status) {
          // print(user.data.accessToken);
          SharedPreferenceHelper.setString(Preferences.accesstoken, user.data.accessToken);
          SharedPreferenceHelper.setString(Preferences.name, user.data.fullName);
          SharedPreferenceHelper.setString(Preferences.email, user.data.email);
          await SharedPreferenceHelper.setString(Preferences.phoneNUmber, user.data.phoneNumber);
          SharedPreferenceHelper.setString(Preferences.profileImage, user.data.profilePhoto);
          SharedPreferenceHelper.setString(Preferences.address, user.data.address);
          SharedPreferenceHelper.setString(Preferences.language, user.data.language);
          SharedPreferenceHelper.setString(Preferences.enrollId, user.data.enrollId);
          SharedPreferenceHelper.setStringList(Preferences.course, user.data.stream);
          await SharedPreferenceHelper.setString(Preferences.myReferralCode, user.data.myReferralCode);
          return GoogleAuthRespose(isloginother: false, isphonenumberverif: user.data.userMobileNumberVerified, isgoogleresponse: user.status, email: user.data.email);
        }
        return GoogleAuthRespose(isloginother: false, isphonenumberverif: false, isgoogleresponse: user.status, email: email);
      }
      return GoogleAuthRespose(isloginother: false, isphonenumberverif: false, isgoogleresponse: false, email: email);
    } catch (error) {
      // print(error);
      //flutterToast(error.toString());
      return GoogleAuthRespose(isloginother: false, isphonenumberverif: false, isgoogleresponse: false, email: '');
    }
  }

  Future<bool> updateStreamLanguage({dynamic language, dynamic stream}) async {
    try {
      dynamic responseLanguageJson = await authServices.updateLanguage(language);
      BaseModel responseLanguage = BaseModel.fromJson(responseLanguageJson);
      dynamic responseStreamJson;
      BaseModel responseStream = BaseModel(status: false, data: '', msg: '');
      if (SharedPreferenceHelper.getStringList(Preferences.course).isEmpty) {
        // responseStreamJson = await authServices.updateStream(stream);
        responseStream = BaseModel.fromJson(responseStreamJson);
        SharedPreferenceHelper.setStringList(Preferences.course, stream);
      }
      SharedPreferenceHelper.getStringList(Preferences.course).isEmpty ? flutterToast("${responseStream.msg} ${responseLanguage.msg}") : flutterToast(responseLanguage.msg);
      return SharedPreferenceHelper.getStringList(Preferences.course).isEmpty ? responseStream.status && responseLanguage.status : responseLanguage.status;
    } catch (error) {
      flutterToast(error.toString());
      rethrow;
    }
  }

  // Future<bool> logout(BuildContext context) async {
  //   Preferences.onLoading(context);
  //   try {
  //     dynamic responseJson = await authServices.logoutService();
  //     BaseModel response = BaseModel.fromJson(responseJson.data);
  //     flutterToast(response.msg);
  //     Preferences.hideDialog(context);
  //     return response.status;
  //   } catch (error) {
  //     Preferences.onLoading(context);
  //     flutterToast(error.toString());
  //     return false;
  //   }
  // }

  // Future<bool> updateUserDetails(String fullName, String userAddress) async {
  //   try {
  //     dynamic response =
  //         await authServices.updateUserDetailsService(fullName, userAddress);
  //     BaseModel data = BaseModel.fromJson(response);
  //     if (data.status) {
  //       SharedPreferenceHelper.setString(Preferences.address, userAddress);
  //       SharedPreferenceHelper.setString(Preferences.name, fullName);
  //     }
  //     Util.flutterToast(data.msg);
  //     return data.status;
  //   } catch (error) {
  //     Util.toastMessage(error.toString());
  //     return false;
  //   }
  // }

  // Future<bool> updateUserProfilePhoto(var fileBytes, String imageName) async {
  //   try {
  //     dynamic response = await authServices.updateUserProfilePhotoService(
  //         fileBytes, imageName);
  //     BaseModel data = BaseModel.fromJson(response);
  //     SharedPreferenceHelper.setString(
  //         Preferences.profileImage, data.data['fileUploadedLocation']);
  //     Util.flutterToast(data.msg);
  //     return data.status;
  //   } catch (error) {
  //     Util.toastMessage(error.toString());
  //     return false;
  //   }
  // }

  Future<bool> requestToLogout(String userEmail, String message) async {
    // print(message);
    // print('*' * 200);
    try {
      dynamic response = await authServices.requestToLogoutService(
        {
          'email_phoneNumber': userEmail,
          'message': message
        },
      );
      // print(response);
      BaseModel data = BaseModel.fromJson(response.data);
      flutterToast(data.msg);
      return data.status;
    } catch (error) {
      // print(error);
      flutterToast(error.toString());
      return false;
    }
  }

  Future<List<Widget>> getBanner() async {
    List<Widget> imageList = [];
    await authServices.getBannerApi().then((value) {
      Getbannerdetails response = Getbannerdetails.fromJson(value);
      if (response.status!) {
        for (var entry in response.data!) {
          imageList.add(CachedNetworkImage(
              placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              imageUrl: entry.bannerUrl!));
        }
      } else {
        flutterToast(response.msg!);
      }
    }).onError((error, stackTrace) {
      throw error!;
    });
    return imageList;
  }

  Future<StreamModel> getStream() async {
    try {
      List<String> stream = [];
      dynamic response = await authServices.getStreamService();
      var jsonResponse = StreamModel.fromJson(response);
      for (StreamDataModel data in jsonResponse.data ?? []) {
        stream.add(data.title ?? "");
      }
      SharedPreferenceHelper.setString(Preferences.getStreamsApi, jsonEncode(response));
      SharedPreferenceHelper.setStringList(Preferences.getStreams, stream);
      return jsonResponse;
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> resetPasswordVerification(dynamic emailPhoneNumber) async {
    try {
      dynamic response = await authServices.resetPasswordVerificationService({
        'email_phoneNumber': emailPhoneNumber,
      });
      BaseModel res = BaseModel.fromJson(response.data);
      // print(res.msg);
      res.msg.isNotEmpty ? flutterToast(res.msg) : print(" empty ");
      //flutterToast(res.data['otpToResetPassword'].toString());
      if (res.msg.contains('Google')) {
        return false;
      } else {
        return res.status;
      }
    } catch (error) {
      // print(error);
      flutterToast(error.toString());
      return false;
    }
  }

  Future<bool> resetPasswordVerifyOtp(String emailPhoneNumber, String otp) async {
    try {
      dynamic response = await authServices.resetPasswordVerifyOtpService({
        'email_phoneNumber': emailPhoneNumber,
        'otp': otp,
      });
      BaseModel res = BaseModel.fromJson(response.data);
      res.msg.isNotEmpty ? flutterToast(res.msg) : print("  ");
      return res.status;
    } catch (error) {
      // print(error);
      flutterToast(error.toString());
      return false;
    }
  }

  Future<bool> resendPasswordVerifyOtp(String emailPhoneNumber) async {
    try {
      dynamic response = await authServices.resendPasswordVerifyOtpService({
        'email_phoneNumber': emailPhoneNumber,
      });

      BaseModel res = BaseModel.fromJson(response.data);
      res.msg.isNotEmpty ? flutterToast(res.msg) : print("  ");
      //flutterToast(res.data['otpToResetPassword'].toString());
      return res.status;
    } catch (error) {
      flutterToast(error.toString());
      rethrow;
    }
  }

  Future<bool> updatePassword(dynamic data) async {
    try {
      dynamic response = await authServices.updatePasswordService(data);
      // print(response);
      BaseModel res = BaseModel.fromJson(response.data);
      res.msg.isNotEmpty ? flutterToast(res.msg) : print(" empty ");

      return res.status;
    } catch (error) {
      // print(error);
      flutterToast(error.toString());
      return false;
    }
  }
}

class GoogleAuthRespose {
  final bool isloginother;
  final bool isphonenumberverif;
  final bool isgoogleresponse;
  final String email;

  GoogleAuthRespose({required this.isloginother, required this.isphonenumberverif, required this.isgoogleresponse, required this.email});
}
