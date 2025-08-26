part of 'coursefilter_cubit.dart';

sealed class CoursefilterState extends Equatable {
  const CoursefilterState();

  @override
  List<Object> get props => [];
}

final class CoursefilterInitial extends CoursefilterState {}
class CourseStreamSelectedLoading extends CoursefilterState {}

class CourseStreamSelected extends CoursefilterState {
  final SubCategories selected;

  const CourseStreamSelected({required this.selected});
}
class FCourseStreamSelectedLoading extends CoursefilterState {}

class FCourseStreamSelected extends CoursefilterState {
  final SubCategories selected;

  const FCourseStreamSelected({required this.selected});
}