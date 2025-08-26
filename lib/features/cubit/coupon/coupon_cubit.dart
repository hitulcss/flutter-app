import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'coupon_state.dart';

class CouponCubit extends Cubit<CouponState> {
  String couponcodeid = '';

  CouponCubit() : super(CouponInitial());
  bool isapplyedcoin = false;

  void couponadd({
    required String couponcode,
    required int couponvalue,
    required String coupontype,
    required String couponid,
  }) {
    couponcodeid = couponid;
    emit(CouponAddState(
      couponcode: couponcode,
      value: couponvalue,
      coupontype: coupontype,
      couponid: couponid,
    ));
  }

  void couponremove() {
    couponcodeid = '';
    emit(CouponRemoveState());
  }

  void typeofPayment() {
    emit(TypeOfPayState());
  }
}
