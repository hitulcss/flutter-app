
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sd_campus_app/features/controller/auth_controller.dart';
import 'package:sd_campus_app/features/data/remote/models/pyq_model.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';

part 'streamsetect_state.dart';

class StreamsetectCubit extends Cubit<StreamsetectState> {
  StreamsetectCubit() : super(StreamsetectInitial());
  String? selectStreamuser;
  int selectedIndex = 0;
  String? getSlectedStream() {
    try {
      emit(StreamsetectInitial());
      selectStreamuser = SharedPreferenceHelper.getString(Preferences.selectedStream) != "N/A" && SharedPreferenceHelper.getString(Preferences.selectedStream)!.trim().isNotEmpty ? SharedPreferenceHelper.getString(Preferences.selectedStream) : null;
    } on TypeError {
      SharedPreferenceHelper.setString(Preferences.selectedStream, "N/A");
      selectStreamuser = null;
    } catch (e) {
      selectStreamuser = null;
    }
    return selectStreamuser;
  }

  Future<bool> selectStream({required List<String> stream}) async {
    emit(StreamLoading());

    try {
      // print(language);
      if (stream.isNotEmpty) {
        if (await AuthController().updateStreamLanguage(language: SharedPreferenceHelper.getString(Preferences.language), stream: stream)) {
          SharedPreferenceHelper.setStringList(Preferences.course, stream);
          emit(SelectedStream());
          return true;
        } else {
          emit(StreamError());
          return false;
        }
      } else {
        emit(StreamError());
        return false;
      }
    } catch (error) {
      emit(StreamError());
      return false;
    }
  }

  String selectSubCat({
    required List<PYQModelData> defaultData,
    required String selected,
  }) {
    emit(SelectCategoryLoading());
    List<PYQModelData> sortdata = [];
    sortdata.clear();
    for (var element in defaultData) {
      if (element.subCategory!.title == selected) {
        sortdata.add(element);
      }
    }
    emit(SelectCategory(sortdata: sortdata));
    return selected;
  }

  void stateupdate() {
    emit(StreamsetectInitial());
    emit(StreamLoading());
  }

  String topCourseStreamSelected({required String selected}) {
    emit(StreamsetectInitial());
    selectStreamuser = selected;
    SharedPreferenceHelper.setString(Preferences.selectedStream, selected);
    emit(TopCourseStreamSelected(selected: selected));
    return selected;
  }

  int onItemTapped(int index) {
    if (selectedIndex != index) {
      selectedIndex = index;
      emit(StreamsetectInitial());
      emit(SelectedStream());
    }
    return selectedIndex;
  }
}
