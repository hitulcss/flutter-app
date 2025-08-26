import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'coin_state.dart';

class CoinCubit extends Cubit<CoinState> {
  CoinCubit() : super(CoinInitial());
  
  bool isapplyedcoin = false;
    bool getcoinApplied({bool? isselected}) {
    if (isselected != null) {
      emit(CoinInitial());
      isapplyedcoin = isselected;
      emit(IsCoinState(isselected: isselected));
    }
    return isapplyedcoin;
  }
}
