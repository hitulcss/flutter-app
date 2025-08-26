import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:sd_campus_app/api/api.dart';
import 'package:sd_campus_app/models/deleteuserdetailsfromstream.dart';
import 'package:sd_campus_app/models/streaminguserdetails.dart';
import 'package:sd_campus_app/models/banner.dart';
import 'package:sd_campus_app/models/joinstreaming.dart';
import 'package:sd_campus_app/models/notificationget.dart';
import 'package:sd_campus_app/models/orderidgeneration.dart';

part 'network_api.g.dart';

@RestApi(baseUrl: Apis.baseUrl)
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @GET(Apis.banner)
  Future<Getbannerdetails> bannerimagesRequest({String? categoryName});

  @POST(Apis.joinmeeting)
  Future<JoinStreaming> joinmeetingRequest(@Body() body);

  @GET(Apis.streamingUserDetails)
  Future<StreamingUserDetails> streaminguserdetailsRequest();

  @DELETE(Apis.deleteUserDetailsFromStream)
  Future<DeleteUserDetailsFromStream> deleteuserdetailsfromstreamRequest(@Body() body);

  // @POST(Apis.joinmeeting)
  // Future<AddToCart> addtocartRequest(@Body() body);

  @POST(Apis.joinmeeting)
  Future<OrderIdGeneration> getorderidRequest(@Body() body);

  // @DELETE(Apis.removefromCart)
  // Future<RemovefromCart> removefromcartRequest(@Body() body);

  @GET(Apis.getnotification)
  Future<NotificationGet> getnotificationRequest();
}
