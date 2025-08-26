import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/base_model.dart';
import 'package:sd_campus_app/features/data/remote/models/batch_community_model.dart';
import 'package:sd_campus_app/features/data/remote/models/get_community_comments.dart';

part 'batch_community_event.dart';
part 'batch_community_state.dart';

class BatchCommunityBloc extends Bloc<BatchCommunityEvent, BatchCommunityState> {
  static RemoteDataSourceImpl remoteDataSource = RemoteDataSourceImpl();
  int page = 1;
  final int limit = 10;
  bool isFetching = false;
  final Map<String, int> commentPages = {};
  final Map<String, bool> commentHasReachedMax = {};
  BatchCommunityBloc() : super(BatchCommunityInitial()) {
    on<FetchCommunitys>(_onFetchCommunitys);
    on<EditCommunity>(_onEditCommunitys);
    on<LikeCommunity>(_onLikeCommunity);
    on<LoadMoreCommunitys>(_onLoadMoreCommunitys);
    on<PostCommunityDetails>(_onPostCommunityDetails);
    on<FetchCommunityComments>(_onFetchCommunityComments);
    on<PostCommunityComment>(_onPostCommunityComments);
    on<EditCommunityComment>(_onEditCommunityComments);
    on<DeleteCommunityComment>(_onDeleteCommunityComments);
    on<PostReplyCommunityComment>(_onReplyCommunityComments);
    on<EditReplyCommunityComment>(_onEditReplyCommunityComments);
    on<DeleteCommunity>(_onDeleteCommunitys);
    on<DeleteReplyCommunityComment>(_onDeleteReplyCommunityComments);
  }
  Future<void> _onFetchCommunitys(FetchCommunitys event, Emitter<BatchCommunityState> emit) async {
    emit(CommunityLoading());
    page = event.page;
    try {
      GetCommunity communities;
      if (event.isMyCommunity) {
        communities = await remoteDataSource.getMybatchMyCommunity(
          batchId: event.batchId,
          page: event.page,
        );
      } else {
        communities = await remoteDataSource.getMyCommunity(
          batchId: event.batchId,
          page: event.page,
        );
      }
      emit(
        CommunityLoaded(communities: communities.data?.communities ?? [], hasReachedMax: (communities.data?.communities?.isEmpty ?? true) || ((communities.data?.communities?.length ?? 0) < limit), hasMoreComment: false),
      );
    } catch (e) {
      emit(CommunityError("Failed to fetch communities"));
    }
  }

  Future<void> _onEditCommunitys(EditCommunity event, Emitter<BatchCommunityState> emit) async {
    if (state is CommunityLoaded) {
      CommunityLoaded currentState = state as CommunityLoaded;
      emit(CommunityLoading());
      emit(currentState.copyWith(
        communities: currentState.communities.map((community) => community.id == event.community.id ? event.community : community).toList(),
      ));
    }
  }

  Future<void> _onLoadMoreCommunitys(LoadMoreCommunitys event, Emitter<BatchCommunityState> emit) async {
    if (isFetching) return;
    isFetching = true;

    final currentState = state;
    if (currentState is CommunityLoaded && !currentState.hasReachedMax) {
      page += 1;
      try {
        GetCommunity communities;
        if (event.isMyCommunity) {
          communities = await remoteDataSource.getMybatchMyCommunity(
            batchId: event.batchId,
            page: page,
          );
        } else {
          communities = await remoteDataSource.getMyCommunity(
            batchId: event.batchId,
            page: page,
          );
        }
        emit(CommunityLoading());
        emit(communities.data?.communities?.isEmpty ?? true
            ? currentState.copyWith(hasReachedMax: true)
            : CommunityLoaded(
                communities: currentState.communities + (communities.data?.communities ?? []),
                hasReachedMax: communities.data?.communities?.isEmpty ?? true,
                hasMoreComment: false,
              ));
      } catch (e) {
        emit(CommunityError("Failed to fetch Communitys"));
        emit(currentState);
      }
    } else {
      // log("readed max");
    }
    isFetching = false;
  }

