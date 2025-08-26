part of 'mediasoup_cubit.dart';

@immutable
sealed class MediasoupState {}

final class MediasoupInitial extends MediasoupState {}
class MediasoupStateupdate extends MediasoupState {}
final class MediasoupLoading extends MediasoupState {}
class Mediasoupupdated extends MediasoupState {}
