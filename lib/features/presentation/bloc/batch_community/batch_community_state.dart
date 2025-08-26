part of 'batch_community_bloc.dart';

sealed class BatchCommunityState extends Equatable {
  const BatchCommunityState();

  @override
  List<Object> get props => [];
}

final class BatchCommunityInitial extends BatchCommunityState {}

class CommunityLoading extends BatchCommunityState {}

class CommunityLoaded extends BatchCommunityState {
  final List<Community> communities;
  final bool hasReachedMax;
  final bool hasMoreComment;
  const CommunityLoaded( {required this.communities, required this.hasReachedMax,required this.hasMoreComment});

  CommunityLoaded copyWith({
    List<Community>? communities,
    bool? hasReachedMax,
    bool? hasMoreComment,
  }) {
    return CommunityLoaded(
      communities: communities ?? this.communities,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      hasMoreComment: hasMoreComment ?? this.hasMoreComment,
    );
  }
}

class CommunityError extends BatchCommunityState {
  final String message;

  const CommunityError(this.message);
}
