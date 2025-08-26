part of 'app_stream_cubit.dart';

@immutable
abstract class AppStreamState {}

class AppStreamInitial extends AppStreamState {}

class AppStreamIsFull extends AppStreamState {
  final bool isfullScreen;
  AppStreamIsFull({required this.isfullScreen});
}
final class AppCommentsgetApi extends AppStreamState {}
final class AppCommentsPostApiSuccess extends AppStreamState {}
final class AppCommentsPostApiErorr extends AppStreamState {}
final class AppCommentsDeleteApiSuccess extends AppStreamState {}
final class AppCommentsDeleteApiErorr extends AppStreamState {}
final class AppCommentsReplyApiSuccess extends AppStreamState {}
final class AppCommentsReplyApiErorr extends AppStreamState {}
final class AppCommentsEditApiSuccess extends AppStreamState {}
final class AppCommentsEditApiErorr extends AppStreamState {}
final class AppCommentsReplyDeleteApiSuccess extends AppStreamState {}
final class AppCommentsReplyDeleteApiErorr extends AppStreamState {}
final class AppCommentsPinApiSuccess extends AppStreamState {}
final class AppCommentsPinApiErorr extends AppStreamState {}
final class AppCommentsReportApiSuccess extends AppStreamState {}
final class AppCommentsReportApiErorr extends AppStreamState {}
