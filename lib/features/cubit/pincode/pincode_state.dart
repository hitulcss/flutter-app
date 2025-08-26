part of 'pincode_cubit.dart';

sealed class PincodeState extends Equatable {
  const PincodeState();

  @override
  List<Object> get props => [];
}

final class PincodeInitial extends PincodeState {}
final class PincodeCheck extends PincodeState {}
final class PincodeFound extends PincodeState {}
final class PincodeNotFound extends PincodeState {}
final class PincodeEmpty extends PincodeState {}
