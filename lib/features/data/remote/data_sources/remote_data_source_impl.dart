// ignore_for_file: avoid_renaming_method_parameters

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sd_campus_app/api/api.dart';
import 'package:sd_campus_app/features/data/const_data.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source.dart';
import 'package:sd_campus_app/features/data/remote/models/all_post_model.dart';
import 'package:sd_campus_app/features/data/remote/models/base_model.dart';
import 'package:sd_campus_app/features/data/remote/models/batch_community_model.dart';
import 'package:sd_campus_app/features/data/remote/models/batch_doubts_model.dart';
import 'package:sd_campus_app/features/data/remote/models/before_buy/get_list_of_lecture.dart';
import 'package:sd_campus_app/features/data/remote/models/before_buy/get_list_of_notes.dart';
import 'package:sd_campus_app/features/data/remote/models/before_buy/get_planner_model.dart';
import 'package:sd_campus_app/features/data/remote/models/coursesmodel.dart';
import 'package:sd_campus_app/features/data/remote/models/alertmodel.dart';
import 'package:sd_campus_app/features/data/remote/models/batch_notes_model.dart';
import 'package:sd_campus_app/features/data/remote/models/ebook/get_all_ebook.dart';
import 'package:sd_campus_app/features/data/remote/models/ebook/get_ebook_by_id.dart';
import 'package:sd_campus_app/features/data/remote/models/ebook/get_ebooks_review.dart';
import 'package:sd_campus_app/features/data/remote/models/ebook/get_my_ebook.dart';
import 'package:sd_campus_app/features/data/remote/models/ebook/get_my_ebook_by_id.dart';
import 'package:sd_campus_app/features/data/remote/models/ebook/get_topic.dart';
import 'package:sd_campus_app/features/data/remote/models/ebook/post_create_order_ebook.dart';
import 'package:sd_campus_app/features/data/remote/models/get_announcement_by_id.dart';
import 'package:sd_campus_app/features/data/remote/models/get_batch_dpp.dart';
import 'package:sd_campus_app/features/data/remote/models/get_batch_plan.dart';
import 'package:sd_campus_app/features/data/remote/models/get_batch_subject.dart';
import 'package:sd_campus_app/features/data/remote/models/get_cart.dart';
import 'package:sd_campus_app/features/data/remote/models/get_comments_post_id.dart';
import 'package:sd_campus_app/features/data/remote/models/get_community_comments.dart' as get_community_comments;
import 'package:sd_campus_app/features/data/remote/models/get_coupon_model.dart';
import 'package:sd_campus_app/features/data/remote/models/before_buy/get_list_of_subject.dart';
import 'package:sd_campus_app/features/data/remote/models/get_marketing_category.dart';
import 'package:sd_campus_app/features/data/remote/models/get_new_arrival.dart';
import 'package:sd_campus_app/features/data/remote/models/get_pincode.dart';
import 'package:sd_campus_app/features/data/remote/models/get_post_by_id.dart';
import 'package:sd_campus_app/features/data/remote/models/get_product_by_id.dart';
import 'package:sd_campus_app/features/data/remote/models/get_product_list.dart';
import 'package:sd_campus_app/features/data/remote/models/get_quiz_by_id.dart';
import 'package:sd_campus_app/features/data/remote/models/get_recorded_video_comments.dart';
import 'package:sd_campus_app/features/data/remote/models/get_store_address.dart';
import 'package:sd_campus_app/features/data/remote/models/get_store_alert.dart';
import 'package:sd_campus_app/features/data/remote/models/get_store_order.dart';
import 'package:sd_campus_app/features/data/remote/models/get_test_reg.dart';
import 'package:sd_campus_app/features/data/remote/models/get_test_reg_by_id.dart';
import 'package:sd_campus_app/features/data/remote/models/get_wishlist.dart';
import 'package:sd_campus_app/features/data/remote/models/getstorecategory.dart';
import 'package:sd_campus_app/features/data/remote/models/gettestresult.dart';
import 'package:sd_campus_app/features/data/remote/models/leaderboard.dart';
import 'package:sd_campus_app/features/data/remote/models/listofquiz.dart';
import 'package:sd_campus_app/features/data/remote/models/mytimersmodel.dart';
import 'package:sd_campus_app/features/data/remote/models/my_courses_model.dart';
import 'package:sd_campus_app/features/data/remote/models/myorders_model.dart';
import 'package:sd_campus_app/features/data/remote/models/mywallet_model.dart';
import 'package:sd_campus_app/features/data/remote/models/order_id_generated.dart';
import 'package:sd_campus_app/features/data/remote/models/payment_model.dart';
import 'package:sd_campus_app/features/data/remote/models/pincode_model.dart';
import 'package:sd_campus_app/features/data/remote/models/referalcontent_model.dart';
import 'package:sd_campus_app/features/data/remote/models/resources_model.dart';
import 'package:sd_campus_app/features/data/remote/models/resultmodel.dart';
import 'package:sd_campus_app/features/data/remote/models/shorts/get_short_channel.dart';
import 'package:sd_campus_app/features/data/remote/models/shorts/get_short_comment.dart';
import 'package:sd_campus_app/features/data/remote/models/shorts/get_short_video.dart';
import 'package:sd_campus_app/features/data/remote/models/store_banner.dart';
import 'package:sd_campus_app/features/data/remote/models/store_order_id_generate.dart';
import 'package:sd_campus_app/features/data/remote/models/time_spend.dart';
import 'package:sd_campus_app/features/data/remote/models/verify_coupon_model.dart';
import 'package:sd_campus_app/features/data/remote/models/video_model.dart';
import 'package:sd_campus_app/features/data/remote/models/withdrawal_model.dart';
import 'package:sd_campus_app/features/domain/reused_function.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/models/Test_series/mytests.dart';
import 'package:sd_campus_app/models/Test_series/testseriesdetails.dart';
import 'package:sd_campus_app/models/Test_series/testserie.dart';
import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart';
import 'package:sd_campus_app/models/Test_series/testseriesid.dart';
import 'package:sd_campus_app/models/get_result_banner.dart';
import 'package:sd_campus_app/models/get_success_stories.dart';
import 'package:sd_campus_app/models/gethelp_and_support.dart';
import 'package:sd_campus_app/models/library/comments/get_video_learing_comments.dart';
import 'package:sd_campus_app/models/library/get_pyqs_notes.dart';
import 'package:sd_campus_app/models/library/get_quiz_library.dart';
import 'package:sd_campus_app/models/library/get_quiz_question_library.dart';
import 'package:sd_campus_app/models/library/get_topper_notes.dart';
import 'package:sd_campus_app/models/library/get_video_learning.dart';
import 'package:sd_campus_app/util/const/help_and_support.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';

