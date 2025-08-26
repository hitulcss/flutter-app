import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/get_pincode.dart';

part 'pincode_state.dart';

class PincodeCubit extends Cubit<PincodeState> {
  PincodeCubit() : super(PincodeInitial());
  void pincodecheck({
    required String value,
  }) async {
    emit(PincodeCheck());
    if (value.isEmpty || value.length < 6) {
      emit(PincodeEmpty());
    } else {
      List<GetPinCode> pincode = await RemoteDataSourceImpl().getPincodeRequest();
      for (var element in pincode) {
        if (value == element.pincode.toString()) {
          emit(PincodeFound());
          break;
        } else {
          emit(PincodeNotFound());
        }
      }
    }
  }

  void clearoldstate() {
    emit(PincodeInitial());
  }
}
