// import 'package:http/http.dart' as http;
// import 'package:google_sign_in/google_sign_in.dart' as googleauth;
// import 'package:googleapis/youtube/v3.dart';

// class GoogleLiveServies {
// 	  String token = "";

// 	  Map<String, String>? authHeaders;

// 	  Future<Map<String, String>?> googleAuthApp() async {
// 	    // print("*" * 200000);
// 	    googleauth.GoogleSignInAccount? result;
// 	    final googleSignIn = googleauth.GoogleSignIn(
// 	      forceCodeForRefreshToken: true,
// 	      scopes: [
// 		"https://www.googleapis.com/auth/youtube.force-ssl",
// 		"https://www.googleapis.com/auth/youtube"
// 	      ],
// 	    );
// 	    result = await googleSignIn.signIn();
// 	    if (result != null) {
// 	      final googleauth.GoogleSignInAuthentication googleAuth =
// 		  await result.authentication;
// 	      final String? accessToken = googleAuth.accessToken;
// 	      token = accessToken!;
// 	      authHeaders = await result.authHeaders;
// 	      // print('----------------------------------------------');
// 	      // print('access Token: $accessToken');
// 	      // print(result);
// 	      // print(result.serverAuthCode);
// 	      // print(authHeaders!.entries);
// 	      // print(authHeaders!.keys);
// 	      // print(result.email);
// 	      // print('----------------------------------------------');
// 	    }
// 	    await googleSignIn.signOut();
// 	    return authHeaders;
// 	  }

//   Future<YouTubeApi> youTubeApiApp(
//       {required Map<String, String> authHeaders}) async {
//     // Create the YouTube API client
//     final baseClient = http.Client();
//     final authenticateClient = AuthenticateClient(authHeaders, baseClient);
//     final youtube = YouTubeApi(authenticateClient);
//     return youtube;
//   }

//   Future<List<LiveChatMessage>?> getLiveChatMessages(
//       {
//         //required String videoId,
//       required String liveChatId,
//       required Map<String, String> authHeaders}) async {
//     //videoId = "dxuNu4pabd4";
//     YouTubeApi youTubeApi = await youTubeApiApp(authHeaders: authHeaders);
//     // final video = await _youTubeApi.liveBroadcasts.list(
//     //   ["id", "snippet", "contentDetails", "status", "statistics"],
//     //   id: ["-kGrUqQp1Lo"],
//     // );
//     // print('----------------------------------------------');
//     // print(video);
//     // print(video.etag);
//     // print(video.eventId);
//     // print(video.nextPageToken);
//     // print(video.prevPageToken);
//     // print(video.items!.last.snippet!.liveChatId!);
//     // print('----------------------------------------------');

//     // Call the liveChatMessages.list method to get the chat messages
//     final messages = await youTubeApi.liveChatMessages.list(
//       //video.items!.last.snippet!.liveChatId!,
//       liveChatId,
//       ["id", 'snippet', "authorDetails"],
//     );
//     // print(messages);
//     // print(messages.items!.length);
//     // Print the chat messages to the console
//     // messages.items!.forEach((message) {
//     //   print('----------------------------------------------');
//     //   print(
//     //       '${message.authorDetails!.displayName}: ${message.snippet!.displayMessage}');
//     //   print('----------------------------------------------');
//     // });
//     return messages.items!;
//   }

//   Future<void> addLiveChatMessages(
//       {required String liveChatId,
//       required String message,
//       required Map<String, String> authHeaders}) async {
//     YouTubeApi youTubeApi = await youTubeApiApp(authHeaders: authHeaders);
//     LiveChatMessage requestbody = LiveChatMessage(
//       snippet: LiveChatMessageSnippet(
//           liveChatId: liveChatId,
//           type: "textMessageEvent",
//           textMessageDetails: LiveChatTextMessageDetails(messageText: message)),
//     );
//     // final addmessaage =
//         await youTubeApi.liveChatMessages.insert(requestbody, ["snippet"]);
//     // print(liveChatId);
//   }
// }

// class AuthenticateClient extends http.BaseClient {
//   final Map<String, String> headers;

//   final http.Client client;

//   AuthenticateClient(this.headers, this.client);

//   @override
//   Future<http.StreamedResponse> send(http.BaseRequest request) {
//     return client.send(request..headers.addAll(headers));
//   }
// }
