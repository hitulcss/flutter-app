part of 'streamsetect_cubit.dart';

abstract class StreamsetectState extends Equatable {
  const StreamsetectState();

  @override
  List<Object> get props => [];
}

class StreamsetectInitial extends StreamsetectState {}

class SelectedStream extends StreamsetectState {}

class StreamLoading extends StreamsetectState {}

class StreamError extends StreamsetectState {}

class SelectCategoryLoading extends StreamsetectState {}

class SelectCategory extends StreamsetectState {
  final List<PYQModelData> sortdata;

  const SelectCategory({required this.sortdata});
}

class TopCourseStreamSelected extends StreamsetectState {
  final String selected;

  const TopCourseStreamSelected({required this.selected});
}