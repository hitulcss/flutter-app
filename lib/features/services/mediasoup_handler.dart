import 'package:flutter/material.dart';
import 'package:mediasoup_client_flutter/mediasoup_client_flutter.dart';
import 'package:sd_campus_app/features/cubit/mediasoup/mediasoup_cubit.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/features/services/socket_connection.dart';

// Logger _logger = Logger('mediasoup Handler');

class MediaSoupHandler {
  MediasoupCubit mediasoupCubit;
  late Device device;
  Transport? producerTransport;
  late Transport consumerTransport;
  Map<String, dynamic> createSendTransportdata = {};
  Map<String, Producer> producers = {};
  RTCVideoRenderer localRTCVideoRenderer = RTCVideoRenderer();
  Map<String?, dynamic> socketids = {};
  Map<String, Map<String, dynamic>> remoteVideoRendererswidget = {};
  List consumingTransports = [];
  List<Map<String, dynamic>> consumerTransports = [];
  // media status
  bool isAudioOn = true, isVideoOn = true, isFrontCameraSelected = true;
  Map<String, dynamic> rtpCapabilities = {};
  Map<String, dynamic> encodingsparams = {
    // mediasoup params
    "encodings": [
      {
        "rid": 'r0',
        "maxBitrate": 100000,
        "scalabilityMode": 'S1T3',
      },
      {
        "rid": 'r1',
        "maxBitrate": 300000,
        "scalabilityMode": 'S1T3',
      },
      {
        "rid": 'r2',
        "maxBitrate": 900000,
        "scalabilityMode": 'S1T3',
      },
    ],
    // https://mediasoup.org/documentation/v3/mediasoup-client/api/#ProducerCodecOptions
    "codecOptions": {
      "videoGoogleStartBitrate": 1000
    }
  };

  MediaSoupHandler({required this.mediasoupCubit});
  Future<void> createDevice({required Map<String, dynamic> rtpCapabilities}) async {
    try {
      device = Device();
      var routerRtpCapabilities = RtpCapabilities.fromMap(rtpCapabilities);
      routerRtpCapabilities.headerExtensions.removeWhere((he) => he.uri == 'urn:3gpp:video-orientation');

      await device.load(routerRtpCapabilities: routerRtpCapabilities);
      // _logger.debug("Device RTP Capabilities ${device.rtpCapabilities}");
      //print("Device RTP Capabilities ${device.rtpCapabilities}");
      // createSendTransport();
    } catch (e) {
      // _logger.error(e);
    }
  }

