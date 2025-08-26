part of 'ebooksget_cubit.dart';

sealed class EbooksgetState extends Equatable {
  const EbooksgetState();

  @override
  List<Object> get props => [];
}

final class EbooksgetInitial extends EbooksgetState {}
final class EbooksCategoryselected extends EbooksgetState {
  final String selected;
  const EbooksCategoryselected({required this.selected});
}
