part of 'coupon_cubit.dart';

@immutable
abstract class CouponState {}

class CouponInitial extends CouponState {}

class CouponAddState extends CouponState {
  final String couponid;
  final String couponcode;
  final int value;
  final String coupontype;
  CouponAddState({
    required this.couponid,
    required this.coupontype,
    required this.couponcode,
    required this.value,
  });
}

class CouponRemoveState extends CouponState {}

class TypeOfPayState extends CouponState {}
