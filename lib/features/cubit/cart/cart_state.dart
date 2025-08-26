part of 'cart_cubit.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartApiSuccess extends CartState {
  final GetCart getCart;

  CartApiSuccess({required this.getCart});
}

class CartApiError extends CartState {}

class CartQuantity extends CartState {
  final int quantity;

  CartQuantity({required this.quantity});
}
