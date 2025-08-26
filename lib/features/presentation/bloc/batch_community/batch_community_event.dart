part of 'batch_community_bloc.dart';

sealed class BatchCommunityEvent extends Equatable {
  const BatchCommunityEvent();

  @override
  List<Object> get props => [];
}

// fetch community information
class FetchCommunitys extends BatchCommunityEvent {
  final String batchId;
  final int page;
  final int limit;
  final bool isMyCommunity;

  const FetchCommunitys({
    required this.batchId,
    required this.page,
    this.limit = 10,
    required this.isMyCommunity,
  });
}

class DeleteCommunity extends BatchCommunityEvent {
  final String communityId;
  const DeleteCommunity({required this.communityId});
}

class EditCommunity extends BatchCommunityEvent {
  final Community community;

  const EditCommunity({
    required this.community,
  });
}

// like community event in the community
class LikeCommunity extends BatchCommunityEvent {
  final String communitiesId;
  final bool isLiked;
  const LikeCommunity({required this.isLiked, required this.communitiesId});
}

// load more community information
class LoadMoreCommunitys extends BatchCommunityEvent {
  final String batchId;
  final bool isMyCommunity;
  const LoadMoreCommunitys({
    required this.batchId,
    required this.isMyCommunity,
  });
}

// fetch community details and view
class PostCommunityDetails extends BatchCommunityEvent {
  final String postId;
  const PostCommunityDetails({
    required this.postId,
  });
}

// fetch community comments
class FetchCommunityComments extends BatchCommunityEvent {
  final String communityId;
  final int page;
  const FetchCommunityComments({required this.communityId, this.page = 1});

  @override
  List<Object> get props => [
        communityId,
        page
      ];
}

class PostCommunityComment extends BatchCommunityEvent {
  final String communityId;
  final String msg;
  final Comment comment;
  const PostCommunityComment({
    required this.communityId,
    required this.msg,
    required this.comment,
  });
  @override
  List<Object> get props => [
        communityId,
        msg,
        comment
      ];
}

class EditCommunityComment extends BatchCommunityEvent {
  final String communityId;
  final String commentId;
  final String msg;
  final Comment comment;
  const EditCommunityComment({
    required this.communityId,
    required this.commentId,
    required this.msg,
    required this.comment,
  });
  @override
  List<Object> get props => [
        commentId,
        msg,
        comment,
        communityId,
      ];
}

class DeleteCommunityComment extends BatchCommunityEvent {
  final String commentId;
  final String communityId;
  const DeleteCommunityComment({
    required this.communityId,
    required this.commentId,
  });
  @override
  List<Object> get props => [
        commentId,
        communityId,
      ];
}

class PostReplyCommunityComment extends BatchCommunityEvent {
  final String communityId;
  final String commentId;
  final String msg;
  final Reply reply;
  const PostReplyCommunityComment({
    required this.communityId,
    required this.commentId,
    required this.msg,
    required this.reply,
  });
  @override
  List<Object> get props => [
        commentId,
        msg,
        communityId,
        reply
      ];
}

class EditReplyCommunityComment extends BatchCommunityEvent {
  final String communityId;
  final String commentId;
  final String replyCommentId;
  final String msg;
  final Reply reply;
  const EditReplyCommunityComment({
    required this.commentId,
    required this.communityId,
    required this.replyCommentId,
    required this.msg,
    required this.reply,
  });
  @override
  List<Object> get props => [
        commentId,
        replyCommentId,
        replyCommentId,
        msg,
        reply,
        communityId,
      ];
}

class DeleteReplyCommunityComment extends BatchCommunityEvent {
  final String communityId;
  final String commentId;
  final String replyCommentId;
  const DeleteReplyCommunityComment({
    required this.commentId,
    required this.communityId,
    required this.replyCommentId,
  });
  @override
  List<Object> get props => [
        replyCommentId,
        commentId,
        communityId
      ];
}
