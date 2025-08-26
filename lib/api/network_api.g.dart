// ignore_for_file: no_leading_underscores_for_local_identifiers

part of 'network_api.dart';

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl}) {
    baseUrl ??= Apis.baseUrl;
  }

  final Dio _dio;

  String? baseUrl;
  @override
  Future<Getbannerdetails> bannerimagesRequest({String? categoryName}) async {
    const _extra = <String, dynamic>{};
    Map<String, dynamic> queryParameters = <String, dynamic>{
      'BannerType': "APP"
    };
    if (categoryName?.isNotEmpty ?? categoryName != null) {
      queryParameters['categoryName'] = categoryName;
    }
    final _headers = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
      _setStreamType<Getbannerdetails>(
        Options(method: 'GET', headers: _headers, extra: _extra).compose(_dio.options, Apis.banner, queryParameters: queryParameters).copyWith(
              baseUrl: baseUrl ?? _dio.options.baseUrl,
            ),
      ),
    );
    final value = Getbannerdetails.fromJson(_result.data!);
    return value;
  }

  @override
  joinmeetingRequest(body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = body;
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<JoinStreaming>(Options(method: 'POST', headers: _headers, extra: _extra).compose(_dio.options, Apis.joinmeeting, queryParameters: queryParameters, data: _data).copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = JoinStreaming.fromJson(_result.data!);
    return value;
  }

  @override
  streaminguserdetailsRequest() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<StreamingUserDetails>(Options(method: 'GET', headers: _headers, extra: _extra).compose(_dio.options, Apis.streamingUserDetails, queryParameters: queryParameters).copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = StreamingUserDetails.fromJson(_result.data!);
    return value;
  }

  @override
  deleteuserdetailsfromstreamRequest(body) async {
    // try {
    //   var response = await dioAuthorizationData()
    //       .delete('${Apis.baseUrl}${Apis.deleteUserDetailsFromStream}$body');
    //   print(response);
    //   final value = DeleteUserDetailsFromStream.fromJson(response.data!);
    //   return value;
    // } catch (error) {
    //   rethrow;
    // }
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = body;
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<DeleteUserDetailsFromStream>(Options(method: 'DELETE', headers: _headers, extra: _extra).compose(_dio.options, Apis.deleteUserDetailsFromStream, queryParameters: queryParameters, data: _data).copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = DeleteUserDetailsFromStream.fromJson(_result.data!);
    return value;
  }

  // @override
  // addtocartRequest(body) async {
  //   const _extra = <String, dynamic>{};
  //   final queryParameters = <String, dynamic>{};
  //   final _headers = <String, dynamic>{};
  //   final _data = body;
  //   final _result = await _dio.fetch<Map<String, dynamic>>(
  //       _setStreamType<AddToCart>(
  //           Options(method: 'POST', headers: _headers, extra: _extra)
  //               .compose(_dio.options, Apis.addtocart,
  //                   queryParameters: queryParameters, data: _data)
  //               .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
  //   final value = AddToCart.fromJson(_result.data!);
  //   return value;
  // }

  @override
  getorderidRequest(body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = body;
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<OrderIdGeneration>(Options(method: 'POST', headers: _headers, extra: _extra).compose(_dio.options, Apis.createOrder, queryParameters: queryParameters, data: _data).copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    // print(_result.data);
    final value = OrderIdGeneration.fromJson(_result.data!);
    return value;
  }

  // @override
  // removefromcartRequest(body) async {
  //   final queryParameters = <String, dynamic>{"id": body};
  //   final _result = await _dio.delete(
  //     Apis.baseUrl + Apis.removefromCart,
  //     queryParameters: queryParameters,
  //   );
  //   final value = RemovefromCart.fromJson(_result.data!);
  //   return value;
  // }

  @override
  getnotificationRequest() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<NotificationGet>(Options(method: 'GET', headers: _headers, extra: _extra).compose(_dio.options, Apis.getnotification, queryParameters: queryParameters).copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = NotificationGet.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic && !(requestOptions.responseType == ResponseType.bytes || requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