  createSendTransport() async {
    SocketConnetion.connection.emitWithAck('createWebRtcTransport', {
      "consumer": false,
      'sctpCapabilities': device.sctpCapabilities.toMap(),
    }, ack: (params) async {
      if (params["params"]["error"] ?? false) {
        return;
      }
      void producerCallback(Producer producer) {
        producers[producer.kind] = producer;
        producer.on('trackended', () {});
        producer.on('pause', () {});
      }

      producerTransport = device.createSendTransportFromMap(params["params"],
          // id: params["params"]["id"],
          producerCallback: producerCallback, dataProducerCallback: (data) {
        // print(data);
      });

      producerTransport!.on("connect", (Map data) async {
        var callback = data['callback'];
        var errback = data['errback'];
        try {
          // Signal local DTLS parameters to the server side transport
          // see server's socket.on('transport-connect', ...)
          Map<String, dynamic> dtlsParameters = data['dtlsParameters'].toMap();

          SocketConnetion.connection.emit('transport-connect', {
            "dtlsParameters": dtlsParameters,
          });

          // Tell the transport that parameters were transmitted.
          callback();
        } catch (error) {
          errback(error);
        }
      });
      producerTransport!.on('produce', (Map data) async {
        var callback = data['callback'];
        var errback = data['errback'];
        try {
          // tell the server to create a Producer
          // with the following parameters and produce
          // and expect back a server side producer id
          // see server's socket.on('transport-produce', ...)
          SocketConnetion.connection.emitWithAck('transport-produce', {
            "kind": data["kind"],
            "rtpParameters": data["rtpParameters"].toMap(),
            "appData": data["appData"],
          }, ack: (response) async {
            // Tell the transport that parameters were transmitted and provide it with the
            // server side producer's id.
            callback(response['id']);
            // if producers exist, then join room
            if (response["producersExist"]) {
              // //print("producersExist ");
              await getProducers();
              // //print("done getProducers");
            }
            // SocketConnetion.connection.on('new-producer', (producerId) {
            //   signalNewConsumerTransport(producerId["producerId"], producerId["socketId"]);
            // });
          });
        } catch (error) {
          errback(error);
        }
      });
      producerTransport!.on("icestatechange", (data) {
        // print("*" * 10);
        // print("ICE state changed to %s $data");
        // print("*" * 10);
      });
      producerTransport!.on('connectionstatechange', (connectionState) {
        // print("*" * 10);
        // print('connectionstatechange $connectionState');
        if (connectionState["connectionState"] == "failed") {
          // producerTransport.restartIce(IceParameters.fromMap(params["params"]['iceParameters']));
        }
        // print("*" * 10);
      });
      Future.delayed(const Duration(seconds: 1), () async {
        MediaStream audiostrem = await createVideoStream();
        mediasoupCubit.toggleCamera(mediaStream: audiostrem, status: false);
        mediasoupCubit.toggleMic(mediaStream: audiostrem, status: false);
        producerTransport!.produce(track: audiostrem.getAudioTracks().first, stream: audiostrem, source: "audio");
        producerTransport!.produce(track: audiostrem.getVideoTracks().first, stream: audiostrem, source: "video");
        localRTCVideoRenderer.srcObject = audiostrem;
        // print("*" * 100);
        // device.rtpCapabilities.codecs.forEach((element) {
        //   print(element.toMap());
        // });
        // print(_localStream.active);
        // print("*" * 100);
        // if (forAudio != null) {
        //   try {
        //     print("| |" * 100);
        //     print(localRTCVideoRenderer);
        //     print(localRTCVideoRenderer.srcObject != null);
        //     print("| |" * 100);

        //     MediaStream videoStream;
        //     if (localRTCVideoRenderer.srcObject == null) {
        //       print("P");
        //       videoStream = await createVideoStream();
        //     } else {
        //       print("l");
        //       videoStream = localRTCVideoRenderer.srcObject!;
        //       print(videoStream.getTracks());
        //     }
        //     print("TT");
        //     print(producerTransport!.closed);
        //     print(videoStream.getTracks().length);
        //     print("TT");
        //     if (forAudio) {
        //       print(localRTCVideoRenderer.srcObject);
        //       print("L O L " * 100);
        //       producerTransport!.produce(
        //         // stopTracks: false,
        //         track: videoStream.getAudioTracks().first,
        //         stream: videoStream,
        //         source: "audio",
        //         // codec: device.rtpCapabilities.codecs.firstWhere((element) => element.mimeType.toLowerCase() == "video/vp8"),
        //         // encodings: [],

        //         /// RtpCodecCapability(kind: RTCRtpMediaTypeExtension.fromString("video"), mimeType: "video/vp8", clockRate: 90000),
        //         // encodings: [
        //         //   RtpEncodingParameters(rid: 'r0', scalabilityMode: 'L1T3', maxBitrate: 100000),
        //         //   RtpEncodingParameters(rid: 'r1', scalabilityMode: 'L1T3', maxBitrate: 300000),
        //         //   RtpEncodingParameters(rid: 'r2', scalabilityMode: 'L1T3', maxBitrate: 900000)
        //         // ],
        //         // codecOptions: ProducerCodecOptions(
        //         //   videoGoogleStartBitrate: 1000,
        //         // ),
        //         appData: {
        //           'source': 'audio',
        //         },
        //       );
        //     } else {
        //       print(localRTCVideoRenderer.srcObject);
        //       print("L O L " * 100);
        //       print(videoStream.getTracks());
        //       producerTransport!.produce(
        //         // stopTracks: false,
        //         track: videoStream.getVideoTracks().first,
        //         stream: videoStream,
        //         source: "video",
        //         // codec: device.rtpCapabilities.codecs.firstWhere((element) => element.mimeType.toLowerCase() == "video/vp8"),
        //         // encodings: [],

        //         /// RtpCodecCapability(kind: RTCRtpMediaTypeExtension.fromString("video"), mimeType: "video/vp8", clockRate: 90000),
        //         // encodings: [
        //         //   RtpEncodingParameters(rid: 'r0', scalabilityMode: 'L1T3', maxBitrate: 100000),
        //         //   RtpEncodingParameters(rid: 'r1', scalabilityMode: 'L1T3', maxBitrate: 300000),
        //         //   RtpEncodingParameters(rid: 'r2', scalabilityMode: 'L1T3', maxBitrate: 900000)
        //         // ],
        //         // codecOptions: ProducerCodecOptions(
        //         //   videoGoogleStartBitrate: 1000,
        //         // ),
        //         appData: {
        //           'source': 'webcam',
        //         },
        //       );
        //     }
        //   } catch (e) {
        //     print("* *" * 100);
        //     print(e);
        //     print("* *" * 100);
        //   }
        // } else {}
      });
    });
  }

  void appProducer(Transport appProducerTransports, MediaStream stream, String source) {
    // print("p" * 100);
    // print(stream.getTracks());
    // print("p" * 100);
    if (source == 'audio') {
      appProducerTransports.produce(
        track: stream.getAudioTracks().first,
        stream: stream,
        source: source,
      );
    } else if (source == 'video') {
      appProducerTransports.produce(
        track: stream.getVideoTracks().first,
        stream: stream,
        source: source,
      );
    } else if (source == 'both') {
      appProducerTransports.produce(
        track: stream.getVideoTracks().first,
        stream: stream,
        source: source,
      );
      appProducerTransports.produce(
        track: stream.getAudioTracks().first,
        stream: stream,
        source: source,
      );
    }
  }

  Future<void> getProducers() async {
    SocketConnetion.connection.emitWithAck('getProducers', "", ack: (producerIds) async {
      // print("55" * 100);
      // print(producerIds);
      // print("55" * 100);

      // for each of the producer create a consumer
      // producerIds.forEach(id => signalNewConsumerTransport(id))
      // To tdddddddddddddddddddddddddddddddddddddddddddd
      if (producerIds.isNotEmpty) {
        // print("producerIds is not empty");

        await producerIds.forEach((remoteProducerId) async => await signalNewConsumerTransport(
              remoteProducerId["producer"],
              remoteProducerId["socketid"],
              remoteProducerId["name"],
              remoteProducerId["isAdmin"],
            ));
      } else {
        // print("producerIds is empty");
      }
    });
  }

