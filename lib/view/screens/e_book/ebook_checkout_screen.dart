import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
import 'package:sd_campus_app/features/data/remote/data_sources/auth/auth_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/base_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/view/screens/coupon_page.dart';
import 'package:sd_campus_app/view/screens/e_book/my_e_book/myebookscreen.dart';

class EbookCheckoutScreen extends StatefulWidget {
  final double salePrice;
  final double originalPrice;
  final String bookName;
  final String bookId;
  const EbookCheckoutScreen({
    super.key,
    required this.salePrice,
    required this.originalPrice,
    required this.bookName,
    required this.bookId,
  });

  @override
  State<EbookCheckoutScreen> createState() => _EbookCheckoutScreenState();
}

class _EbookCheckoutScreenState extends State<EbookCheckoutScreen> {
  double couponamount = 0;
//payment gateway
  var cfPaymentGatewayService = CFPaymentGatewayService();
  CFEnvironment environment = kDebugMode ? CFEnvironment.SANDBOX : CFEnvironment.PRODUCTION;
  final TextEditingController _emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    cfPaymentGatewayService.setCallback(
      verifyPayment,
      onError,
    );
  }

  Future<BaseModel> apppsymentverify({required String id}) async {
    return RemoteDataSourceImpl().postVerifyPaymentEbookRequest(
      orderId: id,
    );
  }

  void verifyPayment(String orderId) {
    apppsymentverify(id: orderId).then((value) {
      flutterToast(value.msg);
      if (value.status) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const MyEbookScreen(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Preferences.appString.checkout ?? 'Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.bookName * 100,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  Text(
                    '₹ ${widget.originalPrice.toInt()} ',
                    style: const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            widget.salePrice > 0
                ? BlocBuilder<CouponCubit, CouponState>(
                    builder: (context, state) {
                      // print(state);
                      if (state is CouponAddState) {
                        couponamount = 0;
                        if (state.coupontype == "fixed") {
                          couponamount = (widget.salePrice - state.value) > 1 ? state.value.toDouble() : 0;
                        } else {
                          couponamount = (widget.salePrice - (widget.salePrice / 100) * (state.value / 100)) > 1 ? (widget.salePrice * (state.value / 100)) : 0;
                          // couponamount = (int.parse(widget.course.charges) - ((int.parse(widget.course.charges) * (int.parse(widget.course.discount) / 100)))) * (state.value / 100);
                        }
                      } else {
                        couponamount = 0;
                      }
                      if (state is CouponAddState) {
                        return couponappllied(couponname: state.couponcode, couponvalue: couponamount.toStringAsFixed(2));
                      }
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => CouponScreen(
                                linkwith: widget.bookId,
                                link: "Book",
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorResources.textWhite,
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 0),
                                spreadRadius: 5,
                                blurRadius: 25,
                                color: ColorResources.gray.withValues(alpha: 0.2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Languages.applycoupon,
                                    style: GoogleFonts.notoSansDevanagari(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: ColorResources.textblack,
                                    ),
                                  ),
                                  Text(
                                    Languages.seeoffers,
                                    style: GoogleFonts.notoSansDevanagari(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: ColorResources.textblack.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.arrow_forward_ios)
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : Container(),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: ColorResources.textWhite),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Preferences.appString.paymentSummary ?? 'Payment Summery',
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            Preferences.appString.totalAmount ?? 'Total  Amount',
                            style: const TextStyle(
                              color: Color(0xBF333333),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          ),
                        ),
                        Text(
                          '₹${widget.originalPrice}',
                          style: const TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        )
                      ],
                    ),
                  ),
                  if ((widget.originalPrice - widget.salePrice) > 0)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              Preferences.appString.discount ?? 'Discount',
                              style: const TextStyle(
                                color: Color(0xBF333333),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                          ),
                          Text(
                            '-₹${widget.originalPrice - widget.salePrice}',
                            style: const TextStyle(
                              color: Color(0xFF1D7025),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 0,
                            ),
                          )
                        ],
                      ),
                    ),
                  BlocBuilder<CouponCubit, CouponState>(
                    builder: (context, state) {
                      if (state is CouponAddState) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  Preferences.appString.couponAmount ?? 'Coupon Amount',
                                  style: const TextStyle(
                                    color: Color(0xBF333333),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ),
                              Text(
                                '-₹${couponamount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Color(0xFF1D7025),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              )
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  const Divider(),
                  BlocBuilder<CouponCubit, CouponState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                Preferences.appString.payableAmount ?? 'Payable Amount',
                                style: TextStyle(
                                  color: ColorResources.textblack,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                            ),
                            Text(
                              '₹${widget.salePrice - couponamount}',
                              style: const TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            )
                          ],
                        ),
                      );
                    },
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
                            Icons.volunteer_activism_outlined,
                            size: 20,
                            color: ColorResources.buttoncolor,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            Preferences.appString.trustedByStudents ?? 'Trusted by students',
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
                            Icons.shield_outlined,
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
                                text: Preferences.appString.securePayment ?? 'Secure Payments\n',
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textblack,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                  letterSpacing: -0.40,
                                ),
                              ),
                              // TextSpan(
                              //   recognizer: TapGestureRecognizer()
                              //     ..onTap = () {
                              //       //https://store.sdcampus.com/return-refund-policy
                              //       launchUrl(Uri.parse("https://store.sdcampus.com/return-refund-policy"), mode: LaunchMode.externalApplication);
                              //     },
                              //   text: 'See More',
                              //   style: GoogleFonts.notoSansDevanagari(
                              //     color: ColorResources.buttoncolor,
                              //     fontSize: 10,
                              //     fontWeight: FontWeight.w400,
                              //     height: 0,
                              //     letterSpacing: -0.40,
                              //   ),
                              // ),
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
                            Icons.cast_for_education_rounded,
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
                                text: Preferences.appString.affordableEducation ?? 'Affordable Education\n',
                                style: GoogleFonts.notoSansDevanagari(
                                  color: ColorResources.textblack,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  height: 0,
                                  letterSpacing: -0.40,
                                ),
                              ),
                              // TextSpan(
                              //   recognizer: TapGestureRecognizer()
                              //     ..onTap = () {
                              //       launchUrl(Uri.parse("https://store.sdcampus.com/terms-and-conditions"), mode: LaunchMode.externalApplication);
                              //     },
                              //   text: 'See More',
                              //   style: GoogleFonts.notoSansDevanagari(
                              //     color: ColorResources.buttoncolor,
                              //     fontSize: 10,
                              //     fontWeight: FontWeight.w400,
                              //     height: 0,
                              //     letterSpacing: -0.40,
                              //   ),
                              // ),
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
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          width: double.infinity,
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: ColorResources.buttoncolor),
                  onPressed: () async {
                    if (SharedPreferenceHelper.getString(Preferences.email) == "N/A" && SharedPreferenceHelper.getString(Preferences.email)!.isEmpty) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Column(
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Please Add your Email',
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
                              controller: _emailController,
                              keyboardType: TextInputType.name,
                              enableSuggestions: true,
                              autofillHints: const [
                                AutofillHints.email
                              ],
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: 'Enter your Email.'),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_emailController.text == "" || _emailController.text == "N/A") {
                                  flutterToast("Please enter name");
                                } else {
                                  AuthDataSourceImpl().updateUserDetails(_emailController.text, SharedPreferenceHelper.getString(Preferences.email)!, SharedPreferenceHelper.getString(Preferences.address)!).then((value) {
                                    if (value.statusCode == 200) {
                                      SharedPreferenceHelper.setString(Preferences.email, _emailController.text);
                                      Navigator.of(context).pop();
                                    }
                                  });
                                }
                              },
                              child: const Text(
                                'Update',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      Preferences.onLoading(context);
                      RemoteDataSourceImpl()
                          .postCreateOrderEbookRequest(
                        ebookId: widget.bookId,
                        //  context.read<CouponCubit>().couponcodeid,
                        totalAmount: (widget.salePrice - couponamount).toString(),
                      )
                          .then((value) async {
                        Preferences.hideDialog(context);
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
                    //openCheckout(widget.course.batchDetails.id);
                    //checkOutButton(context);
                  },
                  child: Text(
                    Preferences.appString.proceedToPay ?? "Proceed to Pay",
                    //Languages.checkout,
                    style: GoogleFonts.notoSansDevanagari(
                      color: ColorResources.textWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget couponappllied({required String couponname, required String couponvalue}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: ColorResources.textWhite,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 0),
            spreadRadius: 5,
            blurRadius: 15,
            color: ColorResources.gray.withValues(alpha: 0.2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "‘$couponname’ ${Preferences.appString.applied ?? "Applied"}",
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 16,
                  color: ColorResources.textblack,
                ),
              ),
              Text(
                "₹$couponvalue ${Preferences.appString.couponSaving ?? "coupon saving"}",
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 16,
                  color: ColorResources.textblack,
                ),
              )
            ],
          ),
          TextButton(
            onPressed: () {
              context.read<CouponCubit>().couponremove();
            },
            child: Text(
              Languages.remove,
              style: GoogleFonts.notoSansDevanagari(
                fontSize: 18,
                color: ColorResources.buttoncolor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
