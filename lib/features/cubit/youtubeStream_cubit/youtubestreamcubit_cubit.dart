import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/get_recorded_video_comments.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';

part 'youtubestreamcubit_state.dart';

class YoutubeStreamCubit extends Cubit<YoutubeStreamState> {
  int nousers=0;
  YoutubeStreamCubit() : super(YoutubestreamcubitInitial());
  bool isfull = false;
  GetRecordedVideoComments getrecordedvideocomments = GetRecordedVideoComments(status: true, data: [], msg: "");
  bool israted = false;
  bool isreported = false;
  List<dynamic> messages = [];
  void stateupdate() {
    emit(YoutubestreamcubitInitial()); 
  }
   void statecall() {
    emit(YoutubestreamcubitInitial()); 
  }

  void commentget({required String lectureId}) {
    emit(YoutubestreamcubitInitial());
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
      emit(YtCommentsgetApi());
    });
  }

  void commentpost({required String commentText, required String lectureId}) {
    emit(YoutubestreamcubitInitial());
    RemoteDataSourceImpl()
        .postCommentRequest(
      lectureId: lectureId,
      commentText: commentText,
    )
        .then((value) {
      if (value.status) {
        emit(YtCommentsPostApiSuccess());
      } else {
        emit(YtCommentsPostApiErorr());
      }
    });
  }

  void commentDelete({required String commentId}) {
    emit(YoutubestreamcubitInitial());
    RemoteDataSourceImpl().deleteCommentRecordedVideoRequest(commentId: commentId).then((value) {
      if (value.status) {
        emit(YtCommentsDeleteApiSuccess());
      } else {
        emit(YtCommentsDeleteApiErorr());
      }
      flutterToast(value.msg);
    });
  }

  void commentEdit({required String commentText, required String commentId}) {
    emit(YoutubestreamcubitInitial());
    RemoteDataSourceImpl()
        .editCommentRequest(
      commentId: commentId,
      commentText: commentText,
    )
        .then((value) {
      if (value.status) {
        emit(YtCommentsEditApiSuccess());
      } else {
        emit(YtCommentsEditApiErorr());
      }
      flutterToast(value.msg);
    });
  }

  void commentReply({
    required String replyTo,
    required String commentText,
    required String lectureId,
  }) {
    emit(YoutubestreamcubitInitial());
    RemoteDataSourceImpl()
        .replyToCommentForRecordedRequest(
      commentText: commentText,
      replyTo: replyTo,
      lectureId: lectureId,
    )
        .then((value) {
      if (value.status) {
        emit(YtCommentsReplyApiSuccess());
      } else {
        emit(YtCommentsReplyApiErorr());
      }
      flutterToast(value.msg);
    });
  }

  void commentReplyDelete({required String replyCommentId}) {
    emit(YoutubestreamcubitInitial());
    RemoteDataSourceImpl()
        .deleteReplyCommentRequest(
      replyCommentId: replyCommentId,
    )
        .then((value) {
      if (value.status) {
        emit(YtCommentsReplyDeleteApiSuccess());
      } else {
        emit(YtCommentsReplyDeleteApiErorr());
      }
      flutterToast(value.msg);
    });
  }

  void commentPin({required String commentId}) {
    emit(YoutubestreamcubitInitial());
    RemoteDataSourceImpl()
        .pinCommentRequest(
      commentId: commentId,
    )
        .then((value) {
      if (value.status) {
        emit(YtCommentsReplyDeleteApiSuccess());
      } else {
        emit(YtCommentsReplyDeleteApiErorr());
      }
      flutterToast(value.msg);
    });
  }

  void commentReport({required String commentId}) {
    emit(YoutubestreamcubitInitial());
    RemoteDataSourceImpl()
        .markCommentToReportRequest(
      commentId: commentId,
    )
        .then((value) {
      if (value.status) {
        emit(YtCommentsReplyDeleteApiSuccess());
      } else {
        emit(YtCommentsReplyDeleteApiErorr());
      }
      flutterToast(value.msg);
    });
  }
}
