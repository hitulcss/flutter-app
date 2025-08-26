part of 'coin_cubit.dart';

@immutable
abstract class CoinState {}

class CoinInitial extends CoinState {}

class IsCoinState extends CoinState {
  final bool isselected;

  IsCoinState({required this.isselected});
}