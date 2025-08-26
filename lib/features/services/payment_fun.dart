import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import "package:sd_campus_app/features/data/remote/models/course_details_model.dart";
import 'package:sd_campus_app/features/data/remote/models/coursesmodel.dart' as coursem;
import 'package:sd_campus_app/features/data/remote/models/payment_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/payment_status.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/view/screens/course/coursepaymentscreen.dart';

buttonOnTap({required BuildContext context, required BatchDetails data, required bool isEnroll}) {
  int.parse(data.discount!) == 0
      ? _savePaymentStatus(
          context,
          PaymentModel(
            paymentid: "",
            orderId: '',
            description: "App",
            mobileNumber: SharedPreferenceHelper.getString(Preferences.phoneNUmber)!,
            userName: SharedPreferenceHelper.getString(Preferences.name)!,
            userEmail: SharedPreferenceHelper.getString(Preferences.email)!,
            batchId: data.sId!,
            price: int.parse(data.discount!).toStringAsFixed(1),
            success: true,
            isCoinApplied: false,
          ),
          true,
          null)
      : Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => CoursePaymentScreen(
                    isEnroll: isEnroll,
                    course: coursem.CoursesDataModel(
                      id: data.sId!,
                      batchFeatureUrl: "",
                      batchName: data.batchName!,
                      examType: data.examType!,
                      student: data.student!,
                      teacher: data.teacher!
                          .map((e) => coursem.Teacher(
                                id: e.sId!,
                                fullName: e.fullName!,
                                profilePhoto: e.profilePhoto!,
                              ))
                          .toList(),
                      startingDate: DateTime.parse(data.startingDate!),
                      endingDate: DateTime.parse(data.endingDate!),
                      mode: data.mode!,
                      materials: data.materials!,
                      language: data.language!,
                      charges: data.charges!,
                      discount: data.discount!,
                      description: data.description!,
                      banner: data.banner!
                          .map((e) => coursem.Banner(
                                fileLoc: e.fileLoc!,
                                fileName: e.fileName!,
                                fileSize: e.fileSize!,
                              ))
                          .toList(),
                      remark: data.remark!,
                      demoVideo: data.demoVideo!,
                      validity: data.validity!,
                      isActive: data.isActive!,
                      courseReview: data.courseReview!,
                      createdAt: data.createdAt!,
                      isPaid: true,
                      stream: data.stream!,
                      subCategory: "",
                      isCoinApplicable: data.isCoinApplicable!,
                      maxAllowedCoins: data.maxAllowedCoins!,
                    ),
                  ) // cartSelectedItem!,
              ),
        );
  // callApiaddtocart(course.data!.batchDetails!.sId!);
}

void _savePaymentStatus(BuildContext context, PaymentModel paymentData, bool status, String? couponId) async {
  // print("----Saving Payment Details -----");
  analytics.logEvent(
    name: "app_trying_to_perchase",
    parameters: {
      "batch": paymentData.batchId,
    },
  );
  RemoteDataSourceImpl remoteDataSourceImpl = RemoteDataSourceImpl();
  Preferences.onLoading(context);
  try {
    Response response = await remoteDataSourceImpl.savePaymentStatus(paymentData, couponId);
    if (response.statusCode == 200) {
      // print(response.data);
      analytics.logEvent(
        name: "app_success_to_perchase",
        parameters: {
          "batch": paymentData.batchId,
        },
      );
      flutterToast(response.data['msg']);
      Preferences.hideDialog(context);
      paymentstatus(context: context, ispaided: status, paymentfor: "course");
      // Navigator.popUntil(context, (route) => route.isFirst);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => PaymentScreen(
      //       paymentfor: "course",
      //       status: status,
      //     ),
      //   ),
      // );
    } else {
      // print("-----api Payment error -----");
      Preferences.onLoading(context);
      flutterToast("Pls Refresh (or) Reopen App");
    }
  } catch (error) {
    // print(error);
    flutterToast(error.toString());
  }
}
