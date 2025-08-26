import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/get_cart.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartInitial());
  RemoteDataSourceImpl remoteDataSourceImpl = RemoteDataSourceImpl();
  int amount = 0;
  Future getcartapi({String? productId, int? productQty}) async {
    // GetCart getCart=GetCart(status: false,);
    emit(CartLoading());
    remoteDataSourceImpl.addtoStoreCartRequest(productId: productId, productQty: productQty).then((value) {
      amount = 0;
      for (var element in value.data!) {
        amount = amount + (int.parse(element.salePrice!) * int.parse(element.quantity!));
      }
      emit(CartApiSuccess(getCart: value));
    }).catchError((error, stackTrace) {
      emit(CartApiError());
      return onerror();
    });
  }

  removefromCart({required id}) {
    remoteDataSourceImpl.removeCartRequest(productId: id).then((value) {
      amount = 0;
      for (var element in value.data!) {
        amount = amount + (int.parse(element.salePrice!) * int.parse(element.quantity!));
      }
      emit(CartApiSuccess(getCart: value));
    }).catchError((error, stackTrace) {
      emit(CartApiError());
      return onerror();
    });
  }

  onerror() {
    emit(CartApiError());
  }
}
