part of 'api_bloc.dart';

abstract class ApiState extends Equatable {
  const ApiState();
}

class ApiInitial extends ApiState {
  @override
  List<Object> get props => [];
}

class ApiLoading extends ApiState {
  @override
  List<Object?> get props => [];
}

class ApiError extends ApiState {
  @override
  List<Object?> get props => [];
}

// class ApiCartDetailsSuccess extends ApiState{
//   final List<CartDataModel> cartData;
//   const ApiCartDetailsSuccess({required this.cartData});
//   @override
//   List<Object?> get props => [cartData];
// }

class ApiMyCoursesSuccess extends ApiState {
  final List<MyCoursesDataModel> myCourses;
  const ApiMyCoursesSuccess({required this.myCourses});
  @override
  List<Object?> get props => [
        myCourses
      ];
}

class ApiResourcesSuccess extends ApiState {
  final BatchNotesModel resources;
  const ApiResourcesSuccess({required this.resources});
  @override
  List<Object?> get props => [
        resources
      ];
}

class ApiYoutubeVideoSuccess extends ApiState {
  final List<VideoDataModel> videoList;
  const ApiYoutubeVideoSuccess({required this.videoList});
  @override
  List<Object?> get props => [
        videoList
      ];
}

class ApiGetSchedulerSuccess extends ApiState {
  final List<MySchedulerDataModel> schedulerList;

  const ApiGetSchedulerSuccess({required this.schedulerList});
  @override
  List<Object?> get props => [];
}

class ApiGetMyclassSchedulerSucces extends ApiState {
  final List<ClassScheduleModel> myclassschedulerList;
  const ApiGetMyclassSchedulerSucces({required this.myclassschedulerList});
  @override
  List<Object?> get props => [];
}
