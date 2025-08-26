import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/get_recorded_video_comments.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';

part 'app_stream_state.dart';

class AppStreamCubit extends Cubit<AppStreamState> {
  AppStreamCubit() : super(AppStreamInitial());
  bool isfull = false;
  bool israted = false;
  bool isreported = false;
  List<dynamic> messages = [];
  GetRecordedVideoComments getrecordedvideocomments = GetRecordedVideoComments(status: true, data: [], msg: "");

  bool isFullScreen({required bool isfullscreen}) {
    isfull = isfullscreen;
    emit(AppStreamInitial());
    emit(AppStreamIsFull(isfullScreen: isfullscreen));
    return isfullscreen;
  }

  void stateupdate() {
    emit(AppStreamInitial());
  }

  void statecall() {
    emit(AppStreamInitial());
  }

  void commentget({required String lectureId}) {
    emit(AppStreamInitial());
    RemoteDataSourceImpl().getRecordedVideoCommentsRequest(lectureId: lectureId).then((value) {
      value.data?.sort((a, b) {
        if (a.isPin == true && b.isPin == false) {
          return -1;
        } else if (a.isPin == false && b.isPin == true) {
          return 1;
        } else {
          return 0;
        }
      });
      getrecordedvideocomments = value;
      emit(AppCommentsgetApi());
    });
  }

  void commentpost({required String commentText, required String lectureId}) {
    emit(AppStreamInitial());
    RemoteDataSourceImpl()
        .postCommentRequest(
      lectureId: lectureId,
      commentText: commentText,
    )
        .then((value) {
      if (value.status) {
        emit(AppCommentsPostApiSuccess());
      } else {
        emit(AppCommentsPostApiErorr());
      }
    });
  }

  void commentDelete({required String commentId}) {
    emit(AppStreamInitial());
    RemoteDataSourceImpl().deleteCommentRecordedVideoRequest(commentId: commentId).then((value) {
      if (value.status) {
        emit(AppCommentsDeleteApiSuccess());
      } else {
        emit(AppCommentsDeleteApiErorr());
      }
      flutterToast(value.msg);
    });
  }

  void commentEdit({required String commentText, required String commentId}) {
    emit(AppStreamInitial());
    RemoteDataSourceImpl()
        .editCommentRequest(
      commentId: commentId,
      commentText: commentText,
    )
        .then((value) {
      if (value.status) {
        emit(AppCommentsEditApiSuccess());
      } else {
        emit(AppCommentsEditApiErorr());
      }
      flutterToast(value.msg);
    });
  }

  void commentReply({
    required String replyTo,
    required String commentText,
    required String lectureId,
  }) {
    emit(AppStreamInitial());
    RemoteDataSourceImpl()
        .replyToCommentForRecordedRequest(
      commentText: commentText,
      replyTo: replyTo,
      lectureId: lectureId,
    )
        .then((value) {
      if (value.status) {
        emit(AppCommentsReplyApiSuccess());
      } else {
        emit(AppCommentsReplyApiErorr());
      }
      flutterToast(value.msg);
    });
  }

  void commentReplyDelete({required String replyCommentId}) {
    emit(AppStreamInitial());
    RemoteDataSourceImpl()
        .deleteReplyCommentRequest(
      replyCommentId: replyCommentId,
    )
        .then((value) {
      if (value.status) {
        emit(AppCommentsReplyDeleteApiSuccess());
      } else {
        emit(AppCommentsReplyDeleteApiErorr());
      }
      flutterToast(value.msg);
    });
  }

  void commentPin({required String commentId}) {
    emit(AppStreamInitial());
    RemoteDataSourceImpl()
        .pinCommentRequest(
      commentId: commentId,
    )
        .then((value) {
      if (value.status) {
        emit(AppCommentsReplyDeleteApiSuccess());
      } else {
        emit(AppCommentsReplyDeleteApiErorr());
      }
      flutterToast(value.msg);
    });
  }

  void commentReport({required String commentId}) {
    emit(AppStreamInitial());
    RemoteDataSourceImpl()
        .markCommentToReportRequest(
      commentId: commentId,
    )
        .then((value) {
      if (value.status) {
        emit(AppCommentsReplyDeleteApiSuccess());
      } else {
        emit(AppCommentsReplyDeleteApiErorr());
      }
      flutterToast(value.msg);
    });
  }
}
