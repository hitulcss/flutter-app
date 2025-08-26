import 'package:dio/dio.dart';
import 'package:sd_campus_app/features/data/remote/models/batch_notes_model.dart';
import 'package:sd_campus_app/features/data/remote/models/my_courses_model.dart';
import 'package:sd_campus_app/features/data/remote/models/myorders_model.dart';
import 'package:sd_campus_app/features/data/remote/models/video_model.dart';
import 'package:sd_campus_app/models/Test_series/testserie.dart';
import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart';

abstract class RemoteDataSource {
  Future<VideoModel> getYouTubeVideo();
  // Future<CoursesModel> getCourses();
  Future<TestSeriesModel> getTestSeries();
  // Future<CartModel> getCartDetails();
  Future<MyCoursesModel> getMyCourses();
  Future<Response> addMyCourses(String batchId, bool isPaid);
  // Future<Response> deleteCartCourse(String id);
  Future<CoursesDetailsModel> getCoursesDetails(String batchId);
  Future<MyOrdersModel> getMyOrder();
  // Future<List<RecordedVideoDataModel>> getRecordedVideo({required String batchId,required String subjectId});
  Future<List<BatchNotesModelData>> getBatchNotes({required String batchId, required String subjectId});
}
