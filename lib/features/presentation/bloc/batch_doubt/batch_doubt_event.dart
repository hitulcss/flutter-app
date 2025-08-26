part of 'batch_doubt_bloc.dart';

sealed class BatchDoubtEvent extends Equatable {
  const BatchDoubtEvent();

  @override
  List<Object> get props => [];
}

class FetchDoubts extends BatchDoubtEvent {
  final String batchId;
  final int page;
  final int limit;
  final bool isMyDoubt;
  const FetchDoubts({
    required this.batchId,
    required this.page,
    this.limit = 10,
    required this.isMyDoubt,
  });
}

class EditDoubt extends BatchDoubtEvent {
  final Doubt doubt;

  const EditDoubt({
    required this.doubt,
  });
}

class DeleteDoubt extends BatchDoubtEvent {
  final String doubtId;
  const DeleteDoubt({required this.doubtId});
}

class LikeDoubt extends BatchDoubtEvent {
  final String doubtId;
  final bool isLiked;
  const LikeDoubt({required this.isLiked, required this.doubtId});
}

class LoadMoreDoubts extends BatchDoubtEvent {
  final String batchId;
  final bool isMyDoubt;
  const LoadMoreDoubts({
    required this.batchId,
    required this.isMyDoubt,
  });
}

// fetch community comments
class FetchDoubtComments extends BatchDoubtEvent {
  final String doubtId;
  final int page;
  const FetchDoubtComments({required this.doubtId, this.page = 1});

  @override
  List<Object> get props => [
        doubtId,
        page
      ];
}

class PostDoubtDetails extends BatchDoubtEvent {
  final String postId;
  const PostDoubtDetails({
    required this.postId,
  });
}

class PostDoubtComment extends BatchDoubtEvent {
  final String doubtId;
  final String msg;
  final DoubtComment comment;
  const PostDoubtComment({
    required this.doubtId,
    required this.msg,
    required this.comment,
  });
  @override
  List<Object> get props => [
        doubtId,
        msg,
        comment
      ];
}

class EditDoubtComment extends BatchDoubtEvent {
  final String doubtId;
  final String commentId;
  final String msg;
  final DoubtComment comment;
  const EditDoubtComment({
    required this.doubtId,
    required this.commentId,
    required this.msg,
    required this.comment,
  });
  @override
  List<Object> get props => [
        commentId,
        msg,
        comment,
        doubtId,
      ];
}

class DeleteDoubtComment extends BatchDoubtEvent {
  final String commentId;
  final String doubtId;
  const DeleteDoubtComment({
    required this.doubtId,
    required this.commentId,
  });
  @override
  List<Object> get props => [
        commentId,
        doubtId,
      ];
}
