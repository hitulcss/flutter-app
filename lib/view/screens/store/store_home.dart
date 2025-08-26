import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marqueer/marqueer.dart';
import 'package:sd_campus_app/features/cubit/pincode/pincode_cubit.dart';
import 'package:sd_campus_app/features/cubit/streamselect/streamsetect_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/get_marketing_category.dart';
import 'package:sd_campus_app/features/data/remote/models/get_store_alert.dart';
import 'package:sd_campus_app/features/data/remote/models/getstorecategory.dart';
import 'package:sd_campus_app/features/data/remote/models/store_banner.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/search_product.dart';
import 'package:sd_campus_app/features/presentation/widgets/store_product_card.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/store/sale_discount.dart';
import 'package:sd_campus_app/view/screens/store/store_address.dart';
import 'package:sd_campus_app/view/screens/store/store_cart.dart';
import 'package:sd_campus_app/view/screens/store/store_category.dart';
import 'package:sd_campus_app/view/screens/store/store_catg_list.dart';
import 'package:sd_campus_app/view/screens/store/store_new_arrivals.dart';
import 'package:sd_campus_app/view/screens/store/store_order.dart';
import 'package:sd_campus_app/view/screens/store/store_product_desc.dart';
import 'package:sd_campus_app/view/screens/store/store_wishlist.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreHomeScreen extends StatefulWidget {
  const StoreHomeScreen({super.key});

  @override
  State<StoreHomeScreen> createState() => _StoreHomeScreenState();
}

class _StoreHomeScreenState extends State<StoreHomeScreen> {
  @override
  initState() {
    super.initState();
  }

