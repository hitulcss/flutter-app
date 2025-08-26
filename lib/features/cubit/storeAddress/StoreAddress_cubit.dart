// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/base_model.dart';
import 'package:sd_campus_app/features/data/remote/models/get_pincode.dart';
import 'package:sd_campus_app/features/data/remote/models/get_store_address.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';

part 'StoreAddress_state.dart';

class StoreAddressCubit extends Cubit<StoreAddressState> {
  StoreAddressCubit() : super(StoreAddressInitial());
  RemoteDataSourceImpl remoteDataSourceImpl = RemoteDataSourceImpl();
  GetStoreAddress? data;
  int? selectStoreAddress = 0;

  Future<GetStoreAddress?> getStoreAddressapi({String? productId, int? productQty}) async {
    // GetStoreAddress getStoreAddress=GetStoreAddress(status: false,);
    emit(StoreAddressLoading());
    return await getstoreAddress();
  }

  selectAddress({required int id}) {
    selectStoreAddress = id;
    emit(StoreAddressSelect());
    getstoreAddress();
  }

  removefromStoreAddress({required id}) {
    remoteDataSourceImpl.removeStoreAddressRequest(id: id).catchError((error, stackTrace) {
      emit(StoreAddressApiError());
      return onerror();
    }).then((value) => getstoreAddress());
  }

  Future<bool> updatefromStoreAddress({
    required String email,
    required String name,
    required String phone,
    required String streetAddress,
    required String city,
    required String country,
    required String state,
    required String pinCode,
    String? addressId,
  }) async {
    List<GetPinCode> getPincode = await RemoteDataSourceImpl().getPincodeRequest();

    if (getPincode.any((element) => element.pincode.toString() == pinCode)) {
      BaseModel baseModel = await remoteDataSourceImpl.addAddressRequest(
        email: email,
        name: name,
        phone: phone,
        streetAddress: streetAddress,
        city: city,
        country: country,
        state: state,
        pinCode: pinCode,
      );
      if (baseModel.status) {
        getstoreAddress();
      }
      return true;
    } else {
      flutterToast("Delivery not available at this pincode");
      return false;
    }
  }

  onerror() {
    emit(StoreAddressApiError());
  }

  Future<GetStoreAddress?> getstoreAddress() async {
    await remoteDataSourceImpl.getStoreAddressRequest().then((value) {
      data = value;
      emit(
        StoreAddressApiSuccess(getStoreAddress: value),
      );
    }).catchError((error, stackTrace) {
      emit(StoreAddressApiError());
      onerror();
    });
    return data;
  }
}
