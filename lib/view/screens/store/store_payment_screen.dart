import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/cubit/coupon/coupon_cubit.dart';
import 'package:sd_campus_app/features/cubit/storeAddress/StoreAddress_cubit.dart';
import 'package:sd_campus_app/features/data/remote/models/base_model.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/view/screens/coupon_page.dart';
import 'package:sd_campus_app/view/screens/store/store_order.dart';
import 'package:url_launcher/url_launcher.dart';

class StorePaymentScreen extends StatefulWidget {
  final List<ProductData> productdata;
  final int amount;
  bool isCouponapplied;
  StorePaymentScreen({super.key, required this.productdata, required this.amount, this.isCouponapplied = false});

  @override
  State<StorePaymentScreen> createState() => _StorePaymentScreenState();
}

class _StorePaymentScreenState extends State<StorePaymentScreen> {
  //payment gateway
  var cfPaymentGatewayService = CFPaymentGatewayService();
  CFEnvironment environment = kDebugMode ? CFEnvironment.SANDBOX : CFEnvironment.PRODUCTION;

  double couponamount = 0;
  int discount = 0;
  int amount = 0;

  int coinamount = 0;

  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _AddressController = TextEditingController();
  final TextEditingController _LandMarkController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  String isOnline = '';

  double totalamount = 0;

  String deliveryType = "online";

  @override
  void initState() {
    super.initState();
    cfPaymentGatewayService.setCallback(
      verifyPayment,
      onError,
    );
    discount = 0;
    amount = 0;
    totalamount = amount.toDouble();
    for (var element in widget.productdata) {
      //print(element.discount);
      amount = amount + (element.amount * element.quantity);
      discount = discount + (element.discount * element.quantity);
    }
    //print(discount);
    if (widget.isCouponapplied == false) {
      remove();
    }
  }

  void verifyPayment(String orderId) {
    // print("Verify Payment ${orderId}");
    apppsymentverify(id: orderId).then((value) {
      // print(value.toJson());
      flutterToast(value.msg);
      if (value.status) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const StoreOrderScreen(),
        ));
      }
    });
  }

  void onError(CFErrorResponse errorResponse, String orderId) {
    // print(errorResponse.getMessage());
    // print("Error while making payment ${orderId}");
    apppsymentverify(id: orderId).then((value) {
      // print(value.toJson());
      flutterToast(value.msg);
    });
  }

  CFSession? createSession({
    required String orderId,
    required String paymentSessionId,
  }) {
    try {
      var session = CFSessionBuilder().setEnvironment(environment).setOrderId(orderId).setPaymentSessionId(paymentSessionId).build();
      return session;
    } on CFException catch (e) {
      debugPrint(e.message);
      // print(e.message);
    }
    return null;
  }

  void openCheckout({
    required String orderId,
    required String paymentSessionId,
  }) async {
    try {
      var session = createSession(orderId: orderId, paymentSessionId: paymentSessionId);
      List<CFPaymentModes> components = <CFPaymentModes>[];
      var paymentComponent = CFPaymentComponentBuilder().setComponents(components).build();

      var theme = CFThemeBuilder().setNavigationBarBackgroundColorColor("#FF0000").setPrimaryFont("Menlo").setSecondaryFont("Futura").build();

      var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder().setSession(session!).setPaymentComponent(paymentComponent).setTheme(theme).build();

      cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
    } on CFException catch (e) {
      // print(e.message);
    }
  }

  int findTotalChargeInRange(Map<String, dynamic>? deliveryData, int amount) {
    if (deliveryData == null) return 0; // Return 0 if delivery data is null

    int totalCharge = 0;
    for (var key in deliveryData.keys) {
      try {
        // Split the range key into start and end values with null check
        List<int> range = key.split('-').map(int.parse).toList();
        if (range.length != 2) {
          throw FormatException("Invalid range format: $key"); // Handle invalid format
        }
        int start = range[0];
        int end = range[1];

        // Check if the amount falls within the current range (inclusive)
        if (amount >= start && amount <= end) {
          totalCharge = deliveryData[key]!; // Assign charge if within range (null safety)
          break; // Exit loop after finding a match (assuming only one match needed)
        }
      } on FormatException catch (e) {
        // print("Error parsing range: $e"); // Handle parsing errors gracefully
        return 0;
      }
    }
    return totalCharge;
  }

  @override
  void dispose() {
    _countryController.dispose();
    _nameController.dispose();
    _pinCodeController.dispose();
    _AddressController.dispose();
    _LandMarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  remove() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoreAddressCubit>().getStoreAddressapi().then((value) {
        if (value!.data!.isEmpty) {
          //print(value.data!.length);
          address(context);
        }
      });
      // if (SharedPreferenceHelper.getString(Preferences.address) == 'N/A' || SharedPreferenceHelper.getString(Preferences.address)!.isEmpty) {
      // }
      // executes after build
    });
    context.read<CouponCubit>().couponremove();
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: "app_store_checkout",
      screenClass: "StorepaymentScreen",
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.textWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          Preferences.appString.placeOrder ?? 'Place Order',
          style: GoogleFonts.notoSansDevanagari(
            color: ColorResources.textblack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(
              //   height: 10,
              // ),

              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: ColorResources.borderColor,
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 15.0,
                      ),
                      child: Text(
                        Preferences.appString.billDetails ?? 'Bill Details',
                        style: GoogleFonts.notoSansDevanagari(
                          color: ColorResources.textblack,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 0,
                          letterSpacing: -0.56,
                        ),
                      ),
                    ),
                    const Divider(),
                    MediaQuery.removePadding(
                      context: context,
                      removeBottom: true,
                      removeTop: true,
                      child: ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: widget.productdata.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                      imageUrl: widget.productdata[index].image,
                                      height: 70,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.productdata[index].name,
                                        style: GoogleFonts.notoSansDevanagari(
                                          color: ColorResources.textblack,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                          letterSpacing: -0.48,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${Preferences.appString.quantity ?? "Quantity"} :',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.notoSansDevanagari(
                                              color: ColorResources.textblack,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            widget.productdata[index].quantity.toString(),
                                            style: GoogleFonts.notoSansDevanagari(
                                              color: ColorResources.textBlackSec,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${Preferences.appString.amount ?? "Amount"} :',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.notoSansDevanagari(
                                              color: ColorResources.textblack,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "₹ ${widget.productdata[index].amount}",
                                            style: GoogleFonts.notoSansDevanagari(
                                              color: ColorResources.textBlackSec,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 15.0,
                      ),
                      child: Column(
                        children: [
                          BlocBuilder<CouponCubit, CouponState>(
                            builder: (context, state) {
                              if (state is CouponAddState) {
                                return couponappllied(
                                  couponname: state.couponcode,
                                  couponvalue: state.value,
                                );
                              } else {
                                couponamount = 0;
                              }

                              return GestureDetector(
                                onTap: () {
                                  List linkwith = [];
                                  for (var element in widget.productdata) {
                                    linkwith.add(element.id);
                                  }
                                  Navigator.of(context).push(
                                    CupertinoPageRoute(
                                      builder: (context) => CouponScreen(
                                        linkwith: linkwith,
                                        link: "product",
                                        amount: discount.toDouble(),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: ColorResources.buttoncolor.withValues(alpha: 0.15),
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: ColorResources.buttoncolor,
                                          ),
                                          color: ColorResources.textWhite,
                                        ),
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Icon(
                                              Icons.local_offer_outlined,
                                              color: ColorResources.buttoncolor,
                                            ),
                                            const Spacer(
                                              flex: 1,
                                            ),
                                            Text(
                                              "Enter coupon code",
                                              style: GoogleFonts.notoSansDevanagari(
                                                fontSize: 12,
                                                color: ColorResources.textBlackSec,
                                              ),
                                            ),
                                            const Spacer(
                                              flex: 3,
                                            ),
                                            Text(
                                              "Apply".toUpperCase(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: ColorResources.buttoncolor,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Available Coupon",
                                        style: GoogleFonts.notoSansDevanagari(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: ColorResources.textblack,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Preferences.appString.price ?? 'Order Value',
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textblack,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                              Text(
                                '₹$amount',
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textblack,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                  letterSpacing: -0.40,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Discount',
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textblack,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                              Text(
                                '- ₹ ${amount - discount}',
                                style: GoogleFonts.notoSansDevanagari(
                                  color: const Color(0xFF1D7025),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                  letterSpacing: -0.40,
                                ),
                              ),
                            ],
                          ),

                          BlocBuilder<CouponCubit, CouponState>(
                            builder: (context, state) {
                              if (state is CouponAddState) {
                                if (state.coupontype == "fixed") {
                                  couponamount = (discount - state.value) > 1 ? state.value.toDouble() : 0;
                                } else {
                                  couponamount = (discount - (discount * (state.value / 100))) > 1 ? (discount * (state.value / 100)) : 0;
                                }
                                return Column(
                                  children: [
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          Preferences.appString.deliveryCharges ?? 'delivery charges',
                                          style: GoogleFonts.notoSansDevanagari(
                                            color: ColorResources.textblack,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                        Text(
                                          findTotalChargeInRange(Preferences.remoteStore["delivery"], discount) == 0 ? 'Free' : '+ ₹ ${findTotalChargeInRange(Preferences.remoteStore["delivery"], discount)}',
                                          style: GoogleFonts.notoSansDevanagari(
                                            color: const Color(0xFF1D7025),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            height: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Coupon Disc.',
                                          style: GoogleFonts.notoSansDevanagari(
                                            color: ColorResources.textblack,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                        Text(
                                          '- ₹ ${couponamount.toStringAsFixed(2)}',
                                          style: GoogleFonts.notoSansDevanagari(
                                            color: const Color(0xFF1D7025),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              }
                              return Column(
                                children: [
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Preferences.appString.deliveryCharges ?? 'delivery charges',
                                        style: GoogleFonts.notoSansDevanagari(
                                          color: ColorResources.textblack,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                        ),
                                      ),
                                      Text(
                                        '+ ₹ ${findTotalChargeInRange(Preferences.remoteStore["delivery"], discount)}',
                                        style: GoogleFonts.notoSansDevanagari(
                                          color: const Color(0xFF1D7025),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          //  BlocBuilder<CoinCubit, CoinState>(
                          // builder: (context, state) {
                          //   coinamount = context.read<CoinCubit>().getcoinApplied()
                          //       ? int.parse(widget.course.discount) - couponamount - double.parse(widget.course.maxAllowedCoins) > 1
                          //           ? int.parse(widget.course.maxAllowedCoins)
                          //           : 0
                          //       : 0;
                          //   return context.read<CoinCubit>().getcoinApplied() && coinamount > 0
                          //     ? Column(
                          //       children: [
                          // const SizedBox(
                          //   height: 5,
                          // ),
                          //         Row(
                          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             Text(
                          //               'Coins',
                          //               style: GoogleFonts.notoSansDevanagari(
                          //                 color: ColorResources.textblack,
                          //                 fontSize: 12,
                          //                 fontWeight: FontWeight.w500,
                          //                 height: 0,
                          //               ),
                          //             ),
                          //             BlocBuilder<CoinCubit, CoinState>(builder: (context, state) {
                          //               return Text(
                          //                 '-₹ ',
                          //                 style: GoogleFonts.notoSansDevanagari(
                          //                   color: ColorResources.textblack,
                          //                   fontSize: 12,
                          //                   fontWeight: FontWeight.w400,
                          //                   height: 0,
                          //                   letterSpacing: -0.40,
                          //                 ),
                          //               );
                          //             })
                          //           ],
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // ),
                        ],
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 15.0,
                      ),
                      child: BlocBuilder<CouponCubit, CouponState>(
                        builder: (context, state) {
                          totalamount = discount - couponamount;
                          // print(totalamount);
                          // print(amount - discount);
                          // print(amount);
                          // print(discount);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Preferences.appString.totalAmount ?? 'Total Amount',
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textblack,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '₹${(discount - couponamount) + findTotalChargeInRange(Preferences.remoteStore["delivery"], (discount).toInt())}',
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textblack,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<StoreAddressCubit, StoreAddressState>(
                builder: (context, state) {
                  //print(state);
                  if (state is StoreAddressApiSuccess) {
                    //print(state.getStoreAddress.data);
                    if (state.getStoreAddress.data!.isEmpty) {
                      // address(context);
                    }
                    int index = context.read<StoreAddressCubit>().selectStoreAddress!;
                    return state.getStoreAddress.data!.isEmpty
                        ? Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.place_outlined),
                                const SizedBox(
                                  height: 10,
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    address(context);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: ColorResources.buttoncolor.withValues(alpha: 0.1),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'Add Address',
                                    style: TextStyle(
                                      color: ColorResources.buttoncolor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      height: 0,
                                      letterSpacing: -0.56,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Preferences.appString.selectAddress ?? 'Select Address',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.notoSansDevanagari(
                                      color: ColorResources.textblack,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                      letterSpacing: -0.56,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      alladdress(
                                        context,
                                      );
                                    },
                                    child: Text(
                                      Preferences.appString.changeAddress ?? 'Change Address',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: ColorResources.buttoncolor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                        letterSpacing: -0.56,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              // SharedPreferenceHelper.getString(Preferences.name)!,
                                              state.getStoreAddress.data![index].name!,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.notoSansDevanagari(
                                                color: ColorResources.textblack,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "${state.getStoreAddress.data![index].streetAddress ?? ''},${state.getStoreAddress.data![index].city ?? ''},${state.getStoreAddress.data![index].state ?? ''},${state.getStoreAddress.data![index].country ?? ''},${state.getStoreAddress.data![index].pinCode ?? ''}",
                                                    style: GoogleFonts.notoSansDevanagari(
                                                      color: ColorResources.textBlackSec,
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '+91-${state.getStoreAddress.data![index].phone}',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.notoSansDevanagari(
                                                color: ColorResources.textblack,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                                letterSpacing: -0.48,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          _countryController.text = state.getStoreAddress.data!.first.country!;
                                          _nameController.text = state.getStoreAddress.data!.first.name!;
                                          _pinCodeController.text = state.getStoreAddress.data!.first.pinCode!;
                                          _LandMarkController.text = state.getStoreAddress.data!.first.streetAddress!;
                                          _cityController.text = state.getStoreAddress.data!.first.city!;
                                          _stateController.text = state.getStoreAddress.data!.first.state!;
                                          _numberController.text = state.getStoreAddress.data!.first.phone!;
                                          address(context, id: state.getStoreAddress.data!.first.id);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 7,
                                            horizontal: 10,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(
                                              color: ColorResources.buttoncolor,
                                            ),
                                            color: ColorResources.buttoncolor.withValues(alpha: 0.1),
                                          ),
                                          child: Text(
                                            Preferences.appString.edit ?? 'Edit',
                                            style: GoogleFonts.notoSansDevanagari(
                                              color: ColorResources.buttoncolor,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              height: 0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                  } else if (state is StoreAddressApiError) {
                    return ErrorWidgetapp(image: SvgImages.error404, text: "Page not found");
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 8.0, top: 15.0),
                      child: Text(
                        'Payment Methods',
                        style: TextStyle(
                          color: ColorResources.textblack,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            value: "COD",
                            dense: true,
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            groupValue: deliveryType,
                            onChanged: (value) {
                              safeSetState(() {
                                deliveryType = value ?? "";
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              Preferences.appString.cashOnDelivered ?? 'Cash on Delivery',
                              style: TextStyle(
                                color: ColorResources.textblack,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            contentPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            dense: true,
                            value: "online",
                            groupValue: deliveryType,
                            onChanged: (value) {
                              safeSetState(() {
                                deliveryType = value ?? "";
                              });
                            },
                            title: Text(
                              Preferences.appString.onlinePayment ?? 'Online Payment',
                              style: TextStyle(
                                color: ColorResources.textblack,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: ColorResources.borderColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Icon(
                              Icons.security,
                              size: 20,
                              color: ColorResources.buttoncolor,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              Preferences.appString.securePayment ?? 'Secure Payments',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.notoSansDevanagari(
                                color: ColorResources.textblack,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        ),
                      ),
                      const VerticalDivider(),
                      Expanded(
                        child: Column(
                          children: [
                            Icon(
                              Icons.published_with_changes_rounded,
                              size: 20,
                              color: ColorResources.buttoncolor,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text.rich(
                              textAlign: TextAlign.center,
                              TextSpan(children: [
                                TextSpan(
                                  text: "${Preferences.appString.easyReturnProduct ?? 'Easy Return Product'}\n",
                                  style: GoogleFonts.notoSansDevanagari(
                                    color: ColorResources.textblack,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                    letterSpacing: -0.40,
                                  ),
                                ),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      //https://store.sdcampus.com/return-refund-policy
                                      launchUrl(Uri.parse("https://store.sdcampus.com/return-refund-policy"), mode: LaunchMode.externalApplication);
                                    },
                                  text: 'See More',
                                  style: GoogleFonts.notoSansDevanagari(
                                    color: ColorResources.buttoncolor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                    letterSpacing: -0.40,
                                  ),
                                ),
                              ]),
                            )
                          ],
                        ),
                      ),
                      const VerticalDivider(),
                      Expanded(
                        child: Column(
                          children: [
                            Icon(
                              Icons.local_shipping_outlined,
                              size: 20,
                              color: ColorResources.buttoncolor,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text.rich(
                              textAlign: TextAlign.center,
                              TextSpan(children: [
                                TextSpan(
                                  text: "${Preferences.appString.trustedShipping ?? 'Tursted Shipping'}\n",
                                  style: GoogleFonts.notoSansDevanagari(
                                    color: ColorResources.textblack,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                    letterSpacing: -0.40,
                                  ),
                                ),
                                TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launchUrl(Uri.parse("https://store.sdcampus.com/terms-and-conditions"), mode: LaunchMode.externalApplication);
                                    },
                                  text: 'See More',
                                  style: GoogleFonts.notoSansDevanagari(
                                    color: ColorResources.buttoncolor,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                    letterSpacing: -0.40,
                                  ),
                                ),
                              ]),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  //print(context.read<CouponCubit>().couponcodeid);
                  //print(totalamount);
                  // //print(context.read<StoreAddressCubit>().data!.data![context.read<StoreAddressCubit>().selectStoreAddress!].id);
                  List<Map<String, String>> products = [];
                  for (var element in widget.productdata) {
                    products.add({
                      "productId": element.id,
                      "quantity": element.quantity.toString(),
                    });
                  }
                  //print(products);
                  if (context.read<StoreAddressCubit>().data?.data?.isEmpty ?? true) {
                    //print("object");
                    flutterToast("Please Add The Address");
                    address(context);
                  } else {
                    Preferences.onLoading(context);

                    if (deliveryType == "COD") {
                      RemoteDataSourceImpl()
                          .storeOrderCODRequest(
                        couponId: context.read<CouponCubit>().couponcodeid,
                        totalAmount: (totalamount + findTotalChargeInRange(Preferences.remoteStore["delivery"], (discount).toInt())).toString(),
                        addressId: context.read<StoreAddressCubit>().data!.data![context.read<StoreAddressCubit>().selectStoreAddress!].id!,
                        products: products,
                        deliveryCharges: findTotalChargeInRange(Preferences.remoteStore["delivery"], discount.toInt()).toString(),
                      )
                          .then((value) {
                        flutterToast(value.msg);
                        Preferences.hideDialog(context);
                        if (value.status) {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const StoreOrderScreen(),
                          ));
                        }
                      });
                    } else {
                      RemoteDataSourceImpl()
                          .storeOrderIdGenerateRequest(
                        couponId: context.read<CouponCubit>().couponcodeid,
                        totalAmount: (totalamount + findTotalChargeInRange(Preferences.remoteStore["delivery"], (discount).toInt())).toString(),
                        addressId: context.read<StoreAddressCubit>().data!.data![context.read<StoreAddressCubit>().selectStoreAddress!].id!,
                        products: products,
                        deliveryCharges: findTotalChargeInRange(Preferences.remoteStore["delivery"], discount.toInt()).toString(),
                      )
                          .then((value) async {
                        // print(value.toJson());
                        flutterToast(value.msg ?? "");
                        if (value.status!) {
                          try {
                            openCheckout(orderId: value.data?.orderId ?? "", paymentSessionId: value.data?.sessionId ?? "");
                          } catch (e) {
                            if (kDebugMode) {
                              print('Error: $e');
                            }
                          }
                        } else {
                          flutterToast(value.msg!);
                        }
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorResources.buttoncolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  Preferences.appString.makePayment ?? '   Make Payment ',
                  style: GoogleFonts.notoSansDevanagari(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget couponappllied({required couponname, required couponvalue}) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: ColorResources.buttoncolor.withValues(alpha: 0.15),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: ColorResources.buttoncolor,
              ),
              color: ColorResources.textWhite,
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 8,
                ),
                Icon(
                  Icons.local_offer_outlined,
                  color: ColorResources.buttoncolor,
                ),
                const Spacer(
                  flex: 1,
                ),
                Text(
                  couponname,
                  style: GoogleFonts.notoSansDevanagari(
                    fontSize: 12,
                    color: ColorResources.textblack,
                  ),
                ),
                const Spacer(
                  flex: 3,
                ),
                TextButton(
                  onPressed: () {
                    context.read<CouponCubit>().couponremove();
                  },
                  child: Text(
                    "Remove".toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
          // const SizedBox(
          //   height: 5,
          // ),
          // Text(
          //   "Available Coupon",
          //   style: GoogleFonts.notoSansDevanagari(
          //     fontSize: 12,
          //     fontWeight: FontWeight.bold,
          //     color: ColorResources.textBlackSec,
          //   ),
          // ),
        ],
      ),
    );
  }

  alladdress(
    BuildContext context,
  ) {
    analytics.logEvent(
      name: "app_all_address",
    );
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      isScrollControlled: true,
      builder: (context) => Scrollbar(
        thumbVisibility: true,
        child: Container(
          // height: MediaQuery.sizeOf(context).height * 0.6,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'All Address',
                style: TextStyle(
                  color: ColorResources.textblack,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Divider(),
              BlocBuilder<StoreAddressCubit, StoreAddressState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      ListView.separated(
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 5,
                        ),
                        shrinkWrap: true,
                        itemCount: context.read<StoreAddressCubit>().data!.data!.length,
                        itemBuilder: (context, index) => RadioListTile(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          value: index,
                          contentPadding: EdgeInsets.zero,
                          groupValue: context.read<StoreAddressCubit>().selectStoreAddress,
                          onChanged: (value) {
                            context.read<StoreAddressCubit>().selectAddress(id: index);
                          },
                          title: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              // SharedPreferenceHelper.getString(Preferences.name)!,
                                              context.read<StoreAddressCubit>().data!.data![index].name!,
                                              style: GoogleFonts.notoSansDevanagari(
                                                color: ColorResources.textblack,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                                letterSpacing: -0.48,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _countryController.text = context.read<StoreAddressCubit>().data!.data![index].country!;
                                              _nameController.text = context.read<StoreAddressCubit>().data!.data![index].name!;
                                              _pinCodeController.text = context.read<StoreAddressCubit>().data!.data![index].pinCode!;
                                              _LandMarkController.text = context.read<StoreAddressCubit>().data!.data![index].streetAddress!;
                                              _cityController.text = context.read<StoreAddressCubit>().data!.data![index].city!;
                                              _stateController.text = context.read<StoreAddressCubit>().data!.data![index].state!;
                                              _numberController.text = context.read<StoreAddressCubit>().data!.data![index].phone!;
                                              address(context, id: context.read<StoreAddressCubit>().data!.data![index].id);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 5,
                                                horizontal: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: ColorResources.buttoncolor,
                                                ),
                                                color: ColorResources.buttoncolor.withValues(alpha: 0.1),
                                              ),
                                              child: Text(
                                                Preferences.appString.edit ?? 'Edit',
                                                style: GoogleFonts.notoSansDevanagari(
                                                  color: ColorResources.buttoncolor,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        '${context.read<StoreAddressCubit>().data!.data![index].streetAddress!},${context.read<StoreAddressCubit>().data!.data![index].city ?? ""},${context.read<StoreAddressCubit>().data!.data![index].state ?? ""},${context.read<StoreAddressCubit>().data!.data![index].country ?? ""},${context.read<StoreAddressCubit>().data!.data![index].pinCode ?? ""}',
                                        style: GoogleFonts.notoSansDevanagari(
                                          color: ColorResources.textBlackSec,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                          letterSpacing: -0.40,
                                        ),
                                      ),
                                      // const SizedBox(
                                      //   height: 5,
                                      // ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '+91-${context.read<StoreAddressCubit>().data!.data![index].phone!}',
                                              style: GoogleFonts.notoSansDevanagari(
                                                color: ColorResources.textblack,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                                letterSpacing: -0.48,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              analytics.logEvent(name: "app_store_address_remove", parameters: {
                                                "id": context.read<StoreAddressCubit>().data?.data?[index].id ?? ""
                                              });
                                              context.read<StoreAddressCubit>().removefromStoreAddress(id: context.read<StoreAddressCubit>().data!.data![index].id);
                                            },
                                            child: const Text(
                                              'Remove',
                                              style: TextStyle(
                                                color: Color(0xFFEC3863),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                height: 0,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _AddressController.clear();
                        _LandMarkController.clear();
                        _cityController.clear();
                        _countryController.clear();
                        _nameController.clear();
                        _numberController.clear();
                        _pinCodeController.clear();
                        _stateController.clear();
                        address(context);
                      },
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          side: BorderSide(
                            color: ColorResources.buttoncolor,
                          )),
                      child: Text(
                        'Add Address',
                        style: TextStyle(
                          color: ColorResources.buttoncolor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Expanded(
                      flex: 5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorResources.buttoncolor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Delivery Here',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  address(BuildContext context, {String? id}) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                'Delivery Address',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansDevanagari(
                  color: ColorResources.textblack,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 0,
                  letterSpacing: -0.64,
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Name',
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: GoogleFonts.notoSansDevanagari(
                              color: const Color(0xFFFD0303),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      enableSuggestions: true,
                      autofillHints: const [
                        AutofillHints.name
                      ],
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Enter Name'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Mobile Number',
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: GoogleFonts.notoSansDevanagari(
                              color: const Color(0xFFFD0303),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _numberController,
                      maxLength: 10,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.phone,
                      enableSuggestions: true,
                      autofillHints: const [
                        AutofillHints.telephoneNumber
                      ],
                      decoration: InputDecoration(
                          counterText: "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Enter Mobile Number'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Pincode',
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: GoogleFonts.notoSansDevanagari(
                              color: const Color(0xFFFD0303),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _pinCodeController,
                      maxLength: 6,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      keyboardType: TextInputType.phone,
                      enableSuggestions: true,
                      autofillHints: const [
                        AutofillHints.postalAddressExtendedPostalCode
                      ],
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Pincode'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Text.rich(
                    //   TextSpan(
                    //     children: [
                    //       TextSpan(
                    //         text: 'Address',
                    //         style: GoogleFonts.notoSansDevanagari(
                    //           color: ColorResources.textblack,
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.w600,
                    //           height: 0,
                    //           letterSpacing: -0.24,
                    //         ),
                    //       ),
                    //       TextSpan(
                    //         text: '*',
                    //         style: GoogleFonts.notoSansDevanagari(
                    //           color: const Color(0xFFFD0303),
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.w600,
                    //           height: 0,
                    //           letterSpacing: -0.24,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // TextField(
                    //   controller: _AddressController,
                    //   decoration: InputDecoration(
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //       hintText: 'Address'),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Street',
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _LandMarkController,
                      keyboardType: TextInputType.streetAddress,
                      enableSuggestions: true,
                      autofillHints: const [
                        AutofillHints.fullStreetAddress
                      ],
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Street'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'City',
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: GoogleFonts.notoSansDevanagari(
                              color: const Color(0xFFFD0303),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _cityController,
                      enableSuggestions: true,
                      autofillHints: const [
                        AutofillHints.addressCity
                      ],
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'City'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'State',
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: GoogleFonts.notoSansDevanagari(
                              color: const Color(0xFFFD0303),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _stateController,
                      enableSuggestions: true,
                      autofillHints: const [
                        AutofillHints.addressState
                      ],
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'State'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'country',
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                          TextSpan(
                            text: '*',
                            style: GoogleFonts.notoSansDevanagari(
                              color: const Color(0xFFFD0303),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: _countryController,
                      enableSuggestions: true,
                      autofillHints: const [
                        AutofillHints.countryName
                      ],
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'country'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_nameController.text.isEmpty && _numberController.text.isEmpty && _LandMarkController.text.isEmpty && _cityController.text.isEmpty && _countryController.text.isEmpty && _stateController.text.isEmpty && _pinCodeController.text.isEmpty) {
                                flutterToast("Please enter All Fields");
                              } else {
                                Preferences.onLoading(context);
                                analytics.logEvent(name: "app_store_address_add", parameters: {
                                  "email": SharedPreferenceHelper.getString(Preferences.email)!,
                                  "name": _nameController.text,
                                  "phone": _numberController.text,
                                  "streetAddress": _LandMarkController.text,
                                  "city": _cityController.text,
                                  "country": _countryController.text,
                                  "state": _stateController.text,
                                  "pinCode": _pinCodeController.text,
                                });
                                context
                                    .read<StoreAddressCubit>()
                                    .updatefromStoreAddress(
                                      email: SharedPreferenceHelper.getString(Preferences.email)!,
                                      name: _nameController.text,
                                      phone: _numberController.text,
                                      streetAddress: _LandMarkController.text,
                                      city: _cityController.text,
                                      country: _countryController.text,
                                      state: _stateController.text,
                                      pinCode: _pinCodeController.text,
                                    )
                                    .then((value) {
                                  if (value) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  }
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorResources.buttoncolor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Save Address',
                              style: GoogleFonts.notoSansDevanagari(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<BaseModel> apppsymentverify({required String id}) async {
    return RemoteDataSourceImpl().postStoreVerificationRequest(id: id);
  }
}

class ProductData {
  final String id;
  final String name;
  final int quantity;
  final int amount;
  final int discount;
  final String image;
  ProductData({
    required this.id,
    required this.name,
    required this.quantity,
    required this.amount,
    required this.discount,
    required this.image,
  });
}