  Future<void> _onLikeCommunity(LikeCommunity event, Emitter<BatchCommunityState> emit) async {
    if (state is CommunityLoaded) {
      final currentState = state as CommunityLoaded;
      emit(CommunityLoading());
      emit(currentState.copyWith(
          communities: currentState.communities.map((communities) {
        if (communities.id == event.communitiesId) {
          return communities.copyWith(
            likes: event.isLiked ? (communities.likes ?? 0) + 1 : (communities.likes ?? 0) - 1,
            isLiked: event.isLiked,
          );
          //   Community(
          //     id: communities.id,
          //     desc: communities.desc,
          //     problemImage: communities.problemImage,
          //     likes: event.isLiked ? (communities.likes ?? 0) + 1 : (communities.likes ?? 0) - 1,
          //     createdAt: communities.createdAt,
          //     isLiked: event.isLiked,
          //     isMyCommunity: communities.isMyCommunity,
          //     commentCounts: communities.commentCounts,
          //     user: communities.user,
          //     views: communities.views,
          //     comments: communities.comments,
          //   );
        }
        return communities;
      }).toList()));
      try {
        await remoteDataSource.postCommunityLikeAndDislike(
          batchCommunityId: event.communitiesId,
        );
        // Handle success scenario (optional)
      } catch (error) {
        // Handle network error (e.g., show a snackbar)
        // log("Error updating like status: $error");
      }
    }
  }

  FutureOr<void> _onPostCommunityDetails(PostCommunityDetails event, Emitter<BatchCommunityState> emit) async {
    if (state is CommunityLoaded) {
      Community? res = await RemoteDataSourceImpl().getCommunityById(batchCommunityId: event.postId);
      if (res != null) {
        final currentState = state as CommunityLoaded;
        emit(CommunityLoading());
        emit(currentState.copyWith(
            communities: currentState.communities.map((communities) {
          return (communities.id == event.postId)
              ? communities.copyWith(
                  views: res.views,
                  commentCounts: res.commentCounts ?? communities.commentCounts,
                  likes: res.likes ?? communities.likes,
                  createdAt: res.createdAt ?? communities.createdAt,
                )
              : communities;
        }).toList()));
        add(
          FetchCommunityComments(communityId: event.postId),
        );
      }
    }
  }

  Future<void> _onFetchCommunityComments(FetchCommunityComments event, Emitter<BatchCommunityState> emit) async {
    if (state is CommunityLoaded) {
      try {
        CommunityLoaded currentState = state as CommunityLoaded;
        Community targetCommunity = currentState.communities.firstWhere((c) => c.id == event.communityId);

        // Fetch comments for the community with pagination
        final commentsResponse = await remoteDataSource.getCommunityComments(
          batchCommunityId: event.communityId,
          page: event.page,
          pageSize: limit,
        );
        emit(CommunityLoading());
        if (event.page == 1) {
          targetCommunity.comments?.clear();
        }
        emit(currentState.copyWith(
          communities: currentState.communities
              .map((community) => community == targetCommunity
                  ? community.copyWith(
                      comments: community.comments?.toList() ?? []
                        ..addAll(commentsResponse.data?.comments ?? []),
                    )
                  : community)
              .toList(),
          hasMoreComment: targetCommunity.comments?.length != commentsResponse.data?.totalCounts,
        ));
      } catch (e) {
        // print(e);
      }
    }
  }

  FutureOr<void> _onPostCommunityComments(PostCommunityComment event, Emitter<BatchCommunityState> emit) async {
    if (state is CommunityLoaded) {
      final currentState = state as CommunityLoaded;
      Community targetCommunity = currentState.communities.firstWhere((c) => c.id == event.communityId);

      targetCommunity.comments?.insert(0, event.comment);
      emit(CommunityLoading());
      emit(currentState.copyWith(
          communities: currentState.communities
              .map((community) => community == targetCommunity
                  ? targetCommunity.copyWith(
                      comments: targetCommunity.comments,
                      commentCounts: (targetCommunity.commentCounts ?? 0) + 1,
                    )
                  : community)
              .toList()));
    }
  }

  FutureOr<void> _onEditCommunityComments(EditCommunityComment event, Emitter<BatchCommunityState> emit) async {
    if (state is CommunityLoaded) {
      CommunityLoaded currentState = state as CommunityLoaded;
      Community targetCommunity = currentState.communities.firstWhere((c) => c.id == event.communityId);
      final List<Community> updatedCommunities = currentState.communities.map((community) {
        return community == targetCommunity ? targetCommunity.copyWith(comments: community.comments?.map((comment) => comment?.commentId == event.commentId ? comment?.copyWith(cmntsMsg: event.comment.cmntsMsg, image: event.comment.image) : comment).toList()) : community;
      }).toList();

      emit(CommunityLoading());
      emit(currentState.copyWith(communities: updatedCommunities));
    }
  }

