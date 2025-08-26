part of 'youtubestreamcubit_cubit.dart';

sealed class YoutubeStreamState extends Equatable {
  const YoutubeStreamState();

  @override
  List<Object> get props => [];
}

final class YoutubestreamcubitInitial extends YoutubeStreamState {}

final class YtCommentsgetApi extends YoutubeStreamState {}
final class YtCommentsPostApiSuccess extends YoutubeStreamState {}
final class YtCommentsPostApiErorr extends YoutubeStreamState {}
final class YtCommentsDeleteApiSuccess extends YoutubeStreamState {}
final class YtCommentsDeleteApiErorr extends YoutubeStreamState {}
final class YtCommentsReplyApiSuccess extends YoutubeStreamState {}
final class YtCommentsReplyApiErorr extends YoutubeStreamState {}
final class YtCommentsEditApiSuccess extends YoutubeStreamState {}
final class YtCommentsEditApiErorr extends YoutubeStreamState {}
final class YtCommentsReplyDeleteApiSuccess extends YoutubeStreamState {}
final class YtCommentsReplyDeleteApiErorr extends YoutubeStreamState {}
final class YtCommentsPinApiSuccess extends YoutubeStreamState {}
final class YtCommentsPinApiErorr extends YoutubeStreamState {}
final class YtCommentsReportApiSuccess extends YoutubeStreamState {}
final class YtCommentsReportApiErorr extends YoutubeStreamState {}