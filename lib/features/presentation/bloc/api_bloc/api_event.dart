part of 'api_bloc.dart';

abstract class ApiEvent extends Equatable {
  const ApiEvent();
}

class GetCartDetails extends ApiEvent {
  @override
  List<Object?> get props => [];
}

class GetMyCourses extends ApiEvent {
  @override
  List<Object?> get props => [];
}
class GetmyClassSchedule extends ApiEvent {
  @override
  List<Object?> get props => [];
}

class GetYouTubeVideo extends ApiEvent{
  @override
  List<Object?> get props => [];
}

class GetResources extends ApiEvent {
  final String key;
  final String value;
  const GetResources({required this.key,required this.value});

  @override
  List<Object?> get props => [key,value];
}

class GetMyScheduler extends ApiEvent{
  @override
  List<Object?> get props => [];

}