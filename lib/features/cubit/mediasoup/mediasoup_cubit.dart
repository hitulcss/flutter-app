import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';
import "package:meta/meta.dart";

import 'package:sd_campus_app/features/data/remote/models/getdoubt.dart';

part 'mediasoup_state.dart';

class MediasoupCubit extends Cubit<MediasoupState> {
  MediasoupCubit() : super(MediasoupInitial());
  bool isAudioOn = false;

  bool isVideoOn = false;

  bool isFrontCameraSelected = false;
  bool israted = false;
  bool isreported = false;
  bool doubtreq = false;
  bool doubtenable = false;
  String data = "";
  int noOfuser = 0;
  GetDoubt doubts = GetDoubt();
  String roomName = "";
  List<Map<String, dynamic>> messages = [];
  void addConsumer({required socketids}) {
    // print("Ct" * 100);
    // print(socketids);
    // print("Ct" * 100);
    emit(MediasoupInitial());
    emit(Mediasoupupdated());
  }

  void statecall() {
    emit(MediasoupStateupdate());
  }

  void newMessage(Map<String, dynamic> message) {
    messages.insert(0, message);
    emit(MediasoupInitial());
    emit(Mediasoupupdated());
  }

  void deleteMessage(Map<String, dynamic> data) {
    messages.removeWhere((element) => element['id'] == data['id'] && element['msg'] == data['msg']);
    emit(MediasoupInitial());
    emit(Mediasoupupdated());
  }



  toggleMic({required MediaStream mediaStream, bool? status}) {
    // change status
    isAudioOn = status ?? !isAudioOn;
    // enable or disable audio track
    mediaStream.getAudioTracks().forEach((track) {
      track.enabled = isAudioOn;
    });
  }

  toggleCamera({required MediaStream mediaStream, bool? status}) {
    // change status
    isVideoOn = status ?? !isVideoOn;
    // enable or disable video track
    mediaStream.getVideoTracks().forEach((track) {
      track.enabled = isVideoOn;
    });
  }

  switchCamera(MediaStream? mediaStream) {
    // change status
    isFrontCameraSelected = !isFrontCameraSelected;

    // switch camera
    mediaStream?.getVideoTracks().forEach((track) {
      // ignore: deprecated_member_use
      track.switchCamera();
    });
  }
}
