import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/cubit/streamselect/streamsetect_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/store_product_card.dart';
import 'package:sd_campus_app/features/presentation/widgets/wishlist_widgets.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
// import 'package:sd_campus_app/view/screens/store/store_cart.dart';

class StoreWishListScreen extends StatefulWidget {
  const StoreWishListScreen({super.key});

  @override
  State<StoreWishListScreen> createState() => _StoreWishListScreenState();
}

class _StoreWishListScreenState extends State<StoreWishListScreen> {

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: "app_store_wishlist",
      screenClass: "StoreWishListScreen",
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.textWhite,
          elevation: 0,
          iconTheme: IconThemeData(color: ColorResources.textblack),
          title: Text(
            'Wishlist',
            style: GoogleFonts.notoSansDevanagari(
              color: ColorResources.textblack,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.settings.name == "store");
                context.read<StreamsetectCubit>().onItemTapped(1);
                // Navigator.of(context).pushReplacement(MaterialPageRoute(
                //   builder: (context) => const StoreCartScreen(),
                // ));
              },
              icon: const Icon(Icons.local_mall_outlined),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  Preferences.appString.yourFavourited ?? 'Your Favourited',
                  style: GoogleFonts.notoSansDevanagari(
                    color: const Color(0xFF474747),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const WishListWidget(),
                const SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                    future: RemoteDataSourceImpl().getStoreRecommedRequest(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasData) {
                          return snapshot.data!.data!.isEmpty
                              ? Container()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      Preferences.appString.recommendProduct ?? 'Recommendations For you',
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
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ],
            ),
          ),
        ));
  }
}
