part of 'plan_cubit.dart';

sealed class CoursePlanState extends Equatable {
  const CoursePlanState();

  @override
  List<Object> get props => [];
}

final class CoursePlanInitial extends CoursePlanState {}
final class CoursePlanSelected extends CoursePlanState {}
