part of 'hometimer_cubit.dart';

@immutable
abstract class HometimerState {}

class HometimerInitial extends HometimerState {}

class HometimerUpdateUI extends HometimerState {
  final bool timerisset;

  HometimerUpdateUI({required this.timerisset});
}

class TimerText extends HometimerState {}

class TimerButton extends HometimerState {}