class RemoteDataSourceImpl extends RemoteDataSource {
  @override
  Future<VideoModel> getYouTubeVideo() async {
    try {
      var response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getYouTubeVideo}');
      return VideoModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<VideoDataModel> getYouTubeVideobyid({required String id}) async {
    try {
      var response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getYouTubeVideobyId}/$id');
      return VideoDataModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }

  Future<ResourcesModel> getResources() async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getResources}', queryParameters: {
        'Category': 'Pathyakram'
      });

      return ResourcesModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // @override
  // Future<CartModel> getCartDetails() async {
  //   try {
  //     Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getcartdata}');
  //     CartModel data = CartModel.fromJson(response.data);
  //     return data;
  //   } catch (error) {
  //     // //print(error);
  //     rethrow;
  //   }
  // }

  Future<CoursesModel> getpaidCourses({
    required String stream,
    String? subCategory,
    int? page,
    String? pageSize,
  }) async {
    Map<String, dynamic> data = {};
    if (page != null) {
      data["page"] = page;
    }
    if (pageSize != null) {
      data["pageSize"] = pageSize;
    }
    data["stream"] = stream;
    if (subCategory != null) {
      data["subCategory"] = subCategory;
    }
    try {
      var response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getpaidCourses}',
        queryParameters: data,
      );
      // print(response.data);
      // if ((page ?? 1) <= 1) {
      if (response.data['status'] && (page ?? 1) <= 1) {
        SharedPreferenceHelper.setString(Preferences.getCourse, jsonEncode(response.data));
      }
      if (response.data['msg'].toString().toLowerCase() == "Not an user".toLowerCase()) {
        loginRoute();
      }
      // print(response.data);
      return CoursesModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<CoursesModel> getfreeCourses({
    required String stream,
    String? subCategory,
    int? page,
    String? pageSize,
  }) async {
    Map<String, dynamic> data = {};
    if (page != null) {
      data["page"] = page;
    }
    if (pageSize != null) {
      data["pageSize"] = pageSize;
    }
    data["stream"] = stream;
    if (subCategory != null) {
      data["subCategory"] = subCategory;
    }
    try {
      var response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getfreeCourses}',
        queryParameters: data,
      );
      // if ((page ?? 1) <= 1) {
      //   SharedPreferenceHelper.setString(Preferences.getCourse, jsonEncode(response.data));
      // }
      // //print(response.data);
      return CoursesModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<TestSeriesModel> getTestSeries() async {
    try {
      final queryParameters = <String, dynamic>{};
      var response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.gettestseries}',
        queryParameters: queryParameters,
      );
      SharedPreferenceHelper.setString(Preferences.getTestSeries, jsonEncode(response.data));
      return TestSeriesModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<TestSeriesIdModel> getTestSeriesid({required String id}) async {
    try {
      final queryParameters = <String, dynamic>{};
      var response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.gettestseries}/$id',
        queryParameters: queryParameters,
      );
      return TestSeriesIdModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> submitanswer(file, String id) async {
    try {
      FormData data = FormData.fromMap({
        "test_id": id,
        "file": file == "0"
            ? "nofile"
            : await MultipartFile.fromFile(
                file.path,
                filename: file.name,
              )
      });

      Response response = await dioAuthorizationData().post("${Apis.baseUrl}${Apis.submittest}", data: data);
      return response;
    } catch (error) {
      // //print("fdsa");
      // //print(error.toString());
      rethrow;
    }
  }

  @override
  Future<MyCoursesModel> getMyCourses() async {
    try {
      var response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.mycourses}');
      // //print(response.statusMessage);
      SharedPreferenceHelper.setString(Preferences.getMyCourse, jsonEncode(response.data));
      return MyCoursesModel.fromJson(response.data);
    } catch (e) {
      // print(e.toString());
      rethrow;
    }
  }

  Future<GetListOfSubjectsModel> getListOfSubjects({required String id}) async {
    try {
      Response response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getBatchesSubjects}',
        queryParameters: {
          "batchId": id
        },
      );
      // //print(response.statusMessage);
      return GetListOfSubjectsModel.fromJson(jsonEncode(response.data));
    } catch (e) {
      // print(e.toString());
      rethrow;
    }
  }

  Future<GetListOfLectureModel> getLecturesOfSubjects({required String batchid, required String subjectId}) async {
    try {
      var response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getListOfLectureOfSubject}',
        queryParameters: {
          "batchId": batchid,
          "subjectId": subjectId,
        },
      );
      // //print(response.statusMessage);
      return GetListOfLectureModel.fromJson(response.data);
    } catch (e) {
      // print(e.toString());
      rethrow;
    }
  }

  Future<GetListOfNotesModel> getnotesbeforebatch({required String batchid, required String subjectId}) async {
    try {
      var response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getBatchesNotes}',
        queryParameters: {
          "batchId": batchid,
          "subjectId": subjectId,
        },
      );
      // //print(response.statusMessage);
      return GetListOfNotesModel.fromJson(jsonEncode(response.data));
    } catch (e) {
      // print(e.toString());
      rethrow;
    }
  }

  Future<GetListOfNotesModel> getdppbeforebatch({required String batchid, required String subjectId}) async {
    try {
      var response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getBatchesDpp}',
        queryParameters: {
          "batchId": batchid,
          "subjectId": subjectId,
        },
      );
      // //print(response.statusMessage);
      return GetListOfNotesModel.fromJson(jsonEncode(response.data));
    } catch (e) {
      // print(e.toString());
      rethrow;
    }
  }

  Future<GetPlannerModel> getPlannerBeforeBatch({
    required String batchid,
  }) async {
    try {
      var response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getPlanner}',
        queryParameters: {
          "batchId": batchid,
        },
      );
      // //print(response.statusMessage);
      return GetPlannerModel.fromMap(response.data);
    } catch (e) {
      // print(e.toString());
      rethrow;
    }
  }

  Future<MyCoursesDataModel> getMyCoursesByid({required String id}) async {
    try {
      var response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.mycoursesbyid}', queryParameters: {
        "batchId": id
      });
      if (response.data["status"] == false) {
        flutterToast(response.data["msg"]);
      }
      //print(response.data["data"]["batchDetails"]);
      return MyCoursesDataModel.fromJson(response.data["data"]);
    } catch (e) {
      // print(e.toString());
      rethrow;
    }
  }

  Future<BatchSubject> getSubjectOfBatch({required String id}) async {
    Map<String, dynamic> data = {
      "batchId": id,
    };
    try {
      Response response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getSubjectOfBatch}',
        queryParameters: data,
      );
      //print(response.data);
      return BatchSubject.fromJson(response.data);
    } catch (e) {
      // //print(e.toString());
      rethrow;
    }
  }

  Future<LectureDetails> getMyCoursesLectureByid({required String id}) async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.mycoursesLecturebyid}/$id');
      // //print(response.statusMessage);
      BaseModel baseModel = BaseModel.fromJson(response.data);
      if (baseModel.status) {
        return LectureDetails.fromJson(baseModel.data);
      } else {
        return LectureDetails();
      }
    } catch (e) {
      // //print(e.toString());
      rethrow;
    }
  }

  Future<MyTestsModel> getMyTests() async {
    try {
      var response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.myTests}');
      return MyTestsModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<TestSeriesDetails> getMyTestsdetails(String id) async {
    try {
      final queryParameters = <String, dynamic>{
        "testSeriesId": id
      };
      var response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.myTestsoftest}',
        queryParameters: queryParameters,
      );
      // //print(response);
      return TestSeriesDetails.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<TestSeriesDetailsData> getMyTestsdetailsbyid({required String id}) async {
    try {
      var response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.myTestsoftestbyid}/$id',
      );
      // //print(response);
      if (response.data['status']) {
        return TestSeriesDetailsData.fromJson(response.data["data"]);
      } else {
        flutterToast(response.data['msg']);
        return TestSeriesDetailsData.fromJson({});
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Response> addMyCourses(String batchId, bool isPaid) async {
    try {
      Response response = await dioAuthorizationData().post('${Apis.baseUrl}${Apis.addToMyCourses}', data: {
        'batch_id': batchId,
        'is_paid': isPaid
      });
      return response;
    } catch (error) {
      rethrow;
    }
  }

  // @override
  // Future<Response> deleteCartCourse(String id) async {
  //   try {
  //     var response = await dioAuthorizationData().delete('${Apis.baseUrl}${Apis.removefromCart}$id');
  //     return response;
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  Future<Response> savePaymentStatus(PaymentModel paymentData, String? couponId) async {
    try {
      Map<String, dynamic> data = paymentData.toJson();
      if (couponId != null && couponId.trim().isNotEmpty) {
        data["couponId"] = couponId;
      }
      Response response = await dioAuthorizationData().post(
        '${Apis.baseUrl}${Apis.savePaymentStatus}',
        data: data,
      );
      // //print(response.data);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> savetestPaymentStatus(Map<String, dynamic> paymentData) async {
    try {
      Response response = await dioAuthorizationData().post(
        '${Apis.baseUrl}${Apis.savetestPaymentStatus}',
        data: paymentData,
      );
      // //print(response);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  @override
  getBatchNotes({required String batchId, required String subjectId}) async {
    Map<String, dynamic>? payloaddata = {
      "batchId": batchId,
      "subjectId": subjectId,
    };
    try {
      Response response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getBatchNotes}',
        queryParameters: payloaddata,
      );
      BatchNotesModel data = BatchNotesModel.fromJson(response.data);
      if (data.status!) {
        return data.data!;
      } else {
        return [];
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<LectureDetails>> getLecturesOfSubject({required String batchId, required String subjectId}) async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getLecturesOfSubject}', queryParameters: {
        'batchId': batchId,
        "subjectId": subjectId
      });
      if (response.data['status']) {
        List<LectureDetails> data = [];
        response.data['data'].forEach((element) {
          data.add(LectureDetails.fromJson(element));
        });
        // RecordedVideoModel data = RecordedVideoModel.fromJson(response.data);
        // //print(data);
        return data;
      } else {
        return [];
      }
    } catch (error) {
      rethrow;
    }
  }

  @override
  getMyOrder() async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getMyOrders}');
      return MyOrdersModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  @override
  getCoursesDetails(String batchId) async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getCoursesDetails}$batchId');
      // //print(response.data);
      return CoursesDetailsModel.fromJson(response.data);
    } catch (error) {
      // //print(error.toString());
      rethrow;
    }
  }

  Future<OrderIdGenerated> postinitiateBatchPayment({
    required String batchId,
    required double amount,
    required String coins,
    String? couponId,
    String? courseValdityId,
  }) async {
    Map<String, dynamic> data = {
      "batchId": batchId,
      "amount": amount.toString(),
      "coins": coins,
      "platform": Platform.isIOS ? "ios" : "app",
      "utm_campaign": "app_payment",
      "utm_medium": "app_payment",
      "utm_source": "app_payment"
    };
    if (courseValdityId != null) {
      data["validityId"] = courseValdityId;
    }
    if (couponId != null) {
      data["couponId"] = couponId;
    }
    try {
      Response response = await dioAuthorizationData().post('${Apis.baseUrl}${Apis.initiateCoursePayment}', data: data);
      return OrderIdGenerated.fromMap(response.data);
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

  Future<OrderIdGenerated> postinitiateBatchPaymentExtend({
    required String batchId,
    required double amount,
    required String coins,
    String? couponId,
    String? courseValdityId,
  }) async {
    Map<String, dynamic> data = {
      "batchId": batchId,
      "amount": amount.toString(),
      "coins": coins,
      "platform": Platform.isIOS ? "ios" : "app",
      "utm_campaign": "app_payment",
      "utm_medium": "app_payment",
      "utm_source": "app_payment"
    };
    if (courseValdityId != null) {
      data["validityId"] = courseValdityId;
    }
    if (couponId != null) {
      data["couponId"] = couponId;
    }
    try {
      Response response = await dioAuthorizationData().post('${Apis.baseUrl}${Apis.addValidityToCourse}', data: data);
      return OrderIdGenerated.fromMap(response.data);
    } catch (e) {
      // print(e);
      rethrow;
    }
  }

  Future<Response> submitobjtestlive(String testId, Map<dynamic, dynamic> answerArr) async {
    try {
      Response response = await dioAuthorizationData().post('${Apis.baseUrl}${Apis.submitObjectiveTest}', data: {
        'test_id': testId,
        'answer_arr': answerArr,
      });
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> submittquizrequest(String testId, Map<dynamic, dynamic> answerArr, String timeSpent) async {
    try {
      Response response = await dioAuthorizationData().post('${Apis.baseUrl}${Apis.submmitquiz}$testId', data: {
        // 'test_id': test_id,
        'ans_res': answerArr,
        'timeSpent': timeSpent
      });
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> submitresumequizrequest(String testId, Map<dynamic, dynamic> answerArr, String timeSpent) async {
    try {
      Response response = await dioAuthorizationData().post('${Apis.baseUrl}${Apis.subnitresume}$testId', data: {
        // 'test_id': test_id,
        'ans_res': answerArr,
        'timeSpent': timeSpent
      });
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<ListOfQuizModel> getListOfQuiz() async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getquiz}');
      // //print(response.data);
      return ListOfQuizModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<ListOfQuizModel> getListOfQuizByBatchid({required String id}) async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getquizBybatchid}/$id');
      // //print(response.data);
      return ListOfQuizModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetQuizById> getQuizbyid({required String id}) async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getquizByid}/$id');
      // //print(response.data);
      return GetQuizById.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetQuizQuestionLibrary> getQuestionsById(
    String id,
  ) async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getquestionbyid}$id');
      // //print(response.data);
      return GetQuizQuestionLibrary.fromMap(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<ResultModel> getrResultById(
    String id,
    String? attemptId,
  ) async {
    Map<String, String> data = {
      'quizId': id,
    };
    if (attemptId != null) {
      data['attemptId'] = attemptId;
    }
    try {
      Response response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getresult}',
        queryParameters: data,
      );
      // //print(response.data);
      return ResultModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  postreport({
    required String id,
    required String question,
    required String desc,
  }) async {
    try {
      Response response = await dioAuthorizationData().post(
        '${Apis.baseUrl}${Apis.quizreport}$id',
        data: {
          "que_title": question,
          "desc": desc
        },
      );
      // //print(response);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  postaskdoubt({
    required String id,
    required String question,
    required String desc,
  }) async {
    try {
      Response response = await dioAuthorizationData().post(
        '${Apis.baseUrl}${Apis.quizaskdoubt}$id',
        data: {
          "que_title": question,
          "desc": desc
        },
      );
      // //print(response);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<MyTimersModel> getMyTimer() async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getmytimer}');
      // //print(response.data);
      return MyTimersModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> postmyTimer({
    required String timerTitle,
    required String timerDuration,
  }) async {
    // //print(timerDuration + "   " + TimerTitle);
    try {
      Response response = await dioAuthorizationData().post(
        '${Apis.baseUrl}${Apis.addmytimer}',
        data: {
          "timerDuration": timerDuration,
          "TimerTitle": timerTitle
        },
      );
      // //print(response);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> deleteMyTimer({required String id}) async {
    try {
      var response = await dioAuthorizationData().delete('${Apis.baseUrl}${Apis.deletemytimer}$id');
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<CouponGetModel> getcouponrequest({
    required String link,
    required dynamic linkwith,
  }) async {
    Map<String, dynamic> data = {
      "link": link,
      "linkWith": linkwith,
    };
    try {
      Response response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getcoupans}',
        data: data,
      );
      // //print(response.data);
      return CouponGetModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<VerifyCouponModel> verifyCouponrequest({
    required String couponCode,
    required String link,
    required dynamic linkwith,
  }) async {
    Map data = {
      "link": link,
      "linkWith": linkwith,
      "couponCode": couponCode
    };
    try {
      Response response = await dioAuthorizationData().post(
        '${Apis.baseUrl}${Apis.verifyCoupon}',
        data: data,
      );
      // //print(response);
      return VerifyCouponModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> notificationread({
    required String id,
  }) async {
    try {
      Response response = await dioAuthorizationData().put(
        '${Apis.baseUrl}${Apis.updateIsRead}$id',
      );
      // //print(response);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<AlertModel> getalert() async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getalert}');
      // //print(response.data);
      return AlertModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<Response> getupi() async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getupi}');
      // //print(response);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<GetTestResultsModel> getTestResults({required String id}) async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.testResultsList}$id');
      // //print(response);
      return GetTestResultsModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<ReferalContentModel> getreferalContent() async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getRefaralContent}');
      SharedPreferenceHelper.setString(Preferences.getReferalContent, jsonEncode(response.data));
      return ReferalContentModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<MyWalletModel> getMyWallet() async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getMyWallet}');
      SharedPreferenceHelper.setString(Preferences.getmywallet, jsonEncode(response.data));
      return MyWalletModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<WithdrawalRequestModel> postwithdrawalRequest({
    required String upiId,
    required String amount,
  }) async {
    Map<String, dynamic> paymentData = {
      "upiId": upiId,
      "amount": amount
    };
    try {
      Response response = await dioAuthorizationData().post(
        '${Apis.baseUrl}${Apis.withdrawalRequest}',
        data: paymentData,
      );
      // //print(response);
      return WithdrawalRequestModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> alpplycoupancodere({
    required String referalcode,
  }) async {
    Map<String, dynamic> paymentData = {
      "referalCode": referalcode
    };
    try {
      Response response = await dioAuthorizationData().post(
        '${Apis.baseUrl}${Apis.applyreferalRequest}',
        data: paymentData,
      );
      // //print(response);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<LeaderboardsModel> getLeaderboards({required String id}) async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getLeaderboard}$id');
      // //print(response.data);
      return LeaderboardsModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetStoreCategory> getStoreCAtegoryRequest() async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getAllProductCategory}');
      //print(response.data);
      return GetStoreCategory.fromJson(response.data);
    } catch (error) {
      //print('getStoreCAtegoryRequest$error');
      rethrow;
    }
  }

  Future<GetStoreBanner> getStoreBannerRequest() async {
    try {
      //print("object");
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getStoreBanner}', queryParameters: {
        'bannerType': 'APP',
        "category": "",
      });
      //print(response.data);
      return GetStoreBanner.fromJson(response.data);
    } catch (error) {
      //print('getStoreCAtegoryRequest$error');

      rethrow;
    }
  }

  Future<Getproductlist> getProductListRequest({
    String? text,
    String? category,
    int? year,
    String? language,
    String? productType,
    int page = 1,
    int pageSize = 10,
    int? minDiscount,
    bool? type,
  }) async {
    Map<String, dynamic> data = {};
    data['page'] = page;
    data["pageSize"] = pageSize;
    if (category != null) {
      data['category'] = category;
    }
    if (year != null) {
      data['year'] = year;
    }
    if (language != null) {
      data['language'] = language;
    }
    if (productType != null) {
      data['productType'] = productType;
    }
    if (minDiscount != null) {
      data['minDiscount'] = minDiscount;
    }
    if (type == true) {
      data['type'] = "NEW ARRIVAL";
    }
    //print(data);
    try {
      Response response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getAllStoreProduct}',
        queryParameters: data,
      );
      //print(response.data);
      return Getproductlist.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetMarketingCategory> getsgetMarketingCategoryRequest({required int limit, required String category, required int page}) async {
    try {
      Map<String, dynamic> data = {
        "pageSize": limit,
        "category": category,
        "page": page
      };
      Response response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getMarketingCategory}',
        queryParameters: data,
      );
      //print(response.data);
      return GetMarketingCategory.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetProductById> getProductDetialsByIdRequest({
    required String id,
  }) async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getProductDetailsById}/$id');
      //print(response.data);
      return GetProductById.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetNewArrival> getNewArrivalRequest() async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getNewArrival}');
      //print(response.data);
      return GetNewArrival.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<TimeSpendL> getTimeSpendLRequest({required String id, required String time}) async {
    try {
      Map<String, dynamic> data = {
        "lectureId": id,
        "timeSpend": time
      };
      Response response = await dioAuthorizationData().post(
        '${Apis.baseUrl}${Apis.timeSpendL}',
        data: data,
      );
      //print(response.data);
      return TimeSpendL.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetCart> addtoStoreCartRequest({String? productId, int? productQty}) async {
    Map<String, dynamic> data = {
      "platform": "app"
    };
    if (productId != null) {
      data["productId"] = productId;
    }
    if (productQty != null) {
      data["productQty"] = productQty;
    }
    try {
      Response response = await dioAuthorizationData().post(
        '${Apis.baseUrl}${Apis.getStoreCart}',
        data: data,
      );
      //print(response.data);
      return GetCart.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetWishlistItems> getWishlistRequest({String? productId}) async {
    try {
      Map<String, dynamic> data = {
        "platfrom": "app"
      };
      if (productId != null) {
        data['productId'] = productId;
      }
      Response response = await dioAuthorizationData().post(
        '${Apis.baseUrl}${Apis.postWishlist}',
        data: data,
      );
      //print(response.data);
      return GetWishlistItems.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetCart> removeCartRequest({String? productId}) async {
    try {
      Response response = await dioAuthorizationData().delete(
        '${Apis.baseUrl}${Apis.deletStoreCart}/$productId',
      );
      //print(response.data);
      return GetCart.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> removeStoreAddressRequest({required String id}) async {
    try {
      Response response = await dioAuthorizationData().delete(
        '${Apis.baseUrl}${Apis.deleteStoreAddress}/$id',
      );
      //print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> addAddressRequest({
    required String email,
    required String name,
    required String phone,
    required String streetAddress,
    required String city,
    required String country,
    required String state,
    required String pinCode,
    String? addressId,
  }) async {
    try {
      Map<String, dynamic> data = {
        "email": email,
        "name": name,
        "phone": phone,
        "streetAddress": streetAddress,
        "city": city,
        "country": country,
        "state": state,
        "pinCode": pinCode
      };
      if (addressId != null) {
        data["addressId"] = addressId;
      }

      Response response = await dioAuthorizationData().post(
        '${Apis.baseUrl}${Apis.addStoreAddress}',
        data: data,
      );
      //print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetStoreAddress> getStoreAddressRequest() async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getStoreAddress}');
      //print(response.data);
      return GetStoreAddress.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<Getproductlist> getStoreRecommedRequest({int limit = 10}) async {
    try {
      Response response = await dioAuthorizationData().get('${Apis.baseUrl}${Apis.getStoreRecommend}', queryParameters: {
        "limit": limit
      });
      //print(response.data);
      return Getproductlist.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<Getproductlist> getStoreSimilarRequest({int limit = 4}) async {
    try {
      Response response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getStoreSimiliar}',
        queryParameters: {
          "limit": limit
        },
      );
      //print(response.data);
      return Getproductlist.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetStoreOrders> getStoreOrdersRequest() async {
    try {
      Response response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getStoreOrders}',
      );
      //print(response.data);
      return GetStoreOrders.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> storeOrderscancelRequest({required String id}) async {
    try {
      Response response = await dioAuthorizationData().put(
        '${Apis.baseUrl}${Apis.storeCancelOrder}/$id',
      );
      //print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> addstoreOrdersRefundRequest({
    required String id,
    required String bankName,
    required String fullName,
    required String accountNumber,
    required String ifsc,
  }) async {
    try {
      Response response = await dioAuthorizationData().put('${Apis.baseUrl}${Apis.addstoreOrderRefund}', data: {
        "storeOrderId": id,
        "bankName": bankName,
        "fullName": fullName,
        "accountNumber": accountNumber,
        "ifsc": ifsc,
      });
      //print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetStoreAlert> getStoreAlertRequest() async {
    try {
      Response response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getStoreAlert}',
      );
      //print(response.data);
      return GetStoreAlert.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> storeOrderCODRequest({
    required String couponId,
    required String totalAmount,
    required String addressId,
    required List<Map<String, String>> products,
    required String deliveryCharges,
  }) async {
    try {
      Map<String, dynamic> data = {
        "totalAmount": totalAmount,
        "addressId": addressId,
        "products": products,
        "deliveryCharges": deliveryCharges,
        "orderType": "COD",
        "platfrom": "app",
      };
      if (couponId.isNotEmpty) {
        data["couponId"] = couponId;
      }
      //print(data);
      Response response = await dioAuthorizationData().post(
        '${Apis.baseUrl}${Apis.storeCODOrder}',
        data: data,
      );
      //print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<StoreOderIdGenerate> storeOrderIdGenerateRequest({
    required String couponId,
    required String totalAmount,
    required String addressId,
    required List<Map<String, String>> products,
    required String deliveryCharges,
  }) async {
    try {
      Map<String, dynamic> data = {
        "totalAmount": totalAmount,
        "addressId": addressId,
        "products": products,
        "deliveryCharges": deliveryCharges,
        "platfrom": "app",
      };
      if (couponId.isNotEmpty) {
        data["couponId"] = couponId;
      }
      //print(data);
      Response response = await dioAuthorizationData().post(
        '${Apis.baseUrl}${Apis.storeGenerateOrderId}',
        data: data,
      );
      //print(response.data);
      return StoreOderIdGenerate.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> storeOrderSaveRequest({
    required String orderId,
    required String txnAmount,
    required String txnId,
    required bool isPaid,
    required String easePayId,
  }) async {
    try {
      Map<String, dynamic> data = {
        "orderId": orderId,
        "txnAmount": txnAmount,
        "txnId": txnId,
        "easePayId": easePayId,
        "isPaid": isPaid,
      };
      Response response = await dioAuthorizationData().post(
        '${Apis.baseUrl}${Apis.saveTxnDetails}',
        data: data,
      );
      //print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> postStoreVerificationRequest({
    required String id,
  }) async {
    // print(id);
    try {
      Response response = await dioAuthorizationData().post('${Apis.baseUrl}${Apis.storeverifyPayment}', queryParameters: {
        "orderId": id,
      });
      //print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<getAnnouncement> getCourseAnnouncementRequest({
    required String id,
  }) async {
    try {
      Response response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getAnnouncement}/$id',
      );
      //print(response.data);
      return getAnnouncement.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetTestReg> getTestRegistRequest() async {
    try {
      Response response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getAllScholarshipTest}',
      );
      //print(response.data);
      return GetTestReg.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetTestRegById> getTestRegistByidRequest({required String id}) async {
    try {
      Response response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getAllScholarshipTestbyId}/$id',
      );
      //print(response.data);
      return GetTestRegById.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> scholarshipTestRegesterRequest({
    required String id,
  }) async {
    try {
      Map<String, dynamic> data = {
        "scholarshipTestId": id,
      };
      Response response = await dioAuthorizationData().post(
        '${Apis.baseUrl}${Apis.scholarshipTestRegester}',
        data: data,
      );
      //print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetBatchDPP> getbatchdppByidRequest({required String id, required String subjectId}) async {
    try {
      Response response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getDppByBatchId}/$id',
        queryParameters: {
          "subjectId": subjectId,
          "batchId": id,
        },
      );
      //print(response.data);
      return GetBatchDPP.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetBatchPlan> getBatchPlan({
    required String id,
  }) async {
    try {
      Response response = await dioAuthorizationData().get(
        '${Apis.baseUrl}${Apis.getBatchPlan}',
        queryParameters: {
          "batchId": id,
        },
      );
      //print(response.data);
      return GetBatchPlan.fromMap(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<List<GetPinCode>> getPincodeRequest() async {
    try {
      Response response = await dioAuthorizationData().get(
        Apis.getpincode,
      );
      //print(response.data);
      List<GetPinCode> listpincode = [];
      response.data!.forEach((element) {
        listpincode.add(GetPinCode.fromJson(element));
      });
      //print(listpincode);
      return listpincode;
    } catch (error) {
      rethrow;
    }
  }

  Future<Getproductlist> getsearchRequest({required String search}) async {
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.searchProduct,
        queryParameters: {
          "search": search,
        },
      );
      return Getproductlist.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<CoursesModel> getSearchCourseRequest({required String search}) async {
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.searchCourses,
        queryParameters: {
          "search": search,
        },
      );
      return CoursesModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> postProductReviewRequest({
    required String id,
    required String rating,
    required String title,
    required String description,
  }) async {
    Map<String, dynamic> data = {
      "title": title,
      "rating": rating,
      "description": description,
    };
    try {
      Response response = await dioAuthorizationData().post(
        '${Apis.baseUrl}${Apis.scholarshipTestRegester}/$id',
        data: data,
      );
      //print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> postStreamRequest({
    required String name,
    String? subname,
  }) async {
    Map<String, dynamic> data = {
      "category": name,
    };
    if (subname != null) {
      data["subCategory"] = subname;
    }
    try {
      Response response = await dioAuthorizationData().post(
        '${Apis.baseUrl}${Apis.currentstream}',
        data: data,
      );
      //print(response.data);
      flutterToast(response.data['msg']);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  // Future<String?> getaddressfromip() async {
  //   try {
  //     Response ipres = await dioAuthorizationData().get("https://api.ipify.org/?format=json");
  //     Response response = await dioAuthorizationData().get("http://ip-api.com/json/${ipres.data["ip"]}");
  //     String address = "${response.data["city"].toString()},${response.data["regionName"].toString()},${response.data["country"]},${response.data["zip"]}";
  //     //print(response);
  //     return address;
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  Future<PincodeModel> getAddressFromPincode({required String pincode}) async {
    try {
      Response response = await dioAuthorizationData().get("https://api.postalpincode.in/pincode/$pincode");
      //print(response);
      if (response.data[0]["Status"] == "Success") {
        return PincodeModel.fromJson(response.data[0]);
      } else {
        return PincodeModel(message: "", status: "", postOffice: []);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<AllPostsModel> getAllPostsRequest({
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      Response response = await dioAuthorizationData().get(Apis.baseUrl + Apis.getAllPosts, queryParameters: {
        "page": page,
        "pageSize": pageSize
      });
      //print(response.data);
      return AllPostsModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetPostsByIdModel> getPostsbyidRequest({required String id}) async {
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getPostById + id,
      );
      //print(response.data);
      return GetPostsByIdModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> deleteCommunityByIdRequest({
    required String communityId,
  }) async {
    try {
      Map<String, dynamic> data = {
        "batchCommunityId": communityId,
      };
      Response response = await dioAuthorizationData().delete(
        Apis.baseUrl + Apis.deleteCommunity,
        queryParameters: data,
      );
      flutterToast(response.data['msg']);
      //print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetCommentByPostIdModel> getCommentByPostIdRequest({required String id, int page = 1, int pageSize = 10}) async {
    try {
      Response response = await dioAuthorizationData().get(Apis.baseUrl + Apis.getCommentsByPostId + id, queryParameters: {
        // "id":id,
        "page": page,
        "pageSize": pageSize
      });
      //print(response.data);
      return GetCommentByPostIdModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> postAddCommentRequest({
    required String postId,
    required String msg,
  }) async {
    try {
      Map<String, dynamic> data = {
        "postId": postId,
        "msg": msg,
      };
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.addCommentToPost,
        data: data,
      );
      //print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> postLikeRequest({
    required String postId,
  }) async {
    try {
      Map<String, dynamic> data = {
        "postId": postId,
      };
      Response response = await dioAuthorizationData().put(
        Apis.baseUrl + Apis.postlikeOrRemoveLike,
        queryParameters: data,
      );
      //print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> replyToCommentsRequest({
    required String commentId,
    required String msg,
  }) async {
    try {
      Map<String, dynamic> data = {
        "commentId": commentId,
        "msg": msg,
      };
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.replyToComments,
        data: data,
      );
      //print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> deleteCommentRequest({
    required String commentId,
  }) async {
    try {
      Map<String, dynamic> data = {
        "commentId": commentId,
      };
      Response response = await dioAuthorizationData().delete(
        Apis.baseUrl + Apis.deleteComment,
        queryParameters: data,
      );
      //print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> deleteReplyCommentRequest({
    required String replyCommentId,
  }) async {
    try {
      Map<String, dynamic> data = {
        "replyCommentId": replyCommentId,
      };
      Response response = await dioAuthorizationData().delete(
        Apis.baseUrl + Apis.deleteReplyComment,
        queryParameters: data,
      );
      //print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> postReportRequest({
    required String lectureId,
    required String msg,
  }) async {
    try {
      Map<String, dynamic> data = {
        "lectureId": lectureId,
        "title": msg,
      };
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.postReport,
        data: data,
      );
      //print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> postRatingRequest({
    required String lectureId,
    required String msg,
    required double rating,
  }) async {
    try {
      Map<String, dynamic> data = {
        "lectureId": lectureId,
        "title": msg,
        "rating": rating.toInt().toString(),
      };
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.postRating,
        data: data,
      );
      //print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<List<LectureDetails>> getTodayClassRequest() async {
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getTodayClass,
      );
      List<LectureDetails> lectureDetails = [];
      if (response.data['status']) {
        // print("dsda");
        response.data["data"].forEach((element) {
          lectureDetails.add(LectureDetails.fromJson(element));
        });
        // print(response.data);
      }
      return lectureDetails;
    } catch (error) {
      // print(error);
      rethrow;
    }
  }

  // Future<GetFaqs> getFaqsRequest({required String batchId}) async {
  //   try {
  //     Response response = await dioAuthorizationData().get(
  //       Apis.baseUrl + Apis.getFaqs,
  //       queryParameters: {
  //         "batchId": batchId,
  //       },
  //     );
  //     print(response.data);
  //     return GetFaqs.fromJson(response.data);
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  Future<Response> getOrdersPdfUrlRequest({required String batchId, required String batchName, required String amount}) async {
    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.getOrdersPdfUrl,
        data: {
          "batchId": batchId,
          "batchName": batchName,
          "amount": amount,
        },
      );
      // print(response.data);
      return response.data;
    } catch (error) {
      rethrow;
    }
  }

  //recorded video comments
  Future<GetRecordedVideoComments> getRecordedVideoCommentsRequest({
    required String lectureId,
  }) async {
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getRecordedComments,
        queryParameters: {
          "lectureId": lectureId,
        },
      );
      // print(response.data);
      return GetRecordedVideoComments.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> postCommentRequest({required String commentText, required String lectureId}) async {
    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.postCommentForRecorded,
        data: {
          "commentText": commentText,
          "lectureId": lectureId,
        },
      );
      // print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> editCommentRequest({
    required String commentText,
    required String commentId,
  }) async {
    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.editCommentForRecorded,
        data: {
          "commentText": commentText,
          "commentId": commentId,
        },
      );
      // print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> deleteCommentRecordedVideoRequest({
    required String commentId,
  }) async {
    try {
      Response response = await dioAuthorizationData().delete(
        Apis.baseUrl + Apis.deleteCommentForRecorded,
        queryParameters: {
          "commentId": commentId,
        },
      );
      // print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> pinCommentRequest({
    required String commentId,
  }) async {
    try {
      Response response = await dioAuthorizationData().put(
        Apis.baseUrl + Apis.markCommentToPin,
        queryParameters: {
          "commentId": commentId
        },
      );
      // print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> markCommentToReportRequest({
    required String commentId,
  }) async {
    try {
      Response response = await dioAuthorizationData().put(
        Apis.baseUrl + Apis.markCommentToReport,
        queryParameters: {
          "commentId": commentId
        },
      );
      // print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> replyToCommentForRecordedRequest({required String commentText, required String replyTo, required String lectureId}) async {
    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.replyToCommentForRecorded,
        data: {
          "commentText": commentText,
          "replyTo": replyTo,
          "lectureId": lectureId,
        },
      );
      // print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> reportFeedRequest({
    required String commentId,
  }) async {
    try {
      Response response = await dioAuthorizationData().put(
        Apis.baseUrl + Apis.markCmsCommentToReport,
        queryParameters: {
          "commentId": commentId,
        },
      );
      // print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> pinFeedRequest({
    required String commentId,
  }) async {
    try {
      Response response = await dioAuthorizationData().put(
        Apis.baseUrl + Apis.markCmsCommentToPinOrUnpin,
        queryParameters: {
          "commentId": commentId,
        },
      );
      // print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

//ebook
  Future<GetAllEbooks> getAllEbooksRequest({
    int page = 1,
    int pageSize = 10,
    String? category,
    String? language,
    int? minPrice,
    int? maxPrice,
    String? sort,
  }) async {
    Map<String, dynamic> data = {
      "page": page,
      "pageSize": pageSize,
      if (category != null && category.isNotEmpty) "category": category,
      if (language != null && language.isNotEmpty) "language": language,
      if (minPrice != null) "minPrice": minPrice,
      if (maxPrice != null) "maxPrice": maxPrice,
      if (sort != null && sort.isNotEmpty) "priceSort": sort
    };
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getAllEbooks,
        queryParameters: data,
      );
      // print(response.data);
      return GetAllEbooks.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetEbooksById> getEbookByIdRequest({required String id}) async {
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getEbookById,
        queryParameters: {
          "id": id
        },
      );
      // print(response.data);
      return GetEbooksById.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<PostCreateOrderEbook> postCreateOrderEbookRequest({
    required String ebookId,
    required String totalAmount,
  }) async {
    try {
      Map<String, dynamic> data = {
        "ebookId": ebookId,
        "totalAmount": totalAmount
      };
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.postEbookInitiatePayment,
        data: data,
      );
      // print(response.data);
      return PostCreateOrderEbook.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> postVerifyPaymentEbookRequest({required String orderId}) async {
    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.postVerifyEbookPayment,
        queryParameters: {
          "orderId": orderId
        },
      );
      // print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> postFreePaymentEbookRequest({required String ebookid}) async {
    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.freeEbookPurchase,
        queryParameters: {
          "ebookId": ebookid
        },
      );
      // print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetMyEbooks> getMyEbookRequest() async {
    try {
      Response response = await dioAuthorizationData().get(Apis.baseUrl + Apis.getMyEbooks);
      // print(response.data);
      return GetMyEbooks.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetMyEbooksById> getMyEbookByIdRequest({required String id}) async {
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getMyEbookById + id,
      );
      // print(response.data);
      return GetMyEbooksById.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetTopic> getTopicRequest({required String topicId, required String ebookId}) async {
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getEbookTopic,
        queryParameters: {
          "topicId": topicId,
          "ebookId": ebookId
        },
      );
      // print(response.data);
      return GetTopic.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetEbooksReviews> getEbookReviewsRequest({
    int page = 1,
    int pageSize = 10,
    required String? id,
  }) async {
    Map<String, dynamic> data = {
      "page": page,
      "pageSize": pageSize,
      "id": id
    };
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getEbookReviews,
        queryParameters: data,
      );
      // print(response.data);
      return GetEbooksReviews.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> postEbookReviewRequest({
    required String ebookid,
    required String title,
    required int rating,
  }) async {
    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.ebookPostReview,
        data: {
          "ebookId": ebookid,
          "title": title,
          "rating": rating,
        },
      );
      // print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> postCreateADoubt({
    required String batchId,
    required String desc,
    required String lectureId,
    required String subjectId,
    required XFile? file,
  }) async {
    final FormData data = FormData.fromMap({
      "batchId": batchId,
      "desc": desc,
      "lectureId": lectureId,
      "subjectId": subjectId,
      if (file != null)
        "file": await MultipartFile.fromFile(
          file.path,
          filename: file.name,
        ),
    });

    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.createDoubt,
        data: data,
      );
      // print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<Doubt?> editBatchDoubt({
    required String batchDoubtId,
    required String problemImage,
    required String desc,
    required XFile? file,
  }) async {
    final FormData data = FormData.fromMap({
      "batchDoubtId": batchDoubtId,
      "problemImage": problemImage,
      "desc": desc,
      if (file != null)
        "file": await MultipartFile.fromFile(
          file.path,
          filename: file.name,
        )
    });
    try {
      Response response = await dioAuthorizationData().put(
        Apis.baseUrl + Apis.editBatchDoubt,
        data: data,
      );
      flutterToast(response.data["msg"]);
      return response.data["data"] == null ? null : Doubt.fromMap(response.data["data"]);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> deleteBatchDoubt({
    required String doubtId,
  }) async {
    final Map<String, dynamic> data = {
      "doubtId": doubtId,
    };

    try {
      Response response = await dioAuthorizationData().delete(
        Apis.baseUrl + Apis.deleteBatchDoubt,
        queryParameters: data,
      );
      flutterToast(response.data["msg"]);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetBatchDoubts> getMyCoursesDoubts({
    required String batchId,
    required int page,
    int pageSize = 10,
  }) async {
    final Map<String, dynamic> data = {
      "batchId": batchId,
      "page": page,
      "pageSize": pageSize
    };

    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getBatchDoubts,
        queryParameters: data,
      );
      // print(response.data);
      return GetBatchDoubts.fromJson(jsonEncode(response.data));
    } catch (error) {
      rethrow;
    }
  }

  Future<GetBatchDoubts> getMyCoursesMYDoubts({
    required String batchId,
    required int page,
    int pageSize = 10,
  }) async {
    final Map<String, dynamic> data = {
      "batchId": batchId,
      "page": page,
      "pageSize": pageSize
    };

    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getMyBatchDoubts,
        queryParameters: data,
      );
      // print(response.data);
      return GetBatchDoubts.fromJson(jsonEncode(response.data));
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> postBatchDoubtLikeAndDislike({
    required String batchDoubtId,
  }) async {
    final Map<String, dynamic> data = {
      "batchDoubtId": batchDoubtId
    };

    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.batchDoubtLikeAndDislike,
        data: data,
      );
      // print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> postBatchDoubtReport({
    required String batchDoubtId,
    required String reason,
  }) async {
    final Map<String, dynamic> data = {
      "batchDoubtId": batchDoubtId,
      "reason": reason
    };

    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.reportDoubt,
        data: data,
      );
      // print(response.data);
      flutterToast(response.data["msg"]);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<Doubt> getBatchDoubtById({
    required String batchDoubtId,
  }) async {
    final Map<String, dynamic> data = {
      "batchDoubtId": batchDoubtId,
    };

    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getDoubtById,
        queryParameters: data,
      );
      // print(response.data);
      return Doubt.fromMap(response.data["data"]);
    } catch (error) {
      rethrow;
    }
  }

  Future<DoubtComment> postBatchDoubtComment({
    required String batchDoubtId,
    required String msg,
    XFile? file,
  }) async {
    final FormData data = FormData.fromMap({
      "batchDoubtId": batchDoubtId,
      "msg": msg,
      if (file != null)
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.name,
        ),
    });

    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.postBatchDoubtComment,
        data: data,
      );
      // print(response.data);
      flutterToast(response.data["msg"]);
      return DoubtComment.fromMap(response.data["data"]);
    } catch (error) {
      rethrow;
    }
  }

  Future<DoubtComment> editBatchDoubtComment({
    required String commentId,
    required String msg,
    required String image,
    XFile? file,
  }) async {
    final FormData data = FormData.fromMap({
      "commentId": commentId,
      "msg": msg,
      "image": image,
      if (file != null)
        'file': await MultipartFile.fromFile(
          file.path,
          filename: file.name,
        ),
    });

    try {
      Response response = await dioAuthorizationData().put(
        Apis.baseUrl + Apis.editDoubtComment,
        data: data,
      );
      // print(response.data);
      flutterToast(response.data["msg"]);
      return DoubtComment.fromMap(response.data["data"]);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> deleteBatchDoubtComment({
    required String commentId,
  }) async {
    final Map<String, dynamic> data = {
      "commentId": commentId,
    };

    try {
      Response response = await dioAuthorizationData().delete(
        Apis.baseUrl + Apis.deleteDoubtComment,
        queryParameters: data,
      );
      // print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> postDoubtCommentReport({
    required String commentId,
    required String reason,
  }) async {
    final Map<String, dynamic> data = {
      "commentId": commentId,
      "reason": reason
    };

    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.reportDoubt,
        data: data,
      );
      // print(response.data);
      flutterToast(response.data["msg"]);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> postCreateACommunity({
    required String batchId,
    required String desc,
    required XFile? file,
  }) async {
    final FormData data = FormData.fromMap({
      "batchId": batchId,
      "desc": desc,
      if (file != null)
        "file": await MultipartFile.fromFile(
          file.path,
          filename: file.name,
        ),
    });

    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.createCommunity,
        data: data,
      );
      // print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<Community> postEditACommunity({
    required String batchCommunityId,
    required String desc,
    required String problemImage,
    required XFile? file,
  }) async {
    final FormData data = FormData.fromMap({
      "batchCommunityId": batchCommunityId,
      "desc": desc,
      "problemImage": problemImage,
      if (file != null)
        "file": await MultipartFile.fromFile(
          file.path,
          filename: file.name,
        ),
    });
    try {
      Response response = await dioAuthorizationData().put(
        Apis.baseUrl + Apis.editCommunity,
        data: data,
      );
      // print(response.data);
      flutterToast(response.data['msg']);
      return Community.fromMap(response.data['data']);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetCommunity> getMyCommunity({
    required String batchId,
    required int page,
    int pageSize = 10,
  }) async {
    final Map<String, dynamic> data = {
      "batchId": batchId,
      "page": page,
      "pageSize": pageSize
    };

    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getBatchCommunity,
        queryParameters: data,
      );
      // print(response.data);
      return GetCommunity.fromJson(jsonEncode(response.data));
    } catch (error) {
      rethrow;
    }
  }

  Future<GetCommunity> getMybatchMyCommunity({
    required String batchId,
    required int page,
    int pageSize = 10,
  }) async {
    final Map<String, dynamic> data = {
      "batchId": batchId,
      "page": page,
      "pageSize": pageSize
    };

    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getBatchMyCommunities,
        queryParameters: data,
      );
      // print(response.data);
      return GetCommunity.fromJson(jsonEncode(response.data));
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> postCommunityLikeAndDislike({
    required String batchCommunityId,
  }) async {
    final Map<String, dynamic> data = {
      "batchCommunityId": batchCommunityId
    };

    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.batchCommunityLikeAndDislike,
        data: data,
      );
      // print(response.data);
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<Community?> getCommunityById({
    required String batchCommunityId,
  }) async {
    final Map<String, dynamic> data = {
      "batchCommunityId": batchCommunityId,
    };

    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getCommunityById,
        queryParameters: data,
      );
      // print(response.data);
      if (response.data["status"]) {
        return Community.fromMap(response.data["data"]);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  Future<get_community_comments.GetCommunityComments> getCommunityComments({
    required int page,
    required int pageSize,
    required String batchCommunityId,
  }) async {
    final Map<String, dynamic> data = {
      "page": page,
      "pageSize": pageSize,
      "batchCommunityId": batchCommunityId
    };

    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getCommunityComments,
        queryParameters: data,
      );
      // print(response.data);

      return get_community_comments.GetCommunityComments.fromMap(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<get_community_comments.Comment?> postCommunityComments({
    required String msg,
    required String batchCommunityId,
    XFile? file,
  }) async {
    final FormData data = FormData.fromMap({
      "batchCommunityId": batchCommunityId,
      "msg": msg,
      if (file != null)
        "file": await MultipartFile.fromFile(
          file.path,
          filename: file.name,
        ),
    });

    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.postBatchCommunityComment,
        data: data,
      );
      // print(response.data);
      flutterToast(response.data["msg"]);
      return get_community_comments.Comment.fromMap(response.data["data"]);
    } catch (error) {
      rethrow;
    }
  }

  Future<get_community_comments.Comment?> editCommunityComments({required String commentId, required String msg, required String image, XFile? file}) async {
    final data = FormData.fromMap({
      "commentId": commentId,
      "msg": msg,
      "image": image,
      if (file != null)
        "file": await MultipartFile.fromFile(
          file.path,
          filename: file.name,
        ),
    });

    try {
      Response response = await dioAuthorizationData().put(
        Apis.baseUrl + Apis.editCommunityComment,
        data: data,
      );
      // print(response.data);
      flutterToast(response.data["msg"]);
      return get_community_comments.Comment.fromMap(response.data["data"]);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteCommunityComments({required String commentId}) async {
    final Map<String, dynamic> data = {
      "commentId": commentId,
    };

    try {
      Response response = await dioAuthorizationData().delete(
        Apis.baseUrl + Apis.deleteCommunityComment,
        queryParameters: data,
      );
      // print(response.data);
      flutterToast(response.data["msg"]);
      return response.data['status'] ? true : false;
    } catch (error) {
      return false;
    }
  }

  Future<get_community_comments.Reply?> postCommunityCommentsReply({
    required String msg,
    required String commentId,
  }) async {
    final Map<String, dynamic> data = {
      "commentId": commentId,
      "msg": msg,
    };
    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.communityReplyToComments,
        data: data,
      );
      // print(response.data);
      flutterToast(response.data["msg"]);
      return get_community_comments.Reply.fromMap(response.data["data"]);
    } catch (error) {
      rethrow;
    }
  }

  Future<get_community_comments.Reply?> editCommunityCommentsReply({
    required String replyId,
    required String msg,
  }) async {
    final Map<String, dynamic> data = {
      "replyCommentId": replyId,
      "msg": msg,
    };

    try {
      Response response = await dioAuthorizationData().put(
        Apis.baseUrl + Apis.editCommunityReplyComment,
        data: data,
      );
      // print(response.data);
      flutterToast(response.data["msg"]);
      return get_community_comments.Reply.fromMap(response.data["data"]);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteCommunityCommentsReply({required String replyId}) async {
    final Map<String, dynamic> data = {
      "replyCommentId": replyId,
    };

    try {
      Response response = await dioAuthorizationData().delete(
        Apis.baseUrl + Apis.deleteCommunityReplyComment,
        queryParameters: data,
      );
      // print(response.data);
      flutterToast(response.data["msg"]);
      return response.data['status'] ? true : false;
    } catch (error) {
      return false;
    }
  }

  Future<bool> postReportComment({required String commentId, required String msg}) async {
    final Map<String, dynamic> data = {
      "commentId": commentId,
      "reason": msg,
    };
    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.reportComment,
        data: data,
      );
      flutterToast(response.data["msg"]);
      return response.data['status'] ? true : false;
    } catch (error) {
      return false;
    }
  }

  Future<bool> postReportCommentReply({required String replyCommentId, required String msg}) async {
    final Map<String, dynamic> data = {
      "replyCommentId": replyCommentId,
      "reason": msg,
    };
    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.reportReplyComment,
        data: data,
      );
      flutterToast(response.data["msg"]);
      return response.data['status'] ? true : false;
    } catch (error) {
      return false;
    }
  }

  Future<bool> postReportCommunity({required String batchCommunityId, required String msg}) async {
    final Map<String, dynamic> data = {
      "batchCommunityId": batchCommunityId,
      "reason": msg,
    };
    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.reportCommunity,
        data: data,
      );
      flutterToast(response.data["msg"]);
      return response.data['status'] ? true : false;
    } catch (error) {
      return false;
    }
  }

  // short learning
  Future<GetShortVideos> getShortVideos({required int page, int pageSize = 10}) async {
    final Map<String, dynamic> data = {
      "page": page,
      "pageSize": pageSize,
    };
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getShortVideos,
        queryParameters: data,
      );
      return GetShortVideos.fromMap(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<Short> getShortVideosDetails({
    required int shortId,
  }) async {
    final Map<String, dynamic> data = {
      "shortId": shortId,
    };
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getShortByid,
        queryParameters: data,
      );
      return Short.fromMap(response.data["data"]);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetShortChannel> getShortChannelProfile({
    required String channelId,
  }) async {
    final Map<String, dynamic> data = {
      "channelId": channelId,
    };
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getchannelProfile,
        queryParameters: data,
      );
      return GetShortChannel.fromMap(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetShortVideos> getShortVideosByChannelId({required String channelId, required int page, int pageSize = 10}) async {
    final Map<String, dynamic> data = {
      "channelId": channelId,
      "page": page,
      "pageSize": pageSize
    };
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getShortVideosByChannel,
        queryParameters: data,
      );
      return GetShortVideos.fromMap(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> postSubscribeChannel({required String channelId}) async {
    final Map<String, dynamic> data = {
      "channelId": channelId,
    };
    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.channelSubscribeOrUnSubscribe,
        data: data,
      );
      flutterToast(response.data["msg"]);
      return response.data["status"];
    } catch (error) {
      return false;
    }
  }

  Future<bool> postLikeShort({required String shortId}) async {
    final Map<String, dynamic> data = {
      "shortId": shortId,
    };
    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.likeOrRemoveLikeOfShort,
        data: data,
      );
      flutterToast(response.data["msg"]);
      return response.data["status"];
    } catch (error) {
      return false;
    }
  }

  Future<bool> postSaveShort({required String shortId}) async {
    final Map<String, dynamic> data = {
      "shortId": shortId,
    };
    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.postMakeSaveOrUnsaveShort,
        data: data,
      );
      flutterToast(response.data["msg"]);
      return response.data["status"];
    } catch (error) {
      return false;
    }
  }

  Future<GetShortVideos> getMySavedShort({required int page, int pageSize = 10}) async {
    final Map<String, dynamic> data = {
      "page": page,
      "pageSize": pageSize
    };
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getMySavedShort,
        queryParameters: data,
      );
      return GetShortVideos.fromMap(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> postViewShort({required String shortId}) async {
    final Map<String, dynamic> data = {
      "shortId": shortId,
    };
    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.postViewedShort,
        data: data,
      );
      return response.data["status"];
    } catch (error) {
      return false;
    }
  }

  Future<bool> postReportShort({required String shortId, required String msg}) async {
    final Map<String, dynamic> data = {
      "shortId": shortId,
      "reason": msg,
    };
    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.postReportShort,
        data: data,
      );
      flutterToast(response.data["msg"]);
      return response.data['status'] ? true : false;
    } catch (error) {
      return false;
    }
  }

  //Short Comment for the short
  Future<GetShortComments> getShortComments({
    required int page,
    required int pageSize,
    required String shortId,
  }) async {
    final Map<String, dynamic> data = {
      "page": page,
      "pageSize": pageSize,
      "shortId": shortId
    };

    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getShortComments,
        queryParameters: data,
      );
      // print(response.data);

      return GetShortComments.fromMap(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<ShortComment?> postCommentsInShort({
    required String msg,
    required String shortId,
  }) async {
    final Map<String, dynamic> data = {
      "shortId": shortId,
      "msg": msg,
    };

    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.addCommentToShort,
        data: data,
      );
      // print(response.data);
      flutterToast(response.data["msg"]);
      return ShortComment.fromMap(response.data["data"]);
    } catch (error) {
      rethrow;
    }
  }

  Future<ShortComment?> editShortComments({
    required String commentId,
    required String msg,
  }) async {
    final data = {
      "commentId": commentId,
      "msg": msg,
    };

    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.editCommentToShort,
        data: data,
      );
      // print(response.data);
      flutterToast(response.data["msg"]);
      return ShortComment.fromMap(response.data["data"]);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteShortComments({required String commentId}) async {
    final Map<String, dynamic> data = {
      "commentId": commentId,
    };

    try {
      Response response = await dioAuthorizationData().delete(
        Apis.baseUrl + Apis.deleteShortComment,
        queryParameters: data,
      );
      // print(response.data);
      flutterToast(response.data["msg"]);
      return response.data['status'] ? true : false;
    } catch (error) {
      return false;
    }
  }

  Future<ShortCommentReply?> postShortCommentsReply({
    required String msg,
    required String commentId,
    required String replyTo,
  }) async {
    final Map<String, dynamic> data = {
      "commentId": commentId,
      "msg": msg,
      "replyTo": replyTo
    };
    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.replyToCommentsShort,
        data: data,
      );
      // print(response.data);
      flutterToast(response.data["msg"]);
      return ShortCommentReply.fromMap(response.data["data"]);
    } catch (error) {
      rethrow;
    }
  }

  Future<ShortCommentReply?> editShortCommentsReply({
    required String replyId,
    required String msg,
  }) async {
    final Map<String, dynamic> data = {
      "replyCommentId": replyId,
      "msg": msg,
    };

    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.editReplyCommentShort,
        data: data,
      );
      // print(response.data);
      flutterToast(response.data["msg"]);
      return ShortCommentReply.fromMap(response.data["data"]);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteShortCommentsReply({required String replyId}) async {
    final Map<String, dynamic> data = {
      "replyCommentId": replyId,
    };

    try {
      Response response = await dioAuthorizationData().delete(
        Apis.baseUrl + Apis.deleteReplyCommentShort,
        queryParameters: data,
      );
      // print(response.data);
      flutterToast(response.data["msg"]);
      return response.data['status'] ? true : false;
    } catch (error) {
      return false;
    }
  }

  Future<bool> postReportCommentShort({required String commentId, required String msg}) async {
    final Map<String, dynamic> data = {
      "commentId": commentId,
      "reason": msg,
    };
    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.reportComment,
        data: data,
      );
      flutterToast(response.data["msg"]);
      return response.data['status'] ? true : false;
    } catch (error) {
      return false;
    }
  }

  Future<bool> postReportCommentReplyShort({required String replyCommentId, required String msg}) async {
    final Map<String, dynamic> data = {
      "replyCommentId": replyCommentId,
      "reason": msg,
    };
    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.reportReplyComment,
        data: data,
      );
      flutterToast(response.data["msg"]);
      return response.data['status'] ? true : false;
    } catch (error) {
      return false;
    }
  }

  Future<GetNeedHelp> getHelpandSupportRequest() async {
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.helpandsupport,
      );
      return GetNeedHelp.fromMap(response.data);
    } catch (error) {
      return GetNeedHelp.fromMap(helpAndSupport);
    }
  }

  Future<GetResultBanner> getResultBannerRequest({required String year, required String? streamid}) async {
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getResultBanner,
        queryParameters: {
          "year": year,
          "category": streamid
        },
      );
      if (response.data["status"] == false) {
        flutterToast(response.data["msg"]);
      }
      return GetResultBanner.fromMap(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetSuccessStories> getResultStoreRequest({required String year, required String? streamid}) async {
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.successStories,
        queryParameters: {
          "year": year,
          "category": streamid
        },
      );
      if (response.data["status"] == false) {
        flutterToast(response.data["msg"]);
      }
      return GetSuccessStories.fromMap(response.data);
    } catch (error) {
      rethrow;
    }
  }

  // library
  Future<GetLibraryTopperNotes> getToperNotesRequest({required String subCategory, required String catagory}) async {
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getLibraryNotes,
        queryParameters: {
          "subCategory": subCategory,
          "category": catagory
        },
      );
      if (response.data["status"] == false) {
        flutterToast(response.data["msg"]);
      }
      return GetLibraryTopperNotes.fromMap(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetLibraryTopperNotes> getSyllabusRequest({required String year, required String catagory}) async {
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getLibrarySyllabus,
        queryParameters: {
          "year": year,
          "category": catagory
        },
      );
      if (response.data["status"] == false) {
        flutterToast(response.data["msg"]);
      }
      return GetLibraryTopperNotes.fromMap(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetPyqsNotes> getPyqsRequest({required String subCategory, required String catagory}) async {
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getLibraryPyqs,
        queryParameters: {
          "subCategory": subCategory,
          "category": catagory
        },
      );
      if (response.data["status"] == false) {
        flutterToast(response.data["msg"]);
      }
      return GetPyqsNotes.fromMap(response.data);
    } catch (error) {
      rethrow;
    }
  }

  // quiz api in Library

  Future<GetQuizLibrary> getLibraryQuizRequest({required String subCategory, required String catagory}) async {
    try {
      // print("subCategory: $subCategory, catagory: $catagory");
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getLibraryQuizes,
        queryParameters: {
          "subCategory": subCategory,
          "category": catagory
        },
      );
      if (response.data["status"] == false) {
        flutterToast(response.data["msg"]);
      }
      // print(response.data);
      return GetQuizLibrary.fromMap(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<GetQuizQuestionLibrary> getLibraryQuizQuestionRequest({
    required String quizId,
  }) async {
    try {
      Response response = await dioAuthorizationData().get(
        Apis.baseUrl + Apis.getLibraryQuizQuestion,
        queryParameters: {
          "quizId": quizId
        },
      );
      if (response.data["status"] == false) {
        flutterToast(response.data["msg"]);
      }
      return GetQuizQuestionLibrary.fromMap(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> submitRatingQuizLibrary({required int rating, required String quizId, required String comment}) async {
    try {
      Response response = await dioAuthorizationData().post(Apis.baseUrl + Apis.submitRatingQuizLibrary, data: {
        "rating": rating, // enum = [1 , 2, 3, ,4 ,5]
        "quizId": quizId
      });
      if (response.data["status"] == false) {
        flutterToast(response.data["msg"]);
      }
      return response.data['status'];
    } catch (error) {
      return false;
    }
  }

  // library Video Learning
  Future<GetListVideoLearingLibrary> getVideoLeariningLibraryRequest({required String catagory, required String subCategory}) async {
    try {
      Response response = await dioAuthorizationData().get(Apis.baseUrl + Apis.getLibraryVideoLearning, queryParameters: {
        "category": catagory,
        "subCategory": subCategory
      });
      if (response.data["status"] == false) {
        flutterToast(response.data["msg"]);
      }
      return GetListVideoLearingLibrary.fromMap(response.data);
    } catch (error) {
      rethrow;
    }
  }
  // library Video Learning Comments

  Future<GetListVideoLearingCommentLibrary> getVideoLeariningLibraryCommentsRequest({required String videoId}) async {
    try {
      Response response = await dioAuthorizationData().get(Apis.baseUrl + Apis.getVideoComments, queryParameters: {
        "videoId": videoId
      });
      if (response.data["status"] == false) {
        flutterToast(response.data["msg"]);
      }
      return GetListVideoLearingCommentLibrary.fromMap(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> postVideoLeariningLibraryCommentsRequest({required String videoId, required String comment}) async {
    try {
      Response response = await dioAuthorizationData().post(Apis.baseUrl + Apis.postVideoComment, data: {
        "videoId": videoId,
        "msg": comment
      });
      if (response.data["status"] == false) {
        flutterToast(response.data["msg"]);
      }
      return BaseModel(status: response.data["status"], data: GetListVideoLearingCommentLibraryData.fromMap(response.data["data"]), msg: response.data["msg"]);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> editVideoLeariningLibraryCommentsRequest({required String videoId, required String commentid, required String comment}) async {
    try {
      Response response = await dioAuthorizationData().put(
        Apis.baseUrl + Apis.editVideoComment,
        data: {
          "videoId": videoId,
          "msg": comment,
          "commentId": commentid
        },
      );
      if (response.data["status"] == false) {
        flutterToast(response.data["msg"]);
      }
      return BaseModel(status: response.data["status"], data: GetListVideoLearingCommentLibraryData.fromMap(response.data["data"]), msg: response.data["msg"]);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> deleteVideoLeariningLibraryCommentsRequest({required String commentid}) async {
    try {
      Response response = await dioAuthorizationData().delete(
        Apis.baseUrl + Apis.removeVideoComment + commentid,
      );
      flutterToast(response.data["msg"]);
      return response.data["status"];
    } catch (error) {
      return false;
    }
  }

  Future<BaseModel> postVideoLeariningLibraryCommentsReplyRequest({required String videoId, required String commentid, required String msg, required String replyTo}) async {
    try {
      Response response = await dioAuthorizationData().post(
        Apis.baseUrl + Apis.postVideoCommentReply,
        data: {
          "videoId": videoId,
          "msg": msg,
          "commentId": commentid,
          "replyTo": replyTo
        },
      );
      if (response.data["status"] == false) {
        flutterToast(response.data["msg"]);
      }
      return BaseModel(status: response.data["status"], data: GetListVideoLearingCommentLibraryData.fromMap(response.data["data"]), msg: response.data["msg"]);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> submitRatingVideoLearingLibrary({required int rating, required String videoId, required String comment}) async {
    try {
      Response response = await dioAuthorizationData().post(Apis.baseUrl + Apis.postVideoRating, data: {
        "title": comment,
        "youtubeId": videoId,
        "rating": rating
      });
      if (response.data["status"] == false) {
        flutterToast(response.data["msg"]);
      }
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<BaseModel> submitReportVideoLearingLibrary({required String videoId, required String comment}) async {
    try {
      Response response = await dioAuthorizationData().post(Apis.baseUrl + Apis.postVideoReport, data: {
        "desc": comment,
        "youtubeId": videoId
      });
      if (response.data["status"] == false) {
        flutterToast(response.data["msg"]);
      }
      return BaseModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }
}