  FutureOr<void> _onDeleteCommunityComments(DeleteCommunityComment event, Emitter<BatchCommunityState> emit) async {
    if (state is CommunityLoaded) {
      final currentState = state as CommunityLoaded;
      Community targetCommunity = currentState.communities.firstWhere((c) => c.id == event.communityId);
      bool isremovied = await remoteDataSource.deleteCommunityComments(commentId: event.commentId);
      if (isremovied) {
        targetCommunity.comments?.removeWhere((comment) => comment?.commentId == event.commentId);
        emit(CommunityLoading());
        emit(currentState.copyWith(
            communities: currentState.communities
                .map((community) => community == targetCommunity
                    ? targetCommunity.copyWith(
                        comments: targetCommunity.comments,
                        commentCounts: (targetCommunity.commentCounts ?? 0) - 1,
                      )
                    : community)
                .toList()));
      }
    }
  }

  FutureOr<void> _onReplyCommunityComments(PostReplyCommunityComment event, Emitter<BatchCommunityState> emit) async {
    if (state is CommunityLoaded) {
      final currentState = state as CommunityLoaded;
      Community targetCommunity = currentState.communities.firstWhere((c) => c.id == event.communityId);
      Comment? targetCommunityComment = targetCommunity.comments?.firstWhere((c) => c?.commentId == event.commentId);
      targetCommunityComment?.replies?.insert(0, event.reply);
      emit(CommunityLoading());
      emit(currentState.copyWith(
          communities: currentState.communities
              .map((community) => community == targetCommunity
                  ? targetCommunity.copyWith(
                      comments: targetCommunity.comments
                          ?.map((comment) => comment == targetCommunityComment
                              ? targetCommunityComment?.copyWith(
                                  replies: targetCommunityComment.replies,
                                )
                              : comment)
                          .toList(),
                    )
                  : community)
              .toList()));
    }
  }

  FutureOr<void> _onEditReplyCommunityComments(EditReplyCommunityComment event, Emitter<BatchCommunityState> emit) async {
    if (state is CommunityLoaded) {
      CommunityLoaded currentState = state as CommunityLoaded;
      Community targetCommunity = currentState.communities.firstWhere((c) => c.id == event.communityId);
      Comment? targetCommunityComment = targetCommunity.comments?.firstWhere((c) => c?.commentId == event.commentId);
      targetCommunityComment?.replies?.firstWhere((reply) => reply.replyId == event.replyCommentId).cmntsMsg = event.msg;
      emit(CommunityLoading());
      emit(currentState.copyWith(communities: currentState.communities.map((community) => community == targetCommunity ? targetCommunity : community).toList()));
    }
  }

  FutureOr<void> _onDeleteReplyCommunityComments(DeleteReplyCommunityComment event, Emitter<BatchCommunityState> emit) async {
    if (state is CommunityLoaded) {
      CommunityLoaded currentState = state as CommunityLoaded;
      Community targetCommunity = currentState.communities.firstWhere((c) => c.id == event.communityId);
      Comment? targetCommunityComment = targetCommunity.comments?.firstWhere((c) => c?.commentId == event.commentId);
      bool isRemoved = await remoteDataSource.deleteCommunityCommentsReply(replyId: event.replyCommentId);
      if (isRemoved) {
        targetCommunityComment?.replies?.removeWhere((reply) => reply.replyId == event.replyCommentId);
        emit(CommunityLoading());
        emit(currentState.copyWith(communities: currentState.communities.map((community) => community == targetCommunity ? targetCommunity : community).toList()));
      }
    }
  }

  FutureOr<void> _onDeleteCommunitys(DeleteCommunity event, Emitter<BatchCommunityState> emit) async {
    if (state is CommunityLoaded) {
      CommunityLoaded currentState = state as CommunityLoaded;
      BaseModel isRemoved = await remoteDataSource.deleteCommunityByIdRequest(communityId: event.communityId);
      if (isRemoved.status) {
        currentState.communities.removeWhere((community) => community.id == event.communityId);
        emit(CommunityLoading());
        emit(currentState);
      }
    }
  }
}
