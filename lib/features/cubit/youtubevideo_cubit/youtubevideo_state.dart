part of 'youtubevideo_cubit.dart';

sealed class YoutubeVideoState extends Equatable {
  const YoutubeVideoState();

  @override
  List<Object> get props => [];
}

final class YoutubestreamcubitInitial extends YoutubeVideoState {}

final class YtCommentsgetApi extends YoutubeVideoState {}
final class YtCommentsPostApiSuccess extends YoutubeVideoState {}
final class YtCommentsPostApiErorr extends YoutubeVideoState {}
final class YtCommentsDeleteApiSuccess extends YoutubeVideoState {}
final class YtCommentsDeleteApiErorr extends YoutubeVideoState {}
final class YtCommentsReplyApiSuccess extends YoutubeVideoState {}
final class YtCommentsReplyApiErorr extends YoutubeVideoState {}
final class YtCommentsEditApiSuccess extends YoutubeVideoState {}
final class YtCommentsEditApiErorr extends YoutubeVideoState {}
final class YtCommentsReplyDeleteApiSuccess extends YoutubeVideoState {}
final class YtCommentsReplyDeleteApiErorr extends YoutubeVideoState {}
final class YtCommentsPinApiSuccess extends YoutubeVideoState {}
final class YtCommentsPinApiErorr extends YoutubeVideoState {}
final class YtCommentsReportApiSuccess extends YoutubeVideoState {}
final class YtCommentsReportApiErorr extends YoutubeVideoState {}