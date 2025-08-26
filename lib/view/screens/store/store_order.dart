import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/get_store_order.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/store/store_order_detail.dart';

class StoreOrderScreen extends StatefulWidget {
  const StoreOrderScreen({super.key});

  @override
  State<StoreOrderScreen> createState() => _StoreOrderScreenState();
}

class _StoreOrderScreenState extends State<StoreOrderScreen> {
  bool update = false;

  double userRating = 0;

  TextEditingController controllerHeading = TextEditingController();

  TextEditingController controllerDescripation = TextEditingController();
  @override
  void dispose() {
    controllerDescripation.dispose();
    controllerHeading.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: "app_store_orders",
      screenClass: "StoreOrderScreen",
    );
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: ColorResources.textWhite,
      //   elevation: 0,
      //   iconTheme: IconThemeData(color: ColorResources.textblack),
      //   title: Text(
      //     'My Orders',
      //     style: GoogleFonts.notoSansDevanagari(
      //       color: ColorResources.textblack,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
      body: FutureBuilder<GetStoreOrders>(
          future: RemoteDataSourceImpl().getStoreOrdersRequest(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              // print(snapshot.data!.toJson());
              if (snapshot.hasData) {
                return snapshot.data!.data!.isEmpty
                    ? Center(
                        child: EmptyWidget(image: SvgImages.emptyOrder, text: "There are no Orders"),
                      )
                    : ListView.builder(
                        itemCount: snapshot.data!.data!.length,
                        // shrinkWrap: true,
                        itemBuilder: (context, index) => GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => StoreOrderDetailScreen(
                                          getStoreOrdersData: snapshot.data!.data![index],
                                        )));
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorResources.borderColor,
                                  ),
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Order Id : ${snapshot.data!.data![index].orderId!}",
                                              style: TextStyle(
                                                color: ColorResources.textblack,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              "Order Date : ${DateFormat("dd MMM yyyy").format(DateFormat("dd-MM-yyyy").parse(snapshot.data!.data![index].purchaseDate ?? ""))}",
                                              style: TextStyle(
                                                color: ColorResources.textBlackSec,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                height: 0,
                                                letterSpacing: -0.48,
                                              ),
                                            )
                                          ],
                                        ),
                                        const Divider(),
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: snapshot.data!.data?[index].products?.length ?? 0,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, pindex) {
                                              return Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: CachedNetworkImage(
                                                        placeholder: (context, url) => const Center(
                                                          child: CircularProgressIndicator(),
                                                        ),
                                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                                        imageUrl: snapshot.data!.data![index].products?[pindex].featuredImage ?? "",
                                                        height: 100,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      flex: 2,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            snapshot.data!.data![index].products?[pindex].title ?? "",
                                                            maxLines: 3,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                              color: ColorResources.textblack,
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            '${Preferences.appString.quantity ?? "Quantity"}: ${snapshot.data!.data![index].products?[pindex].quantity} ',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: ColorResources.textblack,
                                                              fontSize: 10,
                                                              fontFamily: 'Sora',
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            '${"Amount"}: ${snapshot.data!.data![index].products?[pindex].productAmount} ',
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(
                                                              color: ColorResources.textblack,
                                                              fontSize: 10,
                                                              fontFamily: 'Sora',
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ))
                                                ],
                                              );
                                            })
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0, top: 2.0, left: 10, right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Payment Mode: ',
                                                style: TextStyle(
                                                  color: ColorResources.textblack,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                              TextSpan(
                                                text: snapshot.data!.data![index].orderType == "prePaid" ? "Online" : snapshot.data!.data![index].orderType ?? "",
                                                style: TextStyle(
                                                  color: ColorResources.textBlackSec,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Payment: ',
                                                style: TextStyle(
                                                  color: ColorResources.textblack,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                              TextSpan(
                                                text: snapshot.data!.data![index].paymentStatus,
                                                style: TextStyle(
                                                  color: snapshot.data!.data![index].paymentStatus == "success"
                                                      ? const Color(0xFF4CAF50)
                                                      : snapshot.data!.data![index].paymentStatus == "failed"
                                                          ? const Color(0xFFFB5259)
                                                          : const Color(0xFFFCA120),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  height: 0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0, top: 2.0, left: 10, right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Payment Amount: ₹ ${snapshot.data!.data![index].totalAmount}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: ColorResources.textblack,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          Preferences.appString.viewDetailAnalysis ?? 'View Order Details',
                                          style: TextStyle(
                                            color: ColorResources.buttoncolor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  snapshot.data!.data![index].isPaid!
                                      ? Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Divider(),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    Preferences.appString.shippingDetails ?? 'Shipping Details',
                                                    style: TextStyle(
                                                      color: ColorResources.textBlackSec,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                      height: 0,
                                                      letterSpacing: -0.48,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "${snapshot.data!.data![index].shippingAddress!.streetAddress ?? ""} , ${snapshot.data!.data![index].shippingAddress!.city ?? ''} , ${snapshot.data!.data![index].shippingAddress!.country ?? ''} , ${snapshot.data!.data![index].shippingAddress!.pinCode ?? ''}",
                                                    style: TextStyle(
                                                      color: ColorResources.textBlackSec,
                                                      fontSize: 12,
                                                      fontFamily: 'Quicksand',
                                                      fontWeight: FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    '+91 - ${snapshot.data!.data![index].shippingAddress!.phone!}',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: ColorResources.textblack,
                                                      fontSize: 12,
                                                      fontFamily: 'Sora',
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  // Row(
                                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  //   children: [
                                                  //     snapshot.data!.data![index].isRated!
                                                  //         ? Column(
                                                  //             children: [
                                                  //               Text(
                                                  //                 'Your Rated',
                                                  //                 textAlign: TextAlign.center,
                                                  //                 style: TextStyle(
                                                  //                   color: ColorResources.textblack,
                                                  //                   fontSize: 12,
                                                  //                   fontFamily: 'Sora',
                                                  //                   fontWeight: FontWeight.w600,
                                                  //                 ),
                                                  //               ),
                                                  //               const SizedBox(
                                                  //                 height: 5,
                                                  //               ),
                                                  //               Row(
                                                  //                 children: List<Widget>.generate(
                                                  //                   int.parse(snapshot.data!.data![index].rating!),
                                                  //                   (index) => Icon(
                                                  //                     Icons.star,
                                                  //                     color: Colors.amber[400],
                                                  //                   ),
                                                  //                 ),
                                                  //               ),
                                                  //             ],
                                                  //           )
                                                  //         : OutlinedButton(
                                                  //             onPressed: () {
                                                  //               reviewsend(orderid: snapshot.data!.data![index].id!, context: context).then((value) {
                                                  //                 if (update) {
                                                  //                   safeSetState(() {
                                                  //                     update = false;
                                                  //                   });
                                                  //                 }
                                                  //               });
                                                  //             },
                                                  //             style: OutlinedButton.styleFrom(
                                                  //               backgroundColor: ColorResources.buttoncolor.withValues(alpha:0.2),
                                                  //               shape: RoundedRectangleBorder(
                                                  //                 side: BorderSide(
                                                  //                   color: ColorResources.buttoncolor,
                                                  //                 ),
                                                  //                 borderRadius: BorderRadius.circular(10),
                                                  //               ),
                                                  //             ),
                                                  //             child: Text(
                                                  //               'Write a Review',
                                                  //               textAlign: TextAlign.center,
                                                  //               style: TextStyle(
                                                  //                 color: ColorResources.buttoncolor,
                                                  //                 fontSize: 12,
                                                  //                 fontWeight: FontWeight.w500,
                                                  //               ),
                                                  //             ),
                                                  //           ),
                                                  //     OutlinedButton(
                                                  //       onPressed: () {
                                                  //         flutterToast('flie downloading');
                                                  //       },
                                                  //       style: OutlinedButton.styleFrom(
                                                  //         backgroundColor: ColorResources.buttoncolor.withValues(alpha:0.2),
                                                  //         shape: RoundedRectangleBorder(
                                                  //           side: BorderSide(
                                                  //             width: 3,
                                                  //             color: ColorResources.buttoncolor,
                                                  //           ),
                                                  //           borderRadius: BorderRadius.circular(10),
                                                  //         ),
                                                  //       ),
                                                  //       child: Text(
                                                  //         'Dowload invoice',
                                                  //         textAlign: TextAlign.center,
                                                  //         style: TextStyle(
                                                  //           color: ColorResources.buttoncolor,
                                                  //           fontSize: 12,
                                                  //           fontWeight: FontWeight.w500,
                                                  //         ),
                                                  //       ),
                                                  //     ),
                                                  //   ],
                                                  // )
                                                ],
                                              ),
                                            )
                                          ],
                                        )
                                      : Container(),
                                ]),
                              ),
                            ));
              } else {
                return ErrorWidgetapp(image: SvgImages.error404, text: "Page not found");
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Future reviewsend({
    required BuildContext context,
    required String orderid,
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Write a Review',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorResources.textblack,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Preferences.appString.rateThisBook ?? 'Rate this book',
                    style: TextStyle(
                      color: ColorResources.textblack,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    // itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.yellow,
                    ),
                    onRatingUpdate: (rating) {
                      userRating = rating;
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Add a headline',
                    style: TextStyle(
                      color: ColorResources.textblack,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: controllerHeading,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Write here....',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Add detailed Review',
                    style: TextStyle(
                      color: ColorResources.textblack,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: controllerDescripation,
                    maxLines: 3,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Write here....',
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        RemoteDataSourceImpl()
                            .postProductReviewRequest(
                          id: orderid,
                          rating: userRating.toString(),
                          description: controllerDescripation.text,
                          title: controllerHeading.text,
                        )
                            .then((value) {
                          if (value.status) {
                            safeSetState(() {
                              update = true;
                            });
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        Preferences.appString.submit ?? 'Submit',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
