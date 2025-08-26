import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/scheduler_data_source/scheduler_remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/batch_notes_model.dart';
import 'package:sd_campus_app/features/data/remote/models/my_courses_model.dart';
import 'package:sd_campus_app/features/data/remote/models/my_scheduler_model.dart';
import 'package:sd_campus_app/features/data/remote/models/video_model.dart';
import 'package:sd_campus_app/features/domain/reused_function.dart';
import 'package:sd_campus_app/models/classschedule.dart';

part 'api_event.dart';
part 'api_state.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  ApiBloc() : super(ApiInitial()) {
    RemoteDataSourceImpl remoteDataSourceImpl = RemoteDataSourceImpl();
    final schedulerRemoteDataSourceImpl = SchedulerRemoteDataSourceImpl();

    // on<GetCartDetails>((event, emit) async {
    //   try {
    //     var response = await remoteDataSourceImpl.getCartDetails();
    //     if (response.status) {
    //       emit(ApiCartDetailsSuccess(cartData: response.data));
    //     } else {
    //       loginRoute();
    //     }
    //   } catch (error) {
    //     emit(ApiError());
    //   }
    // });

    on<GetMyCourses>((event, emit) async {
      try {
        var response = await remoteDataSourceImpl.getMyCourses();
        if (response.status!) {
          emit(ApiMyCoursesSuccess(myCourses: response.data!));
        } else {
          loginRoute();
        }
      } catch (error) {
        emit(ApiError());
      }
    });

    on<GetmyClassSchedule>((event, emit) async {
      emit(ApiLoading());
      try {
        // ClassSchedulermodel response =
        // await remoteDataSourceImpl.getMyClassSchedule();
        // print(response);
        // if (response.status!) {
        //   emit(ApiGetMyclassSchedulerSucces(myclassschedulerList: response.data!));
        // } else {
        //   flutterToast(response.msg.toString());
        //   loginRoute();
        // }
      } catch (error) {
        // print(error);
        emit(ApiError());
      }
    });

    on<GetYouTubeVideo>((event, emit) async {
      emit(ApiLoading());
      try {
        VideoModel videoData = await remoteDataSourceImpl.getYouTubeVideo();
        if (videoData.status) {
          emit(ApiYoutubeVideoSuccess(videoList: videoData.data));
        } else {
          loginRoute();
        }
      } catch (error) {
        emit(ApiError());
      }
    });
    on<GetMyScheduler>((event, emit) async {
      emit(ApiLoading());
      try {
        MySchedulerModel schedulerData = await schedulerRemoteDataSourceImpl.getSchedule();
        if (schedulerData.status) {
          emit(ApiGetSchedulerSuccess(schedulerList: schedulerData.data));
        } else {
          loginRoute();
        }
      } catch (error) {
        emit(ApiError());
      }
    });
  }
}
