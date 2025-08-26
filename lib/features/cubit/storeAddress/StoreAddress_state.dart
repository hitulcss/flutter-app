// ignore_for_file: file_names

part of 'StoreAddress_cubit.dart';

@immutable
abstract class StoreAddressState {}

class StoreAddressInitial extends StoreAddressState {}

class StoreAddressLoading extends StoreAddressState {}

class StoreAddressApiSuccess extends StoreAddressState {
  final GetStoreAddress getStoreAddress;

  StoreAddressApiSuccess({required this.getStoreAddress});
}

class StoreAddressApiError extends StoreAddressState {}
class StoreAddressSelect extends StoreAddressState {}


