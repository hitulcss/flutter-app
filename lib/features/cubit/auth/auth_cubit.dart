import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:sd_campus_app/features/controller/auth_controller.dart';
import 'package:sd_campus_app/features/data/remote/models/base_model.dart';
import 'package:sd_campus_app/features/data/remote/models/login_model.dart';
import 'package:sd_campus_app/features/data/remote/models/verified_model.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  AuthController authController = AuthController();

  Future<void> registerUser(Map<String, dynamic> data) async {
    // print(data);
    emit(LoadingAuth());
    try {
      BaseModel user = await authController.register(data);
      if (user.status) {
        analytics.logSignUp(signUpMethod: "app", parameters: data as Map<String, Object>);
        emit(RegisterSuccess());
      } else {
        emit(ErrorAuth());
      }
    } catch (error) {
      emit(ErrorAuth());
    }
  }

  Future<void> loginUser(Map<String, String?> data) async {
    try {
      final PendingDynamicLinkData? initialLink = await Preferences.dynamicLinks.getInitialLink();
      if (initialLink != null) {
        // print("link");
        // print(initialLink.utmParameters);
        // final Uri deepLink = initialLink.link;
        if (initialLink.utmParameters.isNotEmpty) {
          data = {
            ...data,
            ...initialLink.utmParameters,
          };
        }
        // print(data);
      }
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo? androidDeviceInfo;
      IosDeviceInfo? iOSDeviceInfo;
      if (Platform.isAndroid) {
        androidDeviceInfo = await deviceInfo.androidInfo;
      } else if (Platform.isIOS) {
        iOSDeviceInfo = await deviceInfo.iosInfo;
      }
      data["deviceConfig"] = androidDeviceInfo!.id.isNotEmpty && Platform.isAndroid ? androidDeviceInfo.id : iOSDeviceInfo!.identifierForVendor;
      data["deviceName"] = androidDeviceInfo.brand.isNotEmpty && Platform.isAndroid ? androidDeviceInfo.brand : iOSDeviceInfo!.model;
      LoginModel user = await authController.login(data);

      if (user.status!) {
        // if (user.data['mobileVerified']) {

        emit(LoginSuccess(optlength: int.parse(user.data!.otpLength!)));
        // } else {
        //   await authController.resendOtp();
        //   emit(UnVerifiedNumber(phoneNumber: user.data['phoneNumber']));
        // }
      } else {
        // if (user.data.runtimeType == String) {
        //   emit(RequestToLogout());
        // } else

        if (user.msg!.contains('Password')) {
          emit(ErrorSnackbar(msg: user.msg!));
        } else {
          emit(ErrorSnackbar(msg: user.msg!));
        }
      }
    } catch (error) {
      // print(error);
      emit(ErrorAuth());
    }
  }

  Future<void> verifyOtp(String otp) async {
    emit(VerificationOtpLoading());
    try {
      VerifedModel data = await authController.verifyPhoneNumber({
        'otp': otp
      });
      if (data.status!) {
        emit(VerificationOtpSuccess(newUser: data.data!.isNew!));
        analytics.logLogin(
          loginMethod: "App",
          parameters: {
            "name": (SharedPreferenceHelper.getString(Preferences.name) ?? "Unknown").trim(),
            "phoneNumber": SharedPreferenceHelper.getString(Preferences.phoneNUmber) ?? "Unknown",
            "email": SharedPreferenceHelper.getString(Preferences.email)! == "N/A" ? "Unknown" : SharedPreferenceHelper.getString(Preferences.email)!,
            "id": SharedPreferenceHelper.getString(Preferences.enrollId) ?? analytics.getSessionId().toString(),
          },
        );
        analytics.setUserProperty(
          name: (SharedPreferenceHelper.getString(Preferences.name) ?? "Unknown").toLowerCase().trim().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_'),
          value: SharedPreferenceHelper.getString(Preferences.enrollId) ?? analytics.getSessionId().toString(),
        );
      } else {
        emit(VerificationOtpError());
      }
    } catch (error) {
      emit(VerificationOtpError());
    }
  }

  Future<void> resendOtp({required String number,required bool isWhatsapp}) async {
    emit(VerificationOtpLoading());
    if (await authController.resendOtp(number:number ,isWhatsapp: isWhatsapp)) {
      emit(ResendOtpSuccess());
    } else {
      emit(VerificationOtpError());
    }
  }

  Future<void> updateStreamLanguage({required String language, required List<String> stream}) async {
    emit(LoadingAuth());
    try {
      // print(language);
      if (await authController.updateStreamLanguage(language: language, stream: stream)) {
        analytics.logEvent(name: "app_user_stream", parameters: {
          "stream": stream.toString(),
          "name": SharedPreferenceHelper.getString(Preferences.name) ?? "Unknown",
          "phoneNumber": SharedPreferenceHelper.getString(Preferences.phoneNUmber) ?? "Unknown",
          "email": SharedPreferenceHelper.getString(Preferences.email) ?? "Unknown",
          "id": SharedPreferenceHelper.getString(Preferences.enrollId) ?? analytics.getSessionId().toString(),
        });
        SharedPreferenceHelper.setString(Preferences.language, language);
        SharedPreferenceHelper.setStringList(Preferences.course, stream);
        SharedPreferenceHelper.setBoolean(Preferences.isloggedin, true);
        Languages.initState();
        emit(UpdateLanguageStreamSuccess());
      } else {
        emit(ErrorAuth());
      }
    } catch (error) {
      emit(ErrorAuth());
    }
  }

  Future<void> googleAuth() async {
    emit(LoadingAuth());
    GoogleAuthRespose response = await authController.googleAuth();
    //print(response.first.toString() + response.last.toString());
    if (response.isloginother) {
      emit(GoogleAuthRequestToLogout(email: response.email));
    } else if (response.isgoogleresponse) {
      if (response.isphonenumberverif) {
        emit(GoogleSuccess());
        analytics.logLogin(parameters: {
          "stream": stream.toString(),
          "name": SharedPreferenceHelper.getString(Preferences.name) ?? "Unknown",
          "phoneNumber": SharedPreferenceHelper.getString(Preferences.phoneNUmber) ?? "Unknown",
          "email": SharedPreferenceHelper.getString(Preferences.email) ?? "Unknown",
          "id": SharedPreferenceHelper.getString(Preferences.enrollId) ?? analytics.getSessionId().toString(),
        });
      } else {
        emit(GooglePhoneNumberVerification());
      }
    } else if (response.email == 'Please signIn using Email and password.') {
      emit(ErrorSnackbar(msg: 'Please signIn using Email and password.'));
    } else {
      emit(ErrorAuth());
    }
  }

  Future<void> goolgePhoneNumberAdd(String number) async {
    emit(GoogleAddPhoneNumberLoading());
    if (await authController.postGoolglAuthNumber(number)) {
      analytics.logGenerateLead(
        parameters: {
          "number": number,
        },
      );
      emit(GoogleAddPhonenumber());
    } else {
      emit(GoogleAddPhonenumberError());
    }
  }

  Future<void> requestLogout(String userEmail, String message) async {
    emit(LoadingAuth());
    if (await authController.requestToLogout(userEmail, message)) {
      emit(RequestLogoutSuccess());
    } else {
      emit(ErrorAuth());
    }
  }

  //RESET PASSWORD
  Future<void> resetPassword(String emailMobileNumber) async {
    emit(LoadingAuth());
    if (await authController.resetPasswordVerification(emailMobileNumber)) {
      emit(ResetPasswordSuccess());
    } else {
      emit(ErrorAuth());
    }
  }

  Future<void> resetPasswordVerifyOtp(String emailMobileNumber, String otp) async {
    emit(UpdatePasswordLoading());
    if (await authController.resetPasswordVerifyOtp(emailMobileNumber, otp)) {
      emit(UpdatePasswordOtpVerifySuccess());
    } else {
      emit(UpdatePasswordError());
    }
  }

  Future<void> resendPasswordOtp(String emailPhoneNumber) async {
    emit(UpdatePasswordLoading());
    if (await authController.resendPasswordVerifyOtp(emailPhoneNumber)) {
      emit(UpdatePasswordOtpResend());
    } else {
      emit(UpdatePasswordError());
    }
  }

  Future<void> updatePassword(dynamic data) async {
    emit(UpdatePasswordLoading());
    if (await authController.updatePassword(data)) {
      emit(UpdatePasswordSuccess());
    } else {
      emit(UpdatePasswordError());
    }
  }
}
