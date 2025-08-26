import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';

part 'hometimer_state.dart';

class HometimerCubit extends Cubit<HometimerState> {
  HometimerCubit() : super(HometimerInitial());

  var a = SharedPreferenceHelper.getBoolean(Preferences.timerisset);
  void timercheck({required int val}) {
    if (val < 1) {
      emit(TimerButton());
    } else {
      emit(TimerText());
    }
  }
}
