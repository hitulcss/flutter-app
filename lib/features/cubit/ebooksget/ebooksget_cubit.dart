import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'ebooksget_state.dart';

class EbooksgetCubit extends Cubit<EbooksgetState> {
  EbooksgetCubit() : super(EbooksgetInitial());
  String selectedcategories = "";
  String ebooksCategorySelected({required String selected}) {
    emit(EbooksgetInitial());
    emit(EbooksCategoryselected(selected: selected));
    return selected;
  }
}