  signalNewConsumerTransport(String remoteProducerId, String socketId, String name, bool isAdmin) async {
    // print("signalNewConsumerTransport called");
    // print("$remoteProducerId , $socketId, $name, $isAdmin");
    //check if we are already consuming the remoteProducerId

    if (consumingTransports.contains(remoteProducerId)) {
      // print("in");
      return;
    }
    consumingTransports.add(remoteProducerId);

    SocketConnetion.connection.emitWithAck('createWebRtcTransport', {
      "consumer": true
    }, ack: (Map params) async {
      // The server sends back params needed
      // to create Send Transport on the client side
      // print("PARAMS...${params}");
      //print(params["params"]["serverConsumerId"]); //serverConsumerId
      late Transport consumerTransport;
      try {
        consumerTransport = device.createRecvTransportFromMap(params["params"], consumerCallback: (Consumer consumer, [dynamic accept]) {
          consumer.observer.on('pause', () {
            // print("p" * 10);
            // print("pause consumer");
            // print("p" * 10);
          });
          consumer.on('pause', () {
            // print("p" * 10);
            // print("pause consumer");
            // print("p" * 10);
          });

          // print("*" * 10);
          // print(consumer.track);
          // print(consumer.id);
          // print(consumer.producerId);
          // print(consumerTransport.id);
          // print(consumer.appData);
          // print("*" * 10);
          RTCVideoRenderer remoteVideoRenderers = RTCVideoRenderer();
          remoteVideoRenderers.initialize().then((value) {
            remoteVideoRenderers.srcObject = consumer.stream;

            var data = {
              "instance": remoteVideoRenderers,
              "socketid": socketId,
              "name": name,
              "isAdmin": isAdmin,
              "remoteProducerId": remoteProducerId,
              "isaudio": consumer.kind == "video" ? false : true,
              "isvideo": consumer.kind == "video" ? true : false,
              "audio": consumer.kind == "video"
                  ? null
                  : Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        height: 150,
                        width: 150,
                        color: Colors.red,
                        child: const Icon(Icons.audio_file_outlined),
                      ),
                    ),
              "video": consumer.kind == "video"
                  ? Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: RTCVideoView(
                          remoteVideoRenderers,
                          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                        ),
                      ),
                    )
                  : null
            };
            // print("*" * 100);
            // print(remoteProducerId);
            // print(remoteVideoRendererswidget.containsKey(remoteProducerId));
            // print(remoteVideoRendererswidget[remoteProducerId]);
            // print("*" * 100);
            remoteVideoRendererswidget[remoteProducerId] = {
              ...data
            };
            // print("*" * 100);
            // print("socket id ${socketids[socketId]}");
            // print(remoteVideoRendererswidget[remoteProducerId]!);

            // print(remoteVideoRendererswidget[remoteProducerId]!["socketid"] == socketids[socketId]);
            // print("*" * 100);
            if (socketids.containsKey(remoteVideoRendererswidget[remoteProducerId]!["socketid"])) {
              if (socketids[socketId]["video"] == null) {
                socketids[socketId]["video"] = data["video"];
                socketids[socketId]["isvideo"] = data["isvideo"];
                socketids[socketId]["isAdmin"] = data["isAdmin"];
              }
              if (socketids[socketId]["audio"] == null) {
                socketids[socketId]["isaudio"] = data["isaudio"];
                socketids[socketId]["isAdmin"] = data["isAdmin"];
              }
            } else {
              socketids[socketId] = data;
              // print("*" * 100);
              // print(socketids[socketId]);
              // print("*" * 100);
            }
            mediasoupCubit.addConsumer(socketids: socketids);
            // print("*" * 100);
            // print(socketids);
            // print(consumerTransport);
            // print(params["params"]["id"]);
            // print(remoteProducerId);
            // print("*" * 100);
            consumerTransports.add({
              "consumerTransport": consumerTransport,
              "serverConsumerTransportId": params["params"]["id"],
              "producerId": remoteProducerId,
              "consumer": consumer,
            });
            //print("*" * 100);
            //print(remoteVideoRendererswidget[remoteProducerId]);
            //print("*" * 100);
            SocketConnetion.connection.emit('consumer-resume', {
              "serverConsumerId": consumer.id,
            });
            // Future.delayed(const Duration(seconds: 1), () {
            //   accept({
            //     'consumerId': consumer.id
            //   });
            // });
          });
        }, dataConsumerCallback: (data) {});
      } catch (error) {
        //print(error);
        return;
      }
      mediasoupCubit.addConsumer(socketids: socketids);
      consumerTransport.observer.on('pause', () {
        // print("p" * 10);
        // print("pause consumer");
        // print("p" * 10);
      });
      consumerTransport.on('pause', () {
        // print("p" * 10);
        // print("pause consumer");
        // print("p" * 10);
      });
      consumerTransport.on('connect', (Map data) {
        var callback = data['callback'];
        var errback = data['errback'];
        try {
          //print(data);
          // Signal local DTLS parameters to the server side transport
          // see server's socket.on('transport-recv-connect', ...)
          SocketConnetion.connection.emit('transport-recv-connect', {
            "dtlsParameters": data['dtlsParameters'].toMap(),
            "serverConsumerTransportId": params["params"]["id"],
          });

          // Tell the transport that parameters were transmitted.
          callback();
        } catch (error) {
          //print(error);
          // Tell the transport that something was wrong
          errback(error.toString());
        }
      });
      await connectRecvTransport(consumerTransport, remoteProducerId, params["params"]["id"]);
    });
  }

  connectRecvTransport(Transport consumerTransport, String remoteProducerId, String serverConsumerTransportId) async {
    //print("connectRecvTransport called $remoteProducerId");
    // for consumer, we need to tell the server first
    // to create a consumer based on the rtpCapabilities and consume
    // if the router can consume, it will send back a set of params as below
    SocketConnetion.connection.emitWithAck(
        'consume',
        ({
          "rtpCapabilities": device.rtpCapabilities.toMap(),
          "remoteProducerId": remoteProducerId,
          "serverConsumerTransportId": serverConsumerTransportId,
        }), ack: (params) async {
      mediasoupCubit.addConsumer(socketids: socketids);
      // print("*" * 100);
      // print("Consumer Params ${params}");
      // print("*" * 100);
      // then consume with the local consumer transport
      // which creates a consumer
      // if (remoteVideoRendererswidget.containsKey(remoteProducerId)) {
      //   remoteVideoRendererswidget[remoteProducerId]!["serverConsumerId"] = params["params"]["serverConsumerId"];
      // } else {
      //   remoteVideoRendererswidget[remoteProducerId] = {};
      //   remoteVideoRendererswidget[remoteProducerId]!["serverConsumerId"] = params["params"]["serverConsumerId"];
      // }
      var callback = params["params"]['callback'];
      String errback = params["params"]['error'] ?? "";
      if (errback.isNotEmpty) {
        //print("errror ${errback}");
        return;
      }
      // print(device.loaded);
      Future.delayed(const Duration(seconds: 1), () {
        try {
          consumerTransport.consume(
            peerId: params["params"]["producerId"],
            id: params["params"]["id"],
            producerId: params["params"]["producerId"],
            kind: params["params"]["kind"] == "audio"
                ? RTCRtpMediaType.RTCRtpMediaTypeAudio
                : params["params"]["kind"] == "video"
                    ? RTCRtpMediaType.RTCRtpMediaTypeVideo
                    : RTCRtpMediaType.RTCRtpMediaTypeData,
            rtpParameters: RtpParameters.fromMap(params["params"]["rtpParameters"]),
            // accept: (para) {
            //   SocketConnetion.connection.emit('consumer-resume', {
            //     "serverConsumerId": params["consumerId"],
            //   });
            // }
          );
        } catch (e) {
          // print(e);
        }
      });

      // print(consumerTransports);
    });
  }

  disposeTransport({String? fortype}) {
    mediasoupCubit.isAudioOn = false;
    mediasoupCubit.isVideoOn = false;
    try {
      if (fortype != null) {
        // if (!(producerTransport?.closed ?? true)) {

        if (producers.containsKey("video") && fortype == "video") {
          producers["video"]?.close();
          // print(producers["video"]!.closed);
          producers.remove("video");
        }
        if (producers.containsKey("audio") && fortype == "audio") {
          producers["audio"]?.close();
          producers.remove("audio");
        }
      } else {
        if (producers.containsKey("video")) {
          producers["video"]?.close();
          producers.remove("video");
          // print(producers["video"]!.closed);
        }
        if (producers.containsKey("audio")) {
          producers["audio"]?.close();
          producers.remove("audio");
        }
      }
    } catch (e) {
      //
      // print(e);
    }
    try {
      if (!(producerTransport?.closed ?? true)) {
        // print("producerTransport closed " * 10);
        producerTransport!.close().then((value) {
          Future.delayed(const Duration(seconds: 2), () {
            for (var element in consumerTransports) {
              // print("consumer closed " * 100);
              element["consumerTransport"].close();
              element["consumer"].close();
              remoteVideoRendererswidget[element['producerId']]!["instance"].dispose();
              remoteVideoRendererswidget.removeWhere((key, value) => key == element['producerId']);
              socketids.removeWhere((key, value) => value["remoteProducerId"] == element['producerId']);
            }
            consumerTransports.clear();
            consumingTransports.clear();
            if (localRTCVideoRenderer.srcObject != null) {
              localRTCVideoRenderer.srcObject!.getTracks().forEach((track) {
                track.stop();
              });
              localRTCVideoRenderer.srcObject!.dispose();
              // localRTCVideoRenderer.dispose();
            }
            getProducers().then((value) {
              mediasoupCubit.addConsumer(socketids: socketids);
              mediasoupCubit.statecall();
            });
          });
        });
      }
    } catch (e) {
      // _logger.error(e);
    }
  }

  void dispose() {
    SocketConnetion.connection.emit("video-close", {
      'id': SocketConnetion.connection.id
    });
    try {
      if (!(producerTransport?.closed ?? true)) {
        producerTransport!.close();
      }
    } catch (e) {
      // _logger.error(e);
    }
    if (localRTCVideoRenderer.srcObject != null) {
      localRTCVideoRenderer.srcObject!.getTracks().forEach((track) {
        track.stop();
      });
      localRTCVideoRenderer.srcObject!.dispose();
      localRTCVideoRenderer.dispose();
    }
    remoteVideoRendererswidget.forEach((key, value) {
      if (value.containsKey("instance")) {
        value["instance"].dispose();
      }
    });
    remoteVideoRendererswidget.clear();
    for (var element in consumerTransports) {
      if (element.containsKey("producerId")) {
        element["consumerTransport"].close();
        element["consumer"].close();
        // remoteVideoRendererswidget[element['producerId']]!["instance"].dispose();
      }
    }
  }

  Future<RTCVideoRenderer> localvideoStream() async {
    localRTCVideoRenderer.initialize();
    MediaStream localStream;
    if (localRTCVideoRenderer.srcObject == null) {
      localStream = await createVideoStream();
    } else {
      localStream = localRTCVideoRenderer.srcObject!;
    }
    localRTCVideoRenderer.srcObject = localStream;
    // print("| |" * 100);
    return localRTCVideoRenderer;
  }

  Future<MediaStream> createVideoStream() async {
    MediaStream videoStream = await navigator.mediaDevices.getUserMedia({
      'audio': isAudioOn,
      'video': isVideoOn
          ? {
              'mandatory': {
                "width": {
                  "min": 640,
                  "max": 1920,
                },
                "height": {
                  "min": 400,
                  "max": 1080,
                },
                'facingMode': isFrontCameraSelected ? 'user' : 'environment',
                "frameRate": {
                  "ideal": 15,
                  "min": 15,
                  "max": 30,
                },
                "echoCancellation": true,
              }
            }
          : false,
    }).catchError((e, s) {
      flutterToast("Other Application using Camera or Audio ");
    });
    return videoStream;
  }
}
