import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/cubit/pincode/pincode_cubit.dart';
import 'package:sd_campus_app/features/cubit/streamselect/streamsetect_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/store/store_payment_screen.dart';
import 'package:sd_campus_app/view/screens/store/store_product_desc.dart';

class StoreProductCardWidget extends StatefulWidget {
  final String productName;
  final String productImage;
  final int productSalePrice;
  final int productRegularPrice;
  final String productRating;
  final String productId;
  final bool isWishlisted;
  final String productBadge;
  const StoreProductCardWidget({
    super.key,
    required this.productName,
    required this.productImage,
    required this.productSalePrice,
    required this.productRegularPrice,
    required this.productRating,
    required this.productId,
    required this.isWishlisted,
    required this.productBadge,
  });

  @override
  State<StoreProductCardWidget> createState() => _StoreProductCardWidgetState();
}

class _StoreProductCardWidgetState extends State<StoreProductCardWidget> {
  bool isWishlisted = false;
  @override
  void initState() {
    super.initState();
    isWishlisted = widget.isWishlisted;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(10),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => PincodeCubit(),
                  child: StroeProductDescScreen(
                    id: widget.productId,
                  ),
                ),
              )),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.productImage.isNotEmpty)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                          child: CachedNetworkImage(
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            imageUrl: widget.productImage,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          widget.productName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.notoSansDevanagari(
                            color: ColorResources.textblack,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '₹${widget.productSalePrice} ',
                                    style: GoogleFonts.notoSansDevanagari(
                                      color: ColorResources.textblack,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget.productRegularPrice != 0 ? '(${(((widget.productRegularPrice - widget.productSalePrice) / widget.productRegularPrice) * 100).ceil()}% OFF) \n' : "\n",
                                    style: const TextStyle(
                                      color: Color(0xFF1D7025),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                      letterSpacing: -0.32,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'M.R.P ',
                                    style: GoogleFonts.notoSansDevanagari(
                                      color: const Color(0xFFA6A6A6),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                      letterSpacing: -0.32,
                                    ),
                                  ),
                                  TextSpan(
                                    text: '₹${widget.productRegularPrice}',
                                    style: GoogleFonts.notoSansDevanagari(
                                      decoration: TextDecoration.lineThrough,
                                      color: const Color(0xFFA6A6A6),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                      letterSpacing: -0.32,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: ColorResources.buttoncolor.withValues(alpha: 0.8),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 10,
                                  color: ColorResources.textWhite,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  widget.productRating == "0.0" ? "5" : widget.productRating,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.notoSansDevanagari(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        side: BorderSide(
                                          color: ColorResources.buttoncolor,
                                        )),
                                    onPressed: () {
                                      Preferences.onLoading(context);
                                      RemoteDataSourceImpl().addtoStoreCartRequest(productId: widget.productId).then((value) {
                                        analytics.logAddToCart(
                                          items: [
                                            AnalyticsEventItem(
                                              itemId: widget.productId,
                                              itemName: widget.productName,
                                              quantity: 1,
                                              price: widget.productSalePrice,
                                            ),
                                          ],
                                        );
                                        Preferences.hideDialog(context);
                                        Navigator.of(context).popUntil((route) => route.settings.name == "store");
                                        context.read<StreamsetectCubit>().onItemTapped(1);
                                        // Navigator.of(context).push(MaterialPageRoute(
                                        //   builder: (context) => const StoreCartScreen(),
                                        // ));
                                      });
                                    },
                                    child: Text(
                                      "Add to cart".toUpperCase(),
                                      style: GoogleFonts.notoSansDevanagari(
                                        color: ColorResources.buttoncolor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        backgroundColor: ColorResources.buttoncolor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                      onPressed: () {
                                        analytics.logBeginCheckout(
                                          value: widget.productSalePrice.toDouble(),
                                          currency: "rupees",
                                          items: [
                                            AnalyticsEventItem(
                                              itemId: widget.productId,
                                              itemName: widget.productName,
                                              quantity: 1,
                                              price: widget.productSalePrice,
                                            ),
                                          ],
                                        );
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => StorePaymentScreen(
                                            productdata: [
                                              ProductData(
                                                amount: widget.productRegularPrice,
                                                name: widget.productName,
                                                quantity: 1,
                                                discount: widget.productSalePrice,
                                                image: widget.productImage,
                                                id: widget.productId,
                                              )
                                            ],
                                            amount: widget.productSalePrice,
                                          ),
                                        ));
                                      },
                                      child: Text(
                                        "Buy Now".toUpperCase(),
                                        style: GoogleFonts.notoSansDevanagari(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        RemoteDataSourceImpl().getWishlistRequest(productId: widget.productId).then((value) {
                          safeSetState(() {
                            isWishlisted = value.status ?? false ? !isWishlisted : isWishlisted;
                            analytics.logEvent(name: "app_Store_favorite", parameters: {
                              "id": widget.productId,
                              "title": widget.productName,
                            });
                          });
                        });
                      },
                      icon: Icon(
                        isWishlisted ? Icons.favorite : Icons.favorite_border_outlined,
                        color: isWishlisted ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(child: badgeForCard(type: widget.productBadge)),
      ],
    );
  }

  Widget badgeForCard({required String type}) {
    switch (type) {
      case "NEW ARRIVAL":
        return SvgPicture.network(SvgImages.newArrivalRibbon);
      case "PRICE DROP":
        return SvgPicture.network(SvgImages.priceDropRibbon);
      case "TOP TRENDING":
        return SvgPicture.network(SvgImages.trendingRibbon);
      case "BEST SELLER":
        return SvgPicture.network(SvgImages.bestSellingRibbon);
      case "FREEDOM SALE":
        return SvgPicture.network(SvgImages.freedomSaleRibbon);
      default:
        return Container();
    }
  }
}
