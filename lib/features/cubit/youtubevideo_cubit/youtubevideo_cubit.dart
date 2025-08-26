import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/models/library/comments/get_video_learing_comments.dart';

part 'youtubevideo_state.dart';

class YoutubeVideoCubit extends Cubit<YoutubeVideoState> {
  int nousers = 0;
  YoutubeVideoCubit() : super(YoutubestreamcubitInitial());
  bool isfull = false;
  GetListVideoLearingCommentLibrary getrecordedvideocomments = GetListVideoLearingCommentLibrary(status: true, data: [], msg: "");
  bool israted = false;
  bool isreported = false;
  List<dynamic> messages = [];
  void stateupdate() {
    emit(YoutubestreamcubitInitial());
    emit(YoutubestreamcubitInitial());
  }

  void statecall() {
    emit(YoutubestreamcubitInitial());
    emit(YtCommentsReportApiSuccess());
  }

  void commentget({required String videoid}) {
    emit(YoutubestreamcubitInitial());
    RemoteDataSourceImpl().getVideoLeariningLibraryCommentsRequest(videoId: videoid).then((value) {
      getrecordedvideocomments = value;
      emit(YtCommentsgetApi());
    }).catchError((error, stackTrace) {
      emit(YtCommentsgetApi());
    });
  }

  void commentpost({required String commentText, required String videoid}) {
    emit(YoutubestreamcubitInitial());
    RemoteDataSourceImpl()
        .postVideoLeariningLibraryCommentsRequest(
      videoId: videoid,
      comment: commentText,
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
    RemoteDataSourceImpl().deleteVideoLeariningLibraryCommentsRequest(commentid: commentId).then((value) {
      if (value) {
        emit(YtCommentsDeleteApiSuccess());
      } else {
        emit(YtCommentsDeleteApiErorr());
      }
    });
  }

  void commentEdit({required String commentText, required String commentId, required String videoId}) {
    emit(YoutubestreamcubitInitial());
    RemoteDataSourceImpl()
        .editVideoLeariningLibraryCommentsRequest(
      videoId: videoId,
      commentid: commentId,
      comment: commentText,
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
    required String videoid,
    required String commentid,
  }) {
    emit(YoutubestreamcubitInitial());
    RemoteDataSourceImpl()
        .postVideoLeariningLibraryCommentsReplyRequest(
      msg: commentText,
      replyTo: replyTo,
      commentid: commentid,
      videoId: videoid,
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

  // void commentReplyDelete({required String replyCommentId}) {
  //   emit(YoutubestreamcubitInitial());
  //   RemoteDataSourceImpl()
  //       .deleteReplyCommentRequest(
  //     replyCommentId: replyCommentId,
  //   )
  //       .then((value) {
  //     if (value.status) {
  //       emit(YtCommentsReplyDeleteApiSuccess());
  //     } else {
  //       emit(YtCommentsReplyDeleteApiErorr());
  //     }
  //     flutterToast(value.msg);
  //   });
  // }

  // void commentPin({required String commentId}) {
  //   emit(YoutubestreamcubitInitial());
  //   RemoteDataSourceImpl()
  //       .pinCommentRequest(
  //     commentId: commentId,
  //   )
  //       .then((value) {
  //     if (value.status) {
  //       emit(YtCommentsReplyDeleteApiSuccess());
  //     } else {
  //       emit(YtCommentsReplyDeleteApiErorr());
  //     }
  //     flutterToast(value.msg);
  //   });
  // }

  // void commentReport({required String commentId}) {
  //   emit(YoutubestreamcubitInitial());
  //   RemoteDataSourceImpl()
  //       .markCommentToReportRequest(
  //     commentId: commentId,
  //   )
  //       .then((value) {
  //     if (value.status) {
  //       emit(YtCommentsReplyDeleteApiSuccess());
  //     } else {
  //       emit(YtCommentsReplyDeleteApiErorr());
  //     }
  //     flutterToast(value.msg);
  //   });
  // }
}