  Future<bool> _onbackpress(BuildContext context) async {
    bool? exitApp = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    Preferences.appString.exitStoreConfirmation ?? "Are you sure you want to exit from the SD Store?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSansDevanagari(
                      color: ColorResources.textblack,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            side: BorderSide(
                              width: 2,
                              color: ColorResources.textblack.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              Languages.no,
                              style: GoogleFonts.notoSansDevanagari(
                                color: ColorResources.textblack,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorResources.buttoncolor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              Languages.yes,
                              style: GoogleFonts.notoSansDevanagari(
                                color: ColorResources.textWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ));
      },
    );
    if (exitApp ?? false) {
      context.read<StreamsetectCubit>().onItemTapped(0);
    }
    return exitApp ?? false;
  }

  Future<StoreCatAndBanner> getapidata() async {
    GetStoreCategory getStoreCategory = await RemoteDataSourceImpl().getStoreCAtegoryRequest();
    GetStoreBanner getStoreBanner = await RemoteDataSourceImpl().getStoreBannerRequest();
    GetMarketingCategory getpoplularproductlist = await RemoteDataSourceImpl().getsgetMarketingCategoryRequest(category: "POPULAR", limit: 4, page: 1);
    GetMarketingCategory getbookproductlist = await RemoteDataSourceImpl().getsgetMarketingCategoryRequest(category: "BOOK", limit: 4, page: 1);
    // GetMarketingCategory getsaproductlist = await RemoteDataSourceImpl().getsgetMarketingCategoryRequest(category: "SA", limit: 4);
    GetMarketingCategory gethdpproductlist = await RemoteDataSourceImpl().getsgetMarketingCategoryRequest(category: "HDP", limit: 4, page: 1);
    GetMarketingCategory gethdcproductlist = await RemoteDataSourceImpl().getsgetMarketingCategoryRequest(category: "HDC", limit: 4, page: 1);
    GetStoreAlert getStoreAlert = await RemoteDataSourceImpl().getStoreAlertRequest();
    return StoreCatAndBanner(
      getStoreBanner: getStoreBanner,
      getStoreCategory: getStoreCategory,
      getStoreAlert: getStoreAlert,
      getpoplularproductlist: getpoplularproductlist,
      getbookproductlist: getbookproductlist,
      // getsaproductlist: getsaproductlist,
      gethdcproductlist: gethdcproductlist,
      gethdpproductlist: gethdpproductlist,
    );
  }

  @override
  Widget build(BuildContext context) {
    analytics.logScreenView(
      screenName: "app_store_screen",
    );

    return Scaffold(
        extendBody: true,
        body: WillPopScope(
          onWillPop: () => _onbackpress(context),
          child: FutureBuilder<StoreCatAndBanner>(
              future: getapidata(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Scaffold(
                      body: SafeArea(
                        child: Column(children: [
                          snapshot.data?.getStoreAlert.data!.isNotEmpty ?? false
                              ? Container(
                                  height: 30,
                                  color: ColorResources.buttoncolor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Marqueer(
                                              child: ListView.builder(
                                                  itemCount: snapshot.data?.getStoreAlert.data!.length,
                                                  shrinkWrap: true,
                                                  scrollDirection: Axis.horizontal,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  itemBuilder: (context, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        analytics.logEvent(
                                                          name: "app_store_marquee_click",
                                                          parameters: {
                                                            "link": snapshot.data?.getStoreAlert.data?[index].link ?? "",
                                                            "id": snapshot.data?.getStoreAlert.data?[index].id ?? "",
                                                          },
                                                        );
                                                        if (snapshot.data?.getStoreAlert.data![index].link == 'category') {
                                                          Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) => StoreCategoryScreen(
                                                              future: RemoteDataSourceImpl().getProductListRequest(
                                                                category: snapshot.data?.getStoreAlert.data![index].linkWith!.id,
                                                              ),
                                                              productType: snapshot.data?.getStoreAlert.data![index].linkWith!.title ?? "",
                                                            ),
                                                          ));
                                                        } else if (snapshot.data?.getStoreAlert.data![index].link == 'product') {
                                                          Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) => BlocProvider(
                                                              create: (context) => PincodeCubit(),
                                                              child: StroeProductDescScreen(
                                                                id: snapshot.data?.getStoreAlert.data![index].linkWith!.id ?? "",
                                                              ),
                                                            ),
                                                          ));
                                                        }
                                                      },
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          const Icon(
                                                            Icons.warning_amber_outlined,
                                                            size: 15,
                                                            color: Colors.white,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            snapshot.data?.getStoreAlert.data![index].title ?? "",
                                                            textAlign: TextAlign.center,
                                                            style: GoogleFonts.notoSansDevanagari(
                                                              color: Colors.white,
                                                              fontSize: 10,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  })),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),
                          Expanded(
                            child: Scaffold(
                              extendBody: true,
                              appBar: AppBar(
                                backgroundColor: ColorResources.textWhite,
                                elevation: 0,
                                surfaceTintColor: Colors.white,
                                iconTheme: IconThemeData(color: ColorResources.textblack),
                                automaticallyImplyLeading: false,
                                leading: Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: FittedBox(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: CachedNetworkImage(
                                        height: 35,
                                        width: 35,
                                        imageUrl: SvgImages.storeLogo,
                                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          analytics.logEvent(
                                            name: "app_store_search_icon_click",
                                            parameters: {},
                                          );
                                          showSearch(context: context, delegate: StoreSearchProduct());
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(
                                              color: ColorResources.buttoncolor,
                                            ),
                                          ),
                                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                              child: Text(
                                                Preferences.appString.search ?? "Search ",
                                                style: TextStyle(
                                                  color: ColorResources.textblack,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                                                decoration: BoxDecoration(
                                                  color: ColorResources.buttoncolor,
                                                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(10)),
                                                ),
                                                child: const Icon(
                                                  Icons.search_rounded,
                                                  color: Colors.white,
                                                ))
                                          ]),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  // IconButton(
                                  //   padding: EdgeInsets.zero,
                                  //   onPressed: () {
                                  //     Navigator.of(context).push(MaterialPageRoute(
                                  //       builder: (context) => const StoreCartScreen(),
                                  //     ));
                                  //   },
                                  //   icon: const Icon(Icons.local_mall_outlined),
                                  // ),
                                  // IconButton(
                                  //   padding: EdgeInsets.zero,
                                  //   onPressed: () {
                                  //     Navigator.of(context).push(MaterialPageRoute(
                                  //       builder: (context) => const StoreOrderScreen(),
                                  //     ));
                                  //   },
                                  //   icon: const Icon(CupertinoIcons.cube_box),
                                  // ),

                                  // IconButton(
                                  //   padding: EdgeInsets.zero,
                                  //   onPressed: () {
                                  //     showSearch(context: context, delegate: StoreSearchProduct());
                                  //     //  Navigator.of(context).push(MaterialPageRoute(
                                  //     // builder: (context) => StoreCategoryScreen(
                                  //     // future: RemoteDataSourceImpl().getProductListRequest(),
                                  //     // ),
                                  //     // ))
                                  //   },
                                  //   icon: const Icon(Icons.search_rounded),
                                  // ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => const StoreWishListScreen(),
                                      ));
                                    },
                                    icon: const Icon(Icons.favorite_border_outlined),
                                  ),
                                ],
                              ),
                              body: BlocBuilder<StreamsetectCubit, StreamsetectState>(
                                builder: (context, state) {
                                  return [
                                    storeHomeScreen(data: snapshot.data!),
                                    const StoreCartScreen(),
                                    StoreCategoryListScreen(
                                      storeCategory: snapshot.data!.getStoreCategory,
                                    ),
                                    const StoreOrderScreen(),
                                    const StoreAddressScreen(),
                                  ].elementAt(context.read<StreamsetectCubit>().selectedIndex);
                                },
                              ),
                            ),
                          )
                        ]),
                      ),
                      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
                      floatingActionButton: BlocBuilder<StreamsetectCubit, StreamsetectState>(
                        builder: (context, state) {
                          return FloatingActionButton(
                            shape: const CircleBorder(),
                            onPressed: () {
                              context.read<StreamsetectCubit>().onItemTapped(2);
                            },
                            elevation: 4,
                            backgroundColor: context.read<StreamsetectCubit>().selectedIndex == 2 ? ColorResources.buttoncolor : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.dashboard_outlined,
                                color: context.read<StreamsetectCubit>().selectedIndex == 2 ? Colors.white : Colors.grey,
                              ),
                            ),
                          );
                        },
                      ),
                      extendBody: true,
                      bottomNavigationBar: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(40),
                          topLeft: Radius.circular(40),
                        ),
                        child: BlocBuilder<StreamsetectCubit, StreamsetectState>(
                          builder: (context, state) {
                            return MediaQuery.removeViewPadding(
                              context: context,
                              removeBottom: true,
                              removeTop: true,
                              child: BottomAppBar(
                                shadowColor: Colors.transparent,
                                padding: EdgeInsets.zero,
                                color: Colors.transparent,
                                surfaceTintColor: Colors.transparent,
                                shape: const CircularNotchedRectangle(),
                                notchMargin: 8,
                                elevation: 0.0,
                                clipBehavior: Clip.hardEdge,
                                child: BottomNavigationBar(
                                  backgroundColor: Colors.white,
                                  type: BottomNavigationBarType.fixed,
                                  unselectedItemColor: Colors.grey,
                                  elevation: 0.0,
                                  items: [
                                    BottomNavigationBarItem(
                                      icon: const Icon(Icons.auto_stories_outlined),
                                      label: Preferences.appString.home ?? "Home",
                                    ),
                                    BottomNavigationBarItem(
                                      icon: const Icon(Icons.local_mall_outlined),
                                      label: Preferences.appString.cart ?? "Cart",
                                    ),
                                    BottomNavigationBarItem(
                                      icon: Container(
                                        height: 25,
                                      ),
                                      label: Preferences.appString.category ?? "Category",
                                    ),
                                    BottomNavigationBarItem(
                                      icon: const Icon(Icons.local_shipping_outlined),
                                      label: Preferences.appString.myOrder ?? "My Order",
                                    ),
                                    BottomNavigationBarItem(
                                      icon: const Icon(Icons.person_pin_circle_outlined),
                                      label: Preferences.appString.address ?? 'Address',
                                    ),
                                  ],
                                  currentIndex: context.read<StreamsetectCubit>().selectedIndex,
                                  selectedItemColor: ColorResources.buttoncolor,
                                  onTap: context.read<StreamsetectCubit>().onItemTapped,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  } else {
                    return ErrorWidgetapp(image: SvgImages.error404, text: "Page not found");
                  }
                } else {
                  // print("loading");
                  return SafeArea(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: CachedNetworkImage(
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        imageUrl: SvgImages.storecenterHome,
                        height: 100,
                      ),
                    ),
                  );
                }
              }),
        ));
  }

  Widget storeHomeScreen({required StoreCatAndBanner data}) {
    return SingleChildScrollView(
      child: Column(
        children: [
          data.getStoreCategory.data!.isNotEmpty
              ? Container(
                  height: 40,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                      width: 10,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: data.getStoreCategory.data?.length ?? 0,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: GestureDetector(
                        onTap: () {
                          analytics.logEvent(
                            name: "app_store_category",
                            parameters: {
                              "category": data.getStoreCategory.data?[index].title ?? "",
                              "id": data.getStoreCategory.data?[index].id ?? "",
                            },
                          );
                          if (data.getStoreCategory.data?[index].childCat?.isEmpty ?? true) {
                            flutterToast("No Sub Category Found");
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => StoreCategoryScreen(
                                future: RemoteDataSourceImpl().getProductListRequest(
                                  category: data.getStoreCategory.data?[index].id ?? "",
                                ),
                                productType: data.getStoreCategory.data![index].title ?? "",
                              ),
                            ));
                          } else {
                            showModalBottomSheet(
                                enableDrag: true,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            onTap: () {
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                builder: (context) => StoreCategoryScreen(
                                                  future: RemoteDataSourceImpl().getProductListRequest(
                                                    category: data.getStoreCategory.data?[index].id!,
                                                  ),
                                                  productType: data.getStoreCategory.data?[index].title ?? "",
                                                ),
                                              ));
                                            },
                                            tileColor: ColorResources.buttoncolor.withValues(alpha: 0.1),
                                            title: Text(
                                              data.getStoreCategory.data?[index].title ?? "",
                                              style: TextStyle(
                                                color: ColorResources.textblack,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                height: 0,
                                              ),
                                            ),
                                          ),
                                          // Divider(),
                                          ListView.separated(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            itemCount: data.getStoreCategory.data?[index].childCat?.length ?? 0,
                                            itemBuilder: (context, cindex) => ListTile(
                                                onTap: () {
                                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                                    builder: (context) => StoreCategoryScreen(
                                                      future: RemoteDataSourceImpl().getProductListRequest(
                                                        category: data.getStoreCategory.data?[index].childCat?[cindex].id!,
                                                      ),
                                                      productType: data.getStoreCategory.data?[index].childCat?[cindex].title ?? "",
                                                    ),
                                                  ));
                                                },
                                                title: Text(
                                                  data.getStoreCategory.data?[index].childCat?[cindex].title ?? "",
                                                  style: TextStyle(
                                                    color: ColorResources.textblack,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    height: 0,
                                                  ),
                                                )),
                                            separatorBuilder: (context, index) => const Divider(),
                                          ),
                                        ],
                                      ),
                                    ));
                          }
                          // Navigator.of(context).push(MaterialPageRoute(
                          //   builder: (context) => StoreCategoryScreen(
                          //     future: RemoteDataSourceImpl().getProductListRequest(
                          //       category: data!.getStoreCategory.data![index].id!,
                          //     ),
                          //   ),
                          // ));
                        },
                        child: Row(
                          children: [
                            Text(
                              data.getStoreCategory.data![index].title!,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.notoSansDevanagari(
                                color: ColorResources.textblack,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon((data.getStoreCategory.data?[index].childCat?.isNotEmpty ?? false) ? Icons.arrow_drop_down : Icons.arrow_right),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          data.getStoreBanner.data!.isNotEmpty
              ? IndexWidget(
                  bannerdata: data.getStoreBanner.data!,
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(children: [
              data.getpoplularproductlist.data!.isEmpty
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Preferences.appString.popularProducts ?? 'Popular Products',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSansDevanagari(
                            color: ColorResources.textblack,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            analytics.logEvent(
                              name: "app_store_popular_product",
                            );
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => StoreCategoryScreen(
                                future: RemoteDataSourceImpl().getsgetMarketingCategoryRequest(category: "POPULAR", limit: 30, page: 1),
                                productType: "Popular Products",
                              ),
                            ));
                          },
                          child: Text(
                            Preferences.appString.viewMore ?? 'View More',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.buttoncolor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
              data.getpoplularproductlist.data!.isEmpty
                  ? Container()
                  : const SizedBox(
                      height: 10,
                    ),
              AlignedGridView.count(
                itemCount: data.getpoplularproductlist.data!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                // ),
                itemBuilder: (context, index) => StoreProductCardWidget(
                  productBadge: data.getpoplularproductlist.data![index].badge ?? "",
                  isWishlisted: data.getpoplularproductlist.data![index].isWishList ?? false,
                  productId: data.getpoplularproductlist.data?[index].id ?? "",
                  productImage: data.getpoplularproductlist.data?[index].featuredImage ?? "",
                  productName: data.getpoplularproductlist.data?[index].title ?? "",
                  productRegularPrice: int.parse(data.getpoplularproductlist.data?[index].regularPrice ?? "0"),
                  productSalePrice: int.parse(data.getpoplularproductlist.data?[index].salePrice ?? "0"),
                  productRating: data.getpoplularproductlist.data?[index].averageRating ?? "0",
                ),
              ),
              data.getbookproductlist.data!.isEmpty
                  ? Container()
                  : const SizedBox(
                      height: 15,
                    ),
            ]),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => StoreNewArrivalsScreen(
                data: data.getStoreCategory.data ?? [],
              ),
            )),
            child: CachedNetworkImage(
              imageUrl: SvgImages.storeNewArrivalBackgorund,
              fit: BoxFit.fill,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => Container(),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                data.getbookproductlist.data!.isEmpty
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Preferences.appString.booksSection ?? 'Books Section',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              analytics.logEvent(
                                name: "app_store_book_section",
                              );
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => StoreCategoryScreen(
                                  future: RemoteDataSourceImpl().getsgetMarketingCategoryRequest(category: "BOOK", limit: 30, page: 1),
                                  productType: "Books Section",
                                ),
                              ));
                            },
                            child: Text(
                              Preferences.appString.viewMore ?? 'View More',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.notoSansDevanagari(
                                color: ColorResources.buttoncolor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                data.getbookproductlist.data!.isEmpty
                    ? Container()
                    : const SizedBox(
                        height: 10,
                      ),
                AlignedGridView.count(
                  itemCount: data.getbookproductlist.data!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  // childAspectRatio: 1,
                  // ),
                  itemBuilder: (context, index) => StoreProductCardWidget(
                    productBadge: data.getbookproductlist.data![index].badge ?? "",
                    isWishlisted: data.getbookproductlist.data![index].isWishList ?? false,
                    productId: data.getbookproductlist.data?[index].id ?? "",
                    productImage: data.getbookproductlist.data?[index].featuredImage ?? "",
                    productName: data.getbookproductlist.data?[index].title ?? "",
                    productRegularPrice: int.parse(data.getbookproductlist.data?[index].regularPrice ?? "0"),
                    productSalePrice: int.parse(data.getbookproductlist.data?[index].salePrice ?? "0"),
                    productRating: data.getbookproductlist.data?[index].averageRating ?? "0",
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SaleDiscountScreen(),
              ));
            },
            child: Container(
              height: 70,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: CachedNetworkImageProvider(
                  SvgImages.storeSalesBackgorund,
                ),
                fit: BoxFit.fill,
              )),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Preferences.appString.sale ?? "SALE",
                    style: GoogleFonts.notoSansDevanagari(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "UPTO\n ",
                          style: GoogleFonts.notoSansDevanagari(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: "${((Preferences.remoteStore["salediscount"] as List).last)["discount"]}% ",
                          style: GoogleFonts.notoSansDevanagari(
                            color: Colors.yellow,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: "OFF ",
                          style: GoogleFonts.notoSansDevanagari(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          // GestureDetector(
          //   onTap: () => Navigator.of(context).push(MaterialPageRoute(
          //     builder: (context) => const StoreNewArrivalsScreen(),
          //   )),
          //   child: Container(
          //     height: 150,
          //     width: MediaQuery.of(context).size.width,
          //     decoration: const BoxDecoration(
          //         image: DecorationImage(
          //             image: CachedNetworkImageProvider(
          //               "https://d1mbj426mo5twu.cloudfront.net/marketing/New-arrival.png",
          //             ),
          //             fit: BoxFit.fill)),
          //     alignment: Alignment.center,
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Text(
          //           'NEW ARRIVALS',
          //           textAlign: TextAlign.center,
          //           style: GoogleFonts.notoSansDevanagari(
          //             color: const Color(0xFFFFB700),
          //             fontSize: 16,
          //             fontWeight: FontWeight.w700,
          //             height: 0,
          //           ),
          //         ),
          //         const SizedBox(
          //           height: 10,
          //         ),
          //         Text(
          //           'Explore New Lunch Products',
          //           textAlign: TextAlign.center,
          //           style: GoogleFonts.notoSansDevanagari(
          //             color: Colors.white,
          //             fontSize: 8,
          //             fontWeight: FontWeight.w400,
          //             height: 0,
          //             letterSpacing: -0.32,
          //           ),
          //         ),
          //         const SizedBox(
          //           height: 10,
          //         ),
          //         Container(
          //           padding: const EdgeInsets.all(5),
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(20),
          //             color: ColorResources.textWhite,
          //           ),
          //           child: const Text('---------------->'),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          // const SizedBox(
          //   height: 10,
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              children: [
                data.gethdcproductlist.data!.isEmpty
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Preferences.appString.highDemandCombos ?? 'High Demanding Combos',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              analytics.logEvent(
                                name: "app_store_high_demanding_combos",
                              );
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => StoreCategoryScreen(
                                  future: RemoteDataSourceImpl().getsgetMarketingCategoryRequest(category: "HDC", limit: 30, page: 1),
                                  productType: Preferences.appString.highDemandCombos ?? "High Demand Combos",
                                ),
                              ));
                            },
                            child: Text(
                              Preferences.appString.viewMore ?? 'View More',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.notoSansDevanagari(
                                color: ColorResources.buttoncolor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                data.gethdcproductlist.data!.isEmpty
                    ? Container()
                    : const SizedBox(
                        height: 10,
                      ),
                data.gethdcproductlist.data!.isEmpty
                    ? Container()
                    : AlignedGridView.count(
                        itemCount: data.gethdcproductlist.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        // childAspectRatio: 1,
                        // ),
                        itemBuilder: (context, index) => StoreProductCardWidget(
                          productBadge: data.gethdcproductlist.data![index].badge ?? "",
                          isWishlisted: data.gethdcproductlist.data![index].isWishList ?? false,
                          productId: data.gethdcproductlist.data?[index].id ?? "",
                          productImage: data.gethdcproductlist.data?[index].featuredImage ?? "",
                          productName: data.gethdcproductlist.data?[index].title ?? "",
                          productRegularPrice: int.parse(data.gethdcproductlist.data?[index].regularPrice ?? "0"),
                          productSalePrice: int.parse(data.gethdcproductlist.data?[index].salePrice ?? "0"),
                          productRating: data.gethdcproductlist.data?[index].averageRating ?? "0",
                        ),
                      ),
                data.gethdpproductlist.data!.isEmpty
                    ? Container()
                    : const SizedBox(
                        height: 15,
                      ),
                data.gethdpproductlist.data!.isEmpty
                    ? Container()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Preferences.appString.highDemandingProducts ?? 'High Demanding Products',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansDevanagari(
                              color: ColorResources.textblack,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              analytics.logEvent(
                                name: "app_store_high_demanding_product",
                              );
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => StoreCategoryScreen(
                                  future: RemoteDataSourceImpl().getsgetMarketingCategoryRequest(category: "HDP", limit: 30, page: 1),
                                  productType: Preferences.appString.highDemandingProducts ?? 'High Demanding Products',
                                ),
                              ));
                            },
                            child: Text(
                              Preferences.appString.viewMore ?? 'View More',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.notoSansDevanagari(
                                color: ColorResources.buttoncolor,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                data.gethdpproductlist.data!.isEmpty
                    ? Container()
                    : const SizedBox(
                        height: 10,
                      ),
                data.gethdpproductlist.data!.isEmpty
                    ? Container()
                    : AlignedGridView.count(
                        itemCount: data.gethdpproductlist.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        // childAspectRatio: 1,
                        // ),
                        itemBuilder: (context, index) => StoreProductCardWidget(
                          productBadge: data.gethdpproductlist.data![index].badge ?? "",
                          isWishlisted: data.gethdpproductlist.data![index].isWishList ?? false,
                          productId: data.gethdpproductlist.data?[index].id ?? "",
                          productImage: data.gethdpproductlist.data?[index].featuredImage ?? "",
                          productName: data.gethdpproductlist.data?[index].title ?? "",
                          productRegularPrice: int.parse(data.gethdpproductlist.data?[index].regularPrice ?? "0"),
                          productSalePrice: int.parse(data.gethdpproductlist.data?[index].salePrice ?? "0"),
                          productRating: data.gethdpproductlist.data?[index].averageRating ?? "0",
                        ),
                      ),
                // data!.getsaproductlist.data!.isEmpty
                //     ? Container()
                //     : const SizedBox(
                //         height: 15,
                //       ),
                // data!.getsaproductlist.data!.isEmpty
                //     ? Container()
                //     : Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //             'Stationery and Accessories',
                //             textAlign: TextAlign.center,
                //             style: GoogleFonts.notoSansDevanagari(
                //               color: ColorResources.textblack,
                //               fontSize: 16,
                //               fontWeight: FontWeight.w600,
                //             ),
                //           ),
                //           GestureDetector(
                //             onTap: () {
                //               analytics.logEvent(
                //                 name: "app_store_Stationery_and_Accessories",
                //               );
                //               Navigator.of(context).push(MaterialPageRoute(
                //                 builder: (context) => StoreCategoryScreen(
                //                   future: RemoteDataSourceImpl().getsgetMarketingCategoryRequest(category: "SA", limit: 30),
                //                 ),
                //               ));
                //             },
                //             child: Text(
                //               'View More',
                //               textAlign: TextAlign.center,
                //               style: GoogleFonts.notoSansDevanagari(
                //                 color: ColorResources.buttoncolor,
                //                 fontSize: 12,
                //                 fontWeight: FontWeight.w400,
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                // data!.getsaproductlist.data!.isEmpty
                //     ? Container()
                //     : const SizedBox(
                //         height: 10,
                //       ),
                // data!.getsaproductlist.data!.isEmpty
                //     ? Container()
                //     : AlignedGridView.count(
                //         itemCount: data!.getsaproductlist.data!.length,
                //         shrinkWrap: true,
                //         physics: const NeverScrollableScrollPhysics(),
                //         // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //         crossAxisCount: 2,
                //         mainAxisSpacing: 10,
                //         crossAxisSpacing: 10,
                //         // childAspectRatio: 1,
                //         // ),
                //         itemBuilder: (context, index) => card(getproductlistData: data!.getsaproductlist.data![index]),
                //       ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class StoreCatAndBanner {
  final GetStoreCategory getStoreCategory;
  final GetStoreBanner getStoreBanner;
  final GetMarketingCategory getpoplularproductlist;
  final GetMarketingCategory getbookproductlist;
  // final GetMarketingCategory getsaproductlist;
  final GetMarketingCategory gethdcproductlist;
  final GetMarketingCategory gethdpproductlist;
  final GetStoreAlert getStoreAlert;
  StoreCatAndBanner({
    required this.getpoplularproductlist,
    required this.getbookproductlist,
    // required this.getsaproductlist,
    required this.gethdcproductlist,
    required this.gethdpproductlist,
    required this.getStoreAlert,
    required this.getStoreBanner,
    required this.getStoreCategory,
  });
}

class IndexWidget extends StatefulWidget {
  final List<GetStoreBannerData> bannerdata;
  const IndexWidget({
    super.key,
    required this.bannerdata,
  });

  @override
  State<IndexWidget> createState() => _IndexWidgetState();
}

class _IndexWidgetState extends State<IndexWidget> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.bannerdata.map((item) {
            return GestureDetector(
              onTap: () {
                if (item.link == 'category') {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => StoreCategoryScreen(
                      future: RemoteDataSourceImpl().getProductListRequest(
                        category: item.linkWith!.id,
                      ),
                      productType: item.linkWith?.title ?? "",
                    ),
                  ));
                } else if (item.link == 'product') {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => PincodeCubit(),
                      child: StroeProductDescScreen(
                        id: item.linkWith!.id!,
                      ),
                    ),
                  ));
                } else if (item.link == "link") {
                  launchUrl(Uri.parse(item.linkWith!.id.toString()), mode: LaunchMode.externalApplication);
                }
              },
              child: CachedNetworkImage(
                  placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageUrl: item.icon!),
            );
          }).toList(),
          options: CarouselOptions(
              height: 150,
              autoPlay: true,
              // enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              viewportFraction: 1,
              onPageChanged: (index, reason) {
                safeSetState(() {
                  _current = index;
                });
              }),
        ),
        Center(
          child: SizedBox(
            height: 10,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.bannerdata.length,
              itemBuilder: (context, index) => AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                duration: const Duration(seconds: 1),
                width: _current == index ? 16.0 : 8.0,
                height: 8.0,
                constraints: const BoxConstraints(maxHeight: 8, maxWidth: 16),
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: _current == index ? ColorResources.buttoncolor : Colors.grey,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
