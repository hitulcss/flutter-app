part of 'batch_doubt_bloc.dart';

sealed class BatchDoubtState extends Equatable {
  const BatchDoubtState();

  @override
  List<Object> get props => [];
}

final class BatchDoubtInitial extends BatchDoubtState {}

class DoubtLoading extends BatchDoubtState {}

class DoubtLoaded extends BatchDoubtState {
  final List<Doubt> doubt;
  final bool hasReachedMax;

  const DoubtLoaded({required this.doubt, required this.hasReachedMax});

  DoubtLoaded copyWith({
    List<Doubt>? doubt,
    bool? hasReachedMax,
  }) {
    return DoubtLoaded(
      doubt: doubt ?? this.doubt,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );  
  }
}

class DoubtError extends BatchDoubtState {
  final String message;

  const DoubtError(this.message);
}
