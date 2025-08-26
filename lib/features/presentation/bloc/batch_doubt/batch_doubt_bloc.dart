import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/batch_doubts_model.dart';

part 'batch_doubt_event.dart';
part 'batch_doubt_state.dart';

class BatchDoubtBloc extends Bloc<BatchDoubtEvent, BatchDoubtState> {
  final RemoteDataSourceImpl remoteDataSource = RemoteDataSourceImpl();
  int page = 1;
  final int limit = 10;
  bool isFetching = false;
  BatchDoubtBloc() : super(BatchDoubtInitial()) {
    on<FetchDoubts>(_onFetchDoubts);
    on<EditDoubt>(_onEditDoubt);
    on<DeleteDoubt>(_onDeleteDoubt);
    on<LikeDoubt>(_onLikeDoubt);
    on<LoadMoreDoubts>(_onLoadMoreDoubts);
    on<PostDoubtDetails>(_onPostDoubtDetails);
    // on<FetchDoubtComments>(_onFetchDoubtComments);
    on<PostDoubtComment>(_onPostDoubtComments);
    on<EditDoubtComment>(_onEditDoubtComments);
    on<DeleteDoubtComment>(_onDeleteDoubtComments);
  }
  Future<void> _onFetchDoubts(FetchDoubts event, Emitter<BatchDoubtState> emit) async {
    emit(DoubtLoading());
    page = event.page;
    try {
      GetBatchDoubts posts;
      if (!event.isMyDoubt) {
        posts = await remoteDataSource.getMyCoursesDoubts(
          batchId: event.batchId,
          page: event.page,
        );
      } else {
        posts = await remoteDataSource.getMyCoursesMYDoubts(
          batchId: event.batchId,
          page: page,
        );
      }
      emit(DoubtLoaded(doubt: posts.data?.doubts ?? [], hasReachedMax: (posts.data?.doubts?.isEmpty ?? true) || ((posts.data?.doubts?.length ?? 0) < 10)));
    } catch (e) {
      emit(DoubtError("Failed to fetch posts"));
    }
  }

  Future<void> _onLoadMoreDoubts(LoadMoreDoubts event, Emitter<BatchDoubtState> emit) async {
    if (isFetching) return;
    isFetching = true;

    final currentState = state;
    if (currentState is DoubtLoaded && !currentState.hasReachedMax) {
      try {
        page += 1;
        GetBatchDoubts posts;
        if (event.isMyDoubt) {
          posts = await remoteDataSource.getMyCoursesMYDoubts(
            batchId: event.batchId,
            page: page,
          );
        } else {
          posts = await remoteDataSource.getMyCoursesDoubts(
            batchId: event.batchId,
            page: page,
          );
        }
        emit(DoubtLoading());
        emit(posts.data?.doubts?.isEmpty ?? true
            ? currentState.copyWith(hasReachedMax: true)
            : DoubtLoaded(
                doubt: currentState.doubt + (posts.data?.doubts ?? []),
                hasReachedMax: posts.data?.doubts?.isEmpty ?? true,
              ));
      } catch (e) {
        emit(DoubtError("Failed to fetch Doubts"));
        emit(currentState.copyWith(hasReachedMax: true));
      }
    } else {
      // log("readed max");
    }
    isFetching = false;
  }

  Future<void> _onLikeDoubt(LikeDoubt event, Emitter<BatchDoubtState> emit) async {
    if (state is DoubtLoaded) {
      final currentState = state as DoubtLoaded;
      emit(DoubtLoading());
      emit(currentState.copyWith(
          doubt: currentState.doubt.map((doubt) {
        if (doubt.id == event.doubtId) {
          return doubt.copyWith(
            likes: event.isLiked ? (doubt.likes ?? 0) + 1 : (doubt.likes ?? 0) - 1,
            isLiked: event.isLiked,
          );
        }
        return doubt;
      }).toList()));
      try {
        await remoteDataSource.postBatchDoubtLikeAndDislike(
          batchDoubtId: event.doubtId,
        );
        // Handle success scenario (optional)
      } catch (error) {
        // Handle network error (e.g., show a snackbar)
        // print(error);
      }
    }
  }

