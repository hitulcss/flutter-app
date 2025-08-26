import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';
import 'package:sd_campus_app/features/cubit/coupon/coupon_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/get_coupon_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';

class CouponScreen extends StatefulWidget {
  final dynamic linkwith;
  final String link;
  final double amount;
  const CouponScreen({
    super.key,
    required this.linkwith,
    required this.link,
    this.amount = 0,
  });

  @override
  State<CouponScreen> createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  TextEditingController couponController = TextEditingController();

  FocusNode couponfocusnode = FocusNode();
  @override
  void initState() {
    super.initState();
    remoteConfig.fetchAndActivate();
  }

  @override
  void dispose() {
    couponfocusnode.dispose();
    couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: "app_store_coupon",
      screenClass: "CouponScreen",
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorResources.textWhite,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          'Coupons',
          style: GoogleFonts.notoSansDevanagari(
            color: ColorResources.textblack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: couponController,
              focusNode: couponfocusnode,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: Languages.couponcode,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: TextButton(
                  onPressed: () {
                    if (couponController.text.isEmpty) {
                      flutterToast('Enter coupan code');
                    } else {
                      Preferences.onLoading(context);
                      RemoteDataSourceImpl()
                          .verifyCouponrequest(
                        couponCode: couponController.text,
                        link: widget.link,
                        linkwith: widget.linkwith,
                      )
                          .then((value) {
                        Preferences.hideDialog(context);
                        if (value.data != null) {
                          context.read<CouponCubit>().couponadd(
                                couponcode: value.data!.couponCode!,
                                couponvalue: value.data!.couponValue!,
                                coupontype: value.data!.couponType!,
                                couponid: value.data!.id!,
                              );
                          flutterToast(value.msg!);
                          Navigator.of(context).pop();
                        } else {
                          flutterToast(value.msg!);
                        }
                      });
                      couponController.clear();
                      safeSetState(() {});
                    }
                  },
                  child: Text(
                    "Apply",
                    style: GoogleFonts.notoSansDevanagari(
                      color: ColorResources.textblack.withValues(alpha: 0.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<CouponGetModel>(
                future: RemoteDataSourceImpl().getcouponrequest(
                  link: widget.link,
                  linkwith: widget.linkwith,
                ),
                builder: (BuildContext context, AsyncSnapshot<CouponGetModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (widget.link == "product") {
                      snapshot.data?.data?.addAll(
                        getApplicableCoupons(
                              amount: widget.amount,
                              storeData: Preferences.remoteStore,
                            ) ??
                            [],
                      );
                    }
                    if (snapshot.hasData && (snapshot.data?.data?.isNotEmpty ?? false)) {
                      return couponbody(data: snapshot.data!.data!);
                    } else {
                      return Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.height * 0.3,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5.0,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const EmptyWidget(image: "https://static.vecteezy.com/system/resources/previews/002/205/938/non_2x/offer-tag-icon-free-vector.jpg", text: "No Coupons Available"),
                          ),
                        ),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget couponbody({required List<CouponGetModelData> data}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            Languages.availablecoupons,
            style: GoogleFonts.notoSansDevanagari(
              color: ColorResources.textblack,
              fontSize: 18,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return couponcard(carddata: data[index]);
          },
        ),
      ],
    );
  }

  Widget couponcard({required CouponGetModelData carddata}) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: ColorResources.buttoncolor.withValues(alpha: 0.2),
                  border: RDottedLineBorder.all(color: ColorResources.buttoncolor),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  carddata.couponCode!,
                  style: GoogleFonts.notoSansDevanagari(
                    color: ColorResources.buttoncolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<CouponCubit>().couponadd(
                        couponid: carddata.id!,
                        couponcode: carddata.couponCode!,
                        couponvalue: carddata.couponValue!,
                        coupontype: carddata.couponType!,
                      );
                  Navigator.of(context).pop();
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: ColorResources.buttoncolor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    Languages.apply,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSansDevanagari(
                      color: ColorResources.textWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                carddata.couponType == "fixed" ? "Flat ${carddata.couponValue}rs OFF" : "Flat ${carddata.couponValue}% OFF",
                style: GoogleFonts.notoSansDevanagari(
                  color: ColorResources.buttoncolor,
                  fontSize: 18,
                ),
              ),
              if (carddata.expirationDate != null)
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: Languages.expire,
                    style: GoogleFonts.notoSansDevanagari(
                      color: ColorResources.textblack,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  TextSpan(
                    text: "${carddata.expirationDate}",
                    style: GoogleFonts.notoSansDevanagari(
                      color: ColorResources.textblack,
                      fontSize: 14,
                    ),
                  )
                ])),
            ],
          ),
        ),
      ]),
    );
  }

  List<CouponGetModelData>? getApplicableCoupons({required double amount, required Map<String, dynamic> storeData}) {
    if (!storeData.containsKey('cartValueBaseCoupons')) {
      return null; // Handle missing 'store' key
    }

    final storeList = storeData['cartValueBaseCoupons'] as List<dynamic>;
    for (final store in storeList) {
      if (store is! Map<String, dynamic>) {
        continue; // Skip non-map elements in the list
      }

      final rangeString = store['range'] as String;
      final ranges = rangeString.split('-');
      if (ranges.length != 2) {
        continue; // Skip invalid range format
      }

      final min = double.tryParse(ranges[0]);
      final max = double.tryParse(ranges[1]);
      if (min == null || max == null) {
        continue; // Skip invalid range values
      }

      if (amount >= min && amount <= max) {
        List<CouponGetModelData> coupons = [];
        var data = store['coupons'] as List<dynamic>;
        for (var e in data) {
          coupons.add(CouponGetModelData.fromJson(e));
        }
        return coupons;
      }
    }

    return null; // No applicable coupons found
  }
}
