import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sd_campus_app/features/cubit/coupon/coupon_cubit.dart';
import 'package:sd_campus_app/features/cubit/pincode/pincode_cubit.dart';
import 'package:sd_campus_app/features/cubit/streamselect/streamsetect_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/get_product_by_id.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/imagesliderpreivewWidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/store_product_card.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/store/store_payment_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class StroeProductDescScreen extends StatefulWidget {
  final String id;
  const StroeProductDescScreen({super.key, required this.id});

  @override
  State<StroeProductDescScreen> createState() => _StroeProductDescScreenState();
}

class _StroeProductDescScreenState extends State<StroeProductDescScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _pincodeController = TextEditingController();

  @override
  void initState() {
    analytics.logEvent(
      name: "app_store_prod_desc",
      parameters: {
        "id": widget.id,
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetProductById>(
        future: RemoteDataSourceImpl().getProductDetialsByIdRequest(id: widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              int totalrattingcount = (snapshot.data!.data!.ratingCounts!.i5! + snapshot.data!.data!.ratingCounts!.i4! + snapshot.data!.data!.ratingCounts!.i3! + snapshot.data!.data!.ratingCounts!.i2! + snapshot.data!.data!.ratingCounts!.i1!) > 0 ? (snapshot.data!.data!.ratingCounts!.i5! + snapshot.data!.data!.ratingCounts!.i4! + snapshot.data!.data!.ratingCounts!.i3! + snapshot.data!.data!.ratingCounts!.i2! + snapshot.data!.data!.ratingCounts!.i1!) : 1;
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: ColorResources.textWhite,
                  elevation: 0,
                  iconTheme: IconThemeData(color: ColorResources.textblack),
                  title: Text(
                    snapshot.data!.data!.title!,
                    style: GoogleFonts.notoSansDevanagari(
                      color: ColorResources.textblack,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        RemoteDataSourceImpl()
                            .getWishlistRequest(
                          productId: snapshot.data!.data!.id,
                        )
                            .then((value) {
                          safeSetState(() {
                            analytics.logEvent(
                              name: "app_Store_favorite",
                              parameters: {
                                "id": snapshot.data?.data?.id ?? "",
                                "title": snapshot.data?.data?.title ?? "",
                              },
                            );
                          });
                        });
                        // Navigator.of(context).push(MaterialPageRoute(
                        //   builder: (context) => StoreWishListScreen(),
                        // ));
                      },
                      icon: Icon(
                        snapshot.data!.data!.isWishList! ? Icons.favorite : Icons.favorite_border_outlined,
                        color: snapshot.data!.data!.isWishList! ? Colors.red : Colors.black,
                      ),
                    ),
                    if (snapshot.data?.data?.shareUrl?.link != null && (snapshot.data?.data?.shareUrl?.link?.isNotEmpty ?? false))
                      IconButton(
                        onPressed: () {
                          Share.share("${snapshot.data!.data!.shareUrl?.text ?? ""}\n${snapshot.data!.data!.shareUrl?.link ?? ""}");
                        },
                        icon: const Icon(
                          Icons.share,
                        ),
                      ),
                    // IconButton(
                    //   padding: EdgeInsets.zero,
                    //   onPressed: () {
                    //     Share.share('${snapshot.data!.data!.title}');
                    //   },
                    //   icon: const CircleAvatar(
                    //     radius: 20,
                    //     backgroundColor: Color(0x3FF4B44B),
                    //     child: Icon(Icons.share),
                    //   ),
                    // ),
                  ],
                ),
                body: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          ImageSlidePreviewWidget(
                            images: snapshot.data!.data!.images!,
                            isImageindex: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            snapshot.data!.data!.title!,
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'By: ',
                                  style: TextStyle(
                                    color: ColorResources.textblack,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                TextSpan(
                                  text: 'SD Publication',
                                  style: TextStyle(
                                    color: ColorResources.textBlackSec,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Text(
                          //   'By Sd Pudlication',
                          //   textAlign: TextAlign.center,
                          //   style: GoogleFonts.notoSansDevanagari(
                          //     color: const ColorResources.textBlackSec,
                          //     fontSize: 10,
                          //     fontWeight: FontWeight.w500,
                          //     height: 0,
                          //     letterSpacing: -0.40,
                          //   ),
                          // ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: ColorResources.buttoncolor,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      snapshot.data!.data!.averageRating == "0.0" ? "5.0" : snapshot.data!.data!.averageRating!,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.notoSansDevanagari(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                        letterSpacing: -0.32,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: ColorResources.buttoncolor,
                                    )),
                                child: Text(
                                  snapshot.data?.data?.code ?? "",
                                  style: TextStyle(
                                    color: ColorResources.buttoncolor,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                      color: ColorResources.buttoncolor,
                                    )),
                                child: Text(
                                  snapshot.data?.data?.badge ?? "",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorResources.buttoncolor,
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '₹${snapshot.data!.data!.salePrice}  ',
                                            style: GoogleFonts.notoSansDevanagari(
                                              color: ColorResources.textblack,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '₹${snapshot.data!.data!.regularPrice}\n',
                                            style: GoogleFonts.notoSansDevanagari(
                                              decoration: TextDecoration.lineThrough,
                                              color: const Color(0xFFA6A6A6),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          TextSpan(
                                            text: snapshot.data!.data!.regularPrice != "0" && snapshot.data!.data!.regularPrice != null ? '  (${(((int.parse(snapshot.data!.data!.regularPrice!) - int.parse(snapshot.data!.data!.salePrice!)) / int.parse(snapshot.data!.data!.regularPrice!)) * 100).ceil()}% OFF)  ' : " ",
                                            style: const TextStyle(
                                              color: Color(0xFF1D7025),
                                              fontSize: 10,
                                              height: 2.5,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      int.parse(snapshot.data?.data?.inStock ?? "0") > 0 ? "In Stock" : "Out of Stock",
                                      style: TextStyle(
                                        color: int.parse(snapshot.data?.data?.inStock ?? "0") > 0 ? const Color(0xFF1D7025) : Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 8.0,
                                    top: 8.0,
                                    bottom: 0,
                                  ),
                                  child: Text(
                                    snapshot.data!.data!.deliveryType!.isNotEmpty ? Preferences.appString.checkDelivery ?? 'Check Delivery: ' : "",
                                    style: GoogleFonts.notoSansDevanagari(
                                      color: ColorResources.textblack,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    ),
                                  ),
                                ),
                                const Divider(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TextField(
                                        controller: _pincodeController,
                                        keyboardType: TextInputType.number,
                                        maxLength: 6,
                                        decoration: InputDecoration(
                                          counterText: "",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                          prefixIcon: const Icon(Icons.location_on_outlined),
                                          hintText: Preferences.appString.enterPincode ?? 'Enter Pincode',
                                          suffixIcon: TextButton(
                                            onPressed: () {
                                              context.read<PincodeCubit>().pincodecheck(value: _pincodeController.text);
                                              FocusScope.of(context).unfocus();
                                            },
                                            child: Text(
                                              'Check',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.notoSansDevanagari(
                                                color: ColorResources.buttoncolor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                height: 0,
                                                letterSpacing: -0.40,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      BlocBuilder<PincodeCubit, PincodeState>(
                                        builder: (context, state) {
                                          if (state is PincodeCheck) {
                                            return const Center(
                                              child: LinearProgressIndicator(),
                                            );
                                          } else if (state is PincodeEmpty) {
                                            return Text(
                                              Preferences.appString.enterPincode ?? 'Please enter Pincode',
                                              style: GoogleFonts.notoSansDevanagari(
                                                color: ColorResources.textblack,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            );
                                          } else if (state is PincodeFound) {
                                            return Text.rich(
                                              TextSpan(
                                                children: [
                                                  const TextSpan(
                                                    text: 'Delivery Available | ',
                                                    style: TextStyle(
                                                      color: Color(0xFF1D7025),
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: 'By ${DateFormat("EEEE, dd MMMM").format(DateTime.now().add(const Duration(days: 3))).toString()} ',
                                                    style: TextStyle(
                                                      color: ColorResources.textblack,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else if (state is PincodeNotFound) {
                                            return Text(
                                              Preferences.appString.noDelivery ?? 'Sorry, currently could not deliver in your area. Try another pincode.',
                                              style: GoogleFonts.notoSansDevanagari(
                                                color: Colors.red[400],
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            );
                                          }
                                          return Container();
                                        },
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text.rich(
                                        TextSpan(
                                          children: [
                                            const TextSpan(
                                              text: 'Free Delivery | ',
                                              style: TextStyle(
                                                color: Color(0xFF1D7025),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            TextSpan(
                                              text: 'On Only Prepaid Order ',
                                              style: TextStyle(
                                                color: ColorResources.textblack,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (snapshot.data?.data?.offers?.isNotEmpty ?? false)
                            Theme(
                              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                collapsedBackgroundColor: Colors.white,
                                backgroundColor: Colors.white,
                                initiallyExpanded: true,
                                leading: CachedNetworkImage(imageUrl: "https://static.vecteezy.com/system/resources/previews/002/205/938/non_2x/offer-tag-icon-free-vector.jpg"),
                                title: Text(
                                  Preferences.appString.activeOffers ?? "Active Offers",
                                  style: const TextStyle(
                                    color: Color(0xFF333333),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                children: [
                                  const Divider(),
                                  SizedBox(
                                    height: 100,
                                    child: ListView.separated(
                                        padding: const EdgeInsets.all(8.0),
                                        separatorBuilder: (context, index) => const SizedBox(
                                              width: 10,
                                            ),
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: snapshot.data?.data?.offers?.length ?? 0,
                                        itemBuilder: (context, index) => Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: ColorResources.borderColor,
                                                ),
                                                color: Colors.white,
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    'Get Extra ${snapshot.data?.data?.offers?[index].couponType == "percentage" ? "${snapshot.data?.data?.offers?[index].couponValue ?? 0}%" : "₹ ${snapshot.data?.data?.offers?[index].couponValue ?? 0} rs"} OFF',
                                                    style: TextStyle(
                                                      color: ColorResources.textBlackSec,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                  Text(
                                                    snapshot.data?.data?.offers?[index].couponCode ?? "",
                                                    style: TextStyle(
                                                      color: ColorResources.textblack,
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w600,
                                                      height: 0,
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Preferences.onLoading(context);
                                                      RemoteDataSourceImpl().verifyCouponrequest(
                                                        couponCode: snapshot.data?.data?.offers?[index].couponCode ?? "",
                                                        link: "product",
                                                        linkwith: [
                                                          snapshot.data?.data?.id
                                                        ],
                                                      ).then((value) {
                                                        // Future.delayed(Duration(seconds: 2), () {
                                                        context.read<CouponCubit>().couponadd(
                                                              couponcode: value.data?.couponCode ?? "",
                                                              couponvalue: value.data?.couponValue ?? 0,
                                                              coupontype: value.data?.couponType ?? "",
                                                              couponid: value.data?.id ?? "",
                                                            );
                                                        // });
                                                        Preferences.hideDialog(context);
                                                        Navigator.of(context).push(MaterialPageRoute(
                                                          builder: (context) => StorePaymentScreen(
                                                            productdata: [
                                                              ProductData(
                                                                amount: int.parse(snapshot.data!.data!.regularPrice!),
                                                                name: snapshot.data!.data!.title!,
                                                                quantity: 1,
                                                                discount: int.parse(snapshot.data!.data!.salePrice!),
                                                                image: snapshot.data!.data!.featuredImage!,
                                                                id: snapshot.data!.data!.id!,
                                                              )
                                                            ],
                                                            amount: int.parse(snapshot.data!.data!.salePrice!),
                                                            isCouponapplied: true,
                                                          ),
                                                        ));
                                                      });
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Apply Code',
                                                          style: TextStyle(
                                                            color: ColorResources.buttoncolor,
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w500,
                                                            height: 0,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Icon(
                                                          Icons.input,
                                                          color: ColorResources.buttoncolor,
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )),
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(
                            height: 5,
                          ),
                          DefaultTabController(
                            length: 2,
                            child: Container(
                              constraints: const BoxConstraints(maxHeight: 340),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: ColorResources.borderColor,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(children: [
                                Container(
                                  constraints: const BoxConstraints.expand(height: 50),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                    color: Colors.white,
                                  ),
                                  child: TabBar(
                                    indicatorColor: ColorResources.buttoncolor,
                                    labelColor: ColorResources.buttoncolor,
                                    unselectedLabelColor: ColorResources.textblack.withValues(alpha: 0.6),
                                    labelStyle: GoogleFonts.notoSansDevanagari(
                                      fontSize: 16,
                                      letterSpacing: -0.64,
                                      height: 0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    tabs: [
                                      Tab(
                                        text: Preferences.appString.description ?? 'Description',
                                      ),
                                      Tab(
                                        text: Preferences.appString.reviews ?? 'Reviews',
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: TabBarView(
                                    physics: const NeverScrollableScrollPhysics(),
                                    children: [
                                      Scrollbar(
                                        child: Container(
                                          padding: const EdgeInsets.all(8.0),
                                          color: Colors.white,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Html(
                                                  data: snapshot.data!.data!.desc!,
                                                  onAnchorTap: (url, attributes, element) {
                                                    Uri openurl = Uri.parse(url!);
                                                    launchUrl(
                                                      openurl,
                                                    );
                                                  },
                                                  // style: GoogleFonts.notoSansDevanagari(
                                                  //   color: Colors.black,
                                                  //   fontSize: 10,
                                                  //   fontWeight: FontWeight.w400,
                                                  // ),
                                                ),
                                                Text(
                                                  '\nBook Details',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.notoSansDevanagari(
                                                    color: ColorResources.textblack,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    height: 0,
                                                    letterSpacing: -0.48,
                                                  ),
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: '\nPublisher: ',
                                                        style: GoogleFonts.notoSansDevanagari(
                                                          color: ColorResources.textblack,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w600,
                                                          height: 0,
                                                          letterSpacing: -0.40,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: 'Sd Publication Pvt. Ltd',
                                                        style: GoogleFonts.notoSansDevanagari(
                                                          color: ColorResources.textBlackSec,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: '\nPublisher Year: ',
                                                        style: GoogleFonts.notoSansDevanagari(
                                                          color: ColorResources.textblack,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '2023',
                                                        style: GoogleFonts.notoSansDevanagari(
                                                          color: ColorResources.textBlackSec,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: '\nNo. of Books:  ',
                                                        style: GoogleFonts.notoSansDevanagari(
                                                          color: ColorResources.textblack,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w600,
                                                          height: 0,
                                                          letterSpacing: -0.40,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: snapshot.data!.data!.maxPurchaseQty,
                                                        style: GoogleFonts.notoSansDevanagari(
                                                          color: ColorResources.textBlackSec,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w400,
                                                          height: 0,
                                                          letterSpacing: -0.40,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: '\nLanguage : ',
                                                        style: GoogleFonts.notoSansDevanagari(
                                                          color: ColorResources.textblack,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: snapshot.data!.data!.language,
                                                        style: GoogleFonts.notoSansDevanagari(
                                                          color: ColorResources.textBlackSec,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        color: Colors.white,
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            IntrinsicHeight(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Text(
                                                                  snapshot.data!.data!.averageRating!,
                                                                  textAlign: TextAlign.center,
                                                                  style: GoogleFonts.notoSansDevanagari(
                                                                    color: ColorResources.textblack,
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons.star,
                                                                  color: ColorResources.buttoncolor,
                                                                )
                                                              ],
                                                            ),
                                                            Text(
                                                              '${snapshot.data!.data!.ratingCounts!.i1! + snapshot.data!.data!.ratingCounts!.i2! + snapshot.data!.data!.ratingCounts!.i3! + snapshot.data!.data!.ratingCounts!.i4! + snapshot.data!.data!.ratingCounts!.i5!} ratings and ${snapshot.data!.data!.reviews!.length} reviews',
                                                              textAlign: TextAlign.center,
                                                              style: GoogleFonts.notoSansDevanagari(
                                                                color: ColorResources.textblack,
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const VerticalDivider(),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(right: 8.0),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '5',
                                                                textAlign: TextAlign.center,
                                                                style: GoogleFonts.notoSansDevanagari(
                                                                  color: ColorResources.textblack,
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w600,
                                                                  height: 0,
                                                                  letterSpacing: -0.60,
                                                                ),
                                                              ),
                                                              const Icon(Icons.star),
                                                              Expanded(
                                                                child: LinearProgressIndicator(
                                                                  value: ((snapshot.data!.data!.ratingCounts!.i5! / totalrattingcount) * 100) / 100,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                snapshot.data!.data!.ratingCounts!.i5!.toString(),
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
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '4',
                                                                textAlign: TextAlign.center,
                                                                style: GoogleFonts.notoSansDevanagari(
                                                                  color: ColorResources.textblack,
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w600,
                                                                  height: 0,
                                                                  letterSpacing: -0.60,
                                                                ),
                                                              ),
                                                              const Icon(Icons.star),
                                                              Expanded(
                                                                child: LinearProgressIndicator(
                                                                  value: ((snapshot.data!.data!.ratingCounts!.i4! / totalrattingcount) * 100) / 100,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                snapshot.data!.data!.ratingCounts!.i4!.toString(),
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
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '3',
                                                                textAlign: TextAlign.center,
                                                                style: GoogleFonts.notoSansDevanagari(
                                                                  color: ColorResources.textblack,
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w600,
                                                                  height: 0,
                                                                  letterSpacing: -0.60,
                                                                ),
                                                              ),
                                                              const Icon(Icons.star),
                                                              Expanded(
                                                                child: LinearProgressIndicator(
                                                                  value: ((snapshot.data!.data!.ratingCounts!.i3! / totalrattingcount) * 100) / 100,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                snapshot.data!.data!.ratingCounts!.i3!.toString(),
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
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '2',
                                                                textAlign: TextAlign.center,
                                                                style: GoogleFonts.notoSansDevanagari(
                                                                  color: ColorResources.textblack,
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w600,
                                                                  height: 0,
                                                                  letterSpacing: -0.60,
                                                                ),
                                                              ),
                                                              const Icon(Icons.star),
                                                              Expanded(
                                                                child: LinearProgressIndicator(
                                                                  value: ((snapshot.data!.data!.ratingCounts!.i2! / totalrattingcount) * 100) / 100,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                snapshot.data!.data!.ratingCounts!.i2!.toString(),
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
                                                          Row(
                                                            children: [
                                                              Text(
                                                                '1',
                                                                textAlign: TextAlign.center,
                                                                style: GoogleFonts.notoSansDevanagari(
                                                                  color: ColorResources.textblack,
                                                                  fontSize: 15,
                                                                  fontWeight: FontWeight.w600,
                                                                  height: 0,
                                                                  letterSpacing: -0.60,
                                                                ),
                                                              ),
                                                              const Icon(Icons.star),
                                                              Expanded(
                                                                child: LinearProgressIndicator(
                                                                  value: ((snapshot.data!.data!.ratingCounts!.i1! / totalrattingcount) * 100) / 100,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                snapshot.data!.data!.ratingCounts!.i1!.toString(),
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
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Divider(),
                                            Expanded(
                                              child: Scrollbar(
                                                // thumbVisibility: true,
                                                child: ListView.separated(
                                                  shrinkWrap: true,
                                                  itemCount: snapshot.data!.data!.reviews!.length,
                                                  itemBuilder: (context, index) => Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Container(
                                                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                                                              decoration: BoxDecoration(
                                                                color: ColorResources.buttoncolor,
                                                                borderRadius: BorderRadius.circular(5),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  const Icon(
                                                                    Icons.star,
                                                                    color: Colors.white,
                                                                    size: 12,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    snapshot.data!.data!.reviews![index].rating!,
                                                                    textAlign: TextAlign.center,
                                                                    style: GoogleFonts.notoSansDevanagari(
                                                                      color: Colors.white,
                                                                      fontSize: 10,
                                                                      fontWeight: FontWeight.w400,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 5,
                                                            ),
                                                            Text(
                                                              snapshot.data!.data!.reviews![index].title!,
                                                              textAlign: TextAlign.center,
                                                              style: GoogleFonts.notoSansDevanagari(
                                                                color: ColorResources.textblack,
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          snapshot.data!.data!.reviews![index].description!,
                                                          style: GoogleFonts.notoSansDevanagari(
                                                            color: ColorResources.textBlackSec,
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.w500,
                                                            height: 0,
                                                            letterSpacing: -0.40,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  separatorBuilder: (context, index) => const Divider(),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                                  child: Text(
                                    Preferences.appString.frequentlyAskedQuestions ?? 'Frequesntly Asked Questions',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.notoSansDevanagari(
                                      color: ColorResources.textblack,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const Divider(),
                                ListView.separated(
                                  separatorBuilder: (context, index) => const Divider(),
                                  itemCount: Preferences.appString.storeFaqs?.length ?? 0,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => CustomExpansionTile(
                                    title: Preferences.appString.storeFaqs?[index].q ?? "",
                                    openIcon: Icons.remove,
                                    closeIcon: Icons.add,
                                    body: [
                                      const Divider(),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(Preferences.appString.storeFaqs?[index].a ?? ""),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FutureBuilder(
                              future: RemoteDataSourceImpl().getStoreSimilarRequest(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  if (snapshot.hasData) {
                                    return snapshot.data!.data!.isEmpty
                                        ? Container()
                                        : Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                Preferences.appString.similarProducts ?? 'Similar Books  ',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.notoSansDevanagari(
                                                  color: ColorResources.textblack,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              AlignedGridView.count(
                                                itemCount: snapshot.data!.data!.length,
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 10,
                                                crossAxisSpacing: 10,
                                                // childAspectRatio: 0.9,
                                                // ),
                                                itemBuilder: (context, index) => StoreProductCardWidget(
                                                  productName: snapshot.data!.data![index].title ?? "",
                                                  productImage: snapshot.data!.data![index].featuredImage ?? "",
                                                  productSalePrice: int.parse(snapshot.data!.data![index].salePrice ?? "0"),
                                                  productRegularPrice: int.parse(snapshot.data!.data![index].regularPrice ?? "0"),
                                                  productRating: snapshot.data!.data![index].averageRating ?? "0",
                                                  productId: snapshot.data!.data![index].id ?? "",
                                                  isWishlisted: snapshot.data!.data![index].isWishList ?? false,
                                                  productBadge: snapshot.data!.data![index].badge ?? "",
                                                ),
                                              ),
                                            ],
                                          );
                                  } else {
                                    return ErrorWidgetapp(image: SvgImages.error404, text: "Page not found");
                                  }
                                } else {
                                  return Center(
                                    child: Container(),
                                    // CircularProgressIndicator(),
                                  );
                                }
                              }),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: BottomAppBar(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              side: BorderSide(
                                style: BorderStyle.solid,
                                color: ColorResources.buttoncolor,
                              ),
                            ),
                            onPressed: () {
                              analytics.logAddToCart(
                                items: [
                                  AnalyticsEventItem(
                                    itemId: snapshot.data!.data!.id,
                                    itemName: snapshot.data!.data!.title,
                                    quantity: 1,
                                    price: int.parse(snapshot.data!.data!.salePrice!),
                                  ),
                                ],
                              );
                              Preferences.onLoading(context);
                              RemoteDataSourceImpl().addtoStoreCartRequest(productId: snapshot.data!.data!.id, productQty: 1).then((value) {
                                Preferences.hideDialog(context);
                                Navigator.of(context).popUntil((route) => route.settings.name == "store");
                                context.read<StreamsetectCubit>().onItemTapped(1);
                                // Navigator.of(context).push(MaterialPageRoute(
                                //   builder: (context) => const StoreCartScreen(),
                                // ));
                              });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.local_mall_outlined,
                                  size: 18,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  ' Add To Cart',
                                  style: GoogleFonts.notoSansDevanagari(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorResources.buttoncolor.withValues(alpha: 0.75),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              analytics.logBeginCheckout(
                                value: double.parse(snapshot.data!.data!.salePrice!),
                                currency: "rupees",
                                items: [
                                  AnalyticsEventItem(
                                    itemId: snapshot.data!.data!.id,
                                    itemName: snapshot.data!.data!.title,
                                    quantity: 1,
                                    price: int.parse(snapshot.data!.data!.salePrice!),
                                  ),
                                ],
                              );
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => StorePaymentScreen(
                                  productdata: [
                                    ProductData(
                                      amount: int.parse(snapshot.data!.data!.regularPrice!),
                                      name: snapshot.data!.data!.title!,
                                      quantity: 1,
                                      discount: int.parse(snapshot.data!.data!.salePrice!),
                                      image: snapshot.data!.data!.featuredImage!,
                                      id: snapshot.data!.data!.id!,
                                    )
                                  ],
                                  amount: int.parse(snapshot.data!.data!.salePrice!),
                                ),
                              ));
                            },
                            child: Text(
                              'Buy Now',
                              style: GoogleFonts.notoSansDevanagari(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return ErrorWidgetapp(image: SvgImages.error404, text: "Page not found");
            }
          } else {
            return const Scaffold(
                body: SafeArea(
                    child: Center(
              child: CircularProgressIndicator(),
            )));
          }
        });
  }
}
