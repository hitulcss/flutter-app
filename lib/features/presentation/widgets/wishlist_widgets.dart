import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/cubit/streamselect/streamsetect_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/get_wishlist.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';

class WishListWidget extends StatefulWidget {
  const WishListWidget({super.key});

  @override
  State<WishListWidget> createState() => _WishListWidgetState();
}

class _WishListWidgetState extends State<WishListWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: RemoteDataSourceImpl().getWishlistRequest(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return snapshot.data?.data?.isEmpty ?? true
                  ? SizedBox(
                      height: 250,
                      child: EmptyWidget(image: SvgImages.emptyWishlist, text: "Empty Wishlist"),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.data?.length ?? 0,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => wishlistcard(
                        getWishlistItemsData: snapshot.data!.data![index],
                      ),
                    );
            } else {
              // print(snapshot.error);
              return ErrorWidgetapp(image: SvgImages.error404, text: "Page not found");
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget wishlistcard({required GetWishlistItemsData getWishlistItemsData}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: ColorResources.borderColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: CachedNetworkImage(
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              imageUrl: getWishlistItemsData.featuredImage ?? "",
              height: 100,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        getWishlistItemsData.title ?? "",
                        style: GoogleFonts.notoSansDevanagari(
                          color: ColorResources.textblack,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        RemoteDataSourceImpl().getWishlistRequest(productId: getWishlistItemsData.id).then((value) {
                          safeSetState(() {});
                        });
                      },
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            '₹${getWishlistItemsData.salePrice}',
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              height: 0,
                              letterSpacing: -0.40,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            '₹${getWishlistItemsData.regularPrice}',
                            style: GoogleFonts.notoSansDevanagari(
                              decoration: TextDecoration.lineThrough,
                              color: ColorResources.textBlackSec,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Preferences.onLoading(context);
                        RemoteDataSourceImpl().addtoStoreCartRequest(productId: getWishlistItemsData.id).then((value) {
                          Preferences.hideDialog(context);
                          flutterToast(value.msg!);
                          Navigator.of(context).popUntil((route) => route.settings.name == "store");
                          context.read<StreamsetectCubit>().onItemTapped(1);
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (context) => const StoreCartScreen(),
                          //   ),
                          // );
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(border: Border.all(color: ColorResources.buttoncolor, width: 2), color: ColorResources.buttoncolor.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            const Icon(Icons.local_mall_outlined),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Add to cart ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: ColorResources.textblack,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