  FutureOr<void> _onDeleteDoubt(DeleteDoubt event, Emitter<BatchDoubtState> emit) {
    if (state is DoubtLoaded) {
      DoubtLoaded currentState = state as DoubtLoaded;
      currentState.doubt.removeWhere((e) => e.id == event.doubtId);
      emit(DoubtLoading());
      emit(currentState.copyWith(doubt: currentState.doubt));
    }
  }

  FutureOr<void> _onPostDoubtDetails(PostDoubtDetails event, Emitter<BatchDoubtState> emit) async {
    if (state is DoubtLoaded) {
      DoubtLoaded currentState = state as DoubtLoaded;
      Doubt doubtDetails = await RemoteDataSourceImpl().getBatchDoubtById(batchDoubtId: event.postId);
      emit(DoubtLoading());
      emit(currentState.copyWith(doubt: currentState.doubt.map((e) => e.id == event.postId ? doubtDetails : e).toList()));
    }
  }

  FutureOr<void> _onPostDoubtComments(PostDoubtComment event, Emitter<BatchDoubtState> emit) {
    if (state is DoubtLoaded) {
      DoubtLoaded currentState = state as DoubtLoaded;
      var targetDoubt = currentState.doubt.where((e) => e.id == event.doubtId).first;
      targetDoubt.comments?.insert(0, event.comment);
      targetDoubt.totalComments = targetDoubt.comments?.length ?? targetDoubt.totalComments ?? 0 + 1;
      currentState.copyWith(
          doubt: currentState.doubt.map((doubt) {
        if (doubt.id == event.doubtId) {
          return doubt.copyWith(
            comments: targetDoubt.comments,
            totalComments: targetDoubt.totalComments,
          );
        }
        return doubt;
      }).toList());
      emit(DoubtLoading());
      emit(currentState);
    }
  }

  FutureOr<void> _onEditDoubtComments(EditDoubtComment event, Emitter<BatchDoubtState> emit) {
    if (state is DoubtLoaded) {
      DoubtLoaded currentState = state as DoubtLoaded;
      var targetDoubt = currentState.doubt.where((e) => e.id == event.doubtId).first;
      targetDoubt.comments?.map((e) => e.commentId == event.commentId ? event.comment : e);
      emit(DoubtLoading());
      currentState.copyWith(
          doubt: currentState.doubt.map((doubt) {
        if (doubt.id == event.doubtId) {
          return doubt.copyWith(
            comments: targetDoubt.comments,
          );
        }
        return doubt;
      }).toList());
      emit(currentState);
    }
  }

  FutureOr<void> _onDeleteDoubtComments(DeleteDoubtComment event, Emitter<BatchDoubtState> emit) {
    if (state is DoubtLoaded) {
      DoubtLoaded currentState = state as DoubtLoaded;
      var targetDoubt = currentState.doubt.where((e) => e.id == event.doubtId).first;
      targetDoubt.comments?.removeWhere((e) => e.commentId == event.commentId);
      targetDoubt.totalComments = targetDoubt.comments?.length ?? targetDoubt.totalComments ?? 0 - 1;
      currentState.copyWith(
        doubt: currentState.doubt.map((doubt) {
          if (doubt.id == event.doubtId) {
            return doubt.copyWith(
              comments: targetDoubt.comments,
              totalComments: targetDoubt.totalComments,
            );
          }
          return doubt;
        }).toList(),
      );
      emit(DoubtLoading());
      emit(currentState);
    }
  }

  FutureOr<void> _onEditDoubt(EditDoubt event, Emitter<BatchDoubtState> emit) {
    if (state is DoubtLoaded) {
      DoubtLoaded currentState = state as DoubtLoaded;
      emit(DoubtLoading());
      emit(currentState.copyWith(
          doubt: currentState.doubt.map((doubt) {
        if (doubt.id == event.doubt.id) {
          return doubt.copyWith(
            desc: event.doubt.desc,
            problemImage: event.doubt.problemImage,
            likes: event.doubt.likes,
            isLiked: event.doubt.isLiked,
            createdAt: event.doubt.createdAt,
            lectureName: event.doubt.lectureName,
            subject: event.doubt.subject,
          );
        }
        return doubt;
      }).toList()));
    }
  }
}
