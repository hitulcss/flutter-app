import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sd_campus_app/features/data/remote/models/stream_model.dart';

part 'coursefilter_state.dart';

class CoursefilterCubit extends Cubit<CoursefilterState> {
  CoursefilterCubit() : super(CoursefilterInitial());
  SubCategories courseStreamSelected({required SubCategories selected}) {
    emit(CourseStreamSelectedLoading());
    emit(CourseStreamSelected(selected: selected));
    return selected;
  }

  SubCategories fCourseStreamSelected({required SubCategories selected}) {
    emit(FCourseStreamSelectedLoading());
    emit(FCourseStreamSelected(selected: selected));
    return selected;
  }

  void updateState() {
    emit(CoursefilterInitial());
    emit(CourseStreamSelectedLoading());
  }
}
