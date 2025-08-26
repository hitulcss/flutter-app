import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/cubit/cart/cart_cubit.dart';
import 'package:sd_campus_app/features/data/remote/models/get_cart.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/store/store_payment_screen.dart';

class StoreCartScreen extends StatefulWidget {
  const StoreCartScreen({super.key});

  @override
  State<StoreCartScreen> createState() => _StoreCartScreenState();
}

class _StoreCartScreenState extends State<StoreCartScreen> {
  List<ProductData> productdata = [];
  int amount = 0;
  @override
  void initState() {
    super.initState();
    analytics.logScreenView(
      screenName: "app_store_cart",
      screenClass: "StoreCartScreen",
    );
    amount = 0;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CartCubit>().getcartapi();
    });
  }

  Map<String, int> quantity = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: ColorResources.textWhite,
      //   elevation: 0,
      //   iconTheme: IconThemeData(color: ColorResources.textblack),
      //   title: Text(
      //     Preferences.appString.myCart ?? 'My Cart',
      //     style: GoogleFonts.notoSansDevanagari(
      //       color: ColorResources.textblack,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   actions: [
      //     IconButton(
      //       padding: EdgeInsets.zero,
      //       onPressed: () {
      //         Navigator.of(context).pushReplacement(MaterialPageRoute(
      //           builder: (context) => const StoreWishListScreen(),
      //         ));
      //       },
      //       icon: const Icon(Icons.favorite_outline),
      //     ),
      //   ],
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            BlocBuilder<CartCubit, CartState>(
              builder: (context, state) {
                if (state is CartApiSuccess) {
                  productdata.clear();
                  for (var element in state.getCart.data!) {
                    quantity[element.id!] = int.parse(element.quantity!);
                    // amount = amount + (int.parse(element.salePrice!) * int.parse(element.quantity!));
                    productdata.add(
                      ProductData(
                        name: element.title!,
                        quantity: int.parse(element.quantity!),
                        amount: amount,
                        discount: int.parse(element.salePrice!),
                        image: element.featuredImage!,
                        id: element.id!,
                      ),
                    );
                  }
                  return state.getCart.data!.isEmpty
                      ? SizedBox(
                          height: 250,
                          child: EmptyWidget(
                            image: SvgImages.emptycart,
                            text: "The cart is Empty",
                          ),
                        )
                      : Expanded(
                          child: Column(
                            children: [
                              if (state.getCart.data!.length >= 3)
                                Column(
                                  children: [
                                    Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(bottom: 5),
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: BlocBuilder<CartCubit, CartState>(
                                                builder: (context, state) {
                                                  amount = context.read<CartCubit>().amount;
                                                  return Text(
                                                    '₹ $amount',
                                                    style: GoogleFonts.notoSansDevanagari(
                                                      color: ColorResources.textblack,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w500,
                                                      height: 0,
                                                      letterSpacing: -0.60,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                if (context.read<CartCubit>().amount > 0) {
                                                  analytics.logBeginCheckout(
                                                      value: amount.toDouble(),
                                                      currency: "rupee",
                                                      items: productdata.map(
                                                        (e) {
                                                          return AnalyticsEventItem(
                                                            itemName: e.name,
                                                            itemId: e.id,
                                                            quantity: e.quantity,
                                                            price: e.amount,
                                                          );
                                                        },
                                                      ).toList());
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) => StorePaymentScreen(
                                                      productdata: productdata,
                                                      amount: amount,
                                                    ),
                                                  ))
                                                      .then((value) {
                                                    context.read<CartCubit>().getcartapi();
                                                  });
                                                } else {
                                                  flutterToast("Plase add the products to cart");
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  backgroundColor: ColorResources.buttoncolor.withValues(alpha: 0.75)),
                                              child: Text(
                                                Preferences.appString.placeOrder ?? 'Place Order',
                                                style: GoogleFonts.notoSansDevanagari(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              Expanded(
                                flex: state.getCart.data!.length >= 3 ? 1 : 0,
                                child: ListView.builder(
                                  itemCount: state.getCart.data!.length,
                                  shrinkWrap: state.getCart.data!.length < 3 ? true : false,
                                  physics: state.getCart.data!.length < 3 ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return cartcard(getCartData: state.getCart.data![index]);
                                  },
                                ),
                              ),
                              state.getCart.data!.length < 3
                                  ? const SizedBox(
                                      height: 10,
                                    )
                                  : Container(),
                              state.getCart.data!.length < 3
                                  ? Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 20),
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Text(
                                                Preferences.appString.totalAmount ?? 'Total Amount',
                                                style: const TextStyle(
                                                  color: Color(0xFF333333),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                              const Spacer(),
                                              BlocBuilder<CartCubit, CartState>(
                                                builder: (context, state) {
                                                  amount = context.read<CartCubit>().amount;
                                                  return Text(
                                                    '₹ $amount',
                                                    style: GoogleFonts.notoSansDevanagari(
                                                      color: ColorResources.textblack,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w500,
                                                      height: 0,
                                                      letterSpacing: -0.60,
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          const Divider(),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    if (context.read<CartCubit>().amount > 0) {
                                                      analytics.logBeginCheckout(
                                                          value: amount.toDouble(),
                                                          currency: "rupee",
                                                          items: productdata.map(
                                                            (e) {
                                                              return AnalyticsEventItem(
                                                                itemName: e.name,
                                                                itemId: e.id,
                                                                quantity: e.quantity,
                                                                price: e.amount,
                                                              );
                                                            },
                                                          ).toList());
                                                      Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => StorePaymentScreen(
                                                          productdata: productdata,
                                                          amount: amount,
                                                        ),
                                                      ));
                                                      context.read<CartCubit>().getcartapi();
                                                    } else {
                                                      flutterToast("Plase add products to cart");
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      backgroundColor: ColorResources.buttoncolor.withValues(alpha: 0.75)),
                                                  child: Text(
                                                    Preferences.appString.placeOrder ?? 'Place Order',
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
                                        ],
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        );
                } else if (state is CartApiError) {
                  return ErrorWidgetapp(image: SvgImages.error404, text: "Page not found");
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            // FutureBuilder(
            //     future: RemoteDataSourceImpl().getStoreSimilarRequest(),
            //     builder: (context, snapshot) {
            //       if (snapshot.connectionState == ConnectionState.done) {
            //         if (snapshot.hasData) {
            //           return snapshot.data!.data!.isEmpty
            //               ? Container()
            //               : Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text(
            //                       Preferences.appString.similarProducts ?? 'Similar Books  ',
            //                       textAlign: TextAlign.center,
            //                       style: GoogleFonts.notoSansDevanagari(
            //                         color: ColorResources.textblack,
            //                         fontSize: 14,
            //                         fontWeight: FontWeight.w600,
            //                         height: 0,
            //                       ),
            //                     ),
            //                     const SizedBox(
            //                       height: 10,
            //                     ),
            //                     AlignedGridView.count(
            //                       itemCount: snapshot.data!.data!.length,
            //                       shrinkWrap: true,
            //                       physics: const NeverScrollableScrollPhysics(),
            //                       // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //                       crossAxisCount: 2,
            //                       mainAxisSpacing: 10,
            //                       crossAxisSpacing: 10,
            //                       // childAspectRatio: 0.9,
            //                       // ),
            //                       itemBuilder: (context, index) => StoreProductCardWidget(
            //                         productName: snapshot.data!.data![index].title ?? "",
            //                         productImage: snapshot.data!.data![index].featuredImage ?? "",
            //                         productSalePrice: int.parse(snapshot.data!.data![index].salePrice ?? "0"),
            //                         productRegularPrice: int.parse(snapshot.data!.data![index].regularPrice ?? "0"),
            //                         productRating: snapshot.data!.data![index].averageRating ?? "0",
            //                         productId: snapshot.data!.data![index].id ?? "",
            //                         isWishlisted: snapshot.data!.data![index].isWishList ?? false,
            //                         productBadge: snapshot.data!.data![index].badge ?? "",
            //                       ),
            //                     ),
            //                   ],
            //                 );
            //         } else {
            //           return ErrorWidgetapp(image: SvgImages.error404, text: "Page not found");
            //         }
            //       } else {
            //         return Center(
            //           child: Container(),
            //           // CircularProgressIndicator(),
            //         );
            //       }
            //     }),
            // const SizedBox(
            //   height: 10,
            // ),
          ],
        ),
      ),
    );
  }

  Widget cartcard({required GetCartData getCartData}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: ColorResources.textWhite,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x7FD9D9D9),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  height: 100,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  imageUrl: getCartData.featuredImage!,
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      getCartData.title!,
                      style: GoogleFonts.notoSansDevanagari(
                        color: ColorResources.textblack,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        '₹${getCartData.salePrice}',
                        style: GoogleFonts.notoSansDevanagari(
                          color: ColorResources.textblack,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '₹${getCartData.regularPrice}',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSansDevanagari(
                          decoration: TextDecoration.lineThrough,
                          color: const Color(0xFFA6A6A6),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          children: [
                            Text(
                              '${Preferences.appString.quantity ?? "Quantity"}:',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.notoSansDevanagari(
                                color: ColorResources.textblack,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              height: 30,
                              width: 60,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                                  border: OutlineInputBorder(),
                                ),
                                child: DropdownButton(
                                  // borderRadius: ,
                                  isExpanded: true,
                                  underline: Container(),
                                  items: List.generate(int.parse(getCartData.maxPurchaseQty!), (index) => DropdownMenuItem<int>(value: index + 1, child: Text("${index + 1} "))),
                                  value: quantity[getCartData.id],
                                  onChanged: (value) {
                                    context.read<CartCubit>().getcartapi(productId: getCartData.id, productQty: value);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          style: IconButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () {
                            analytics.logRemoveFromCart(currency: "rupee", value: double.parse(getCartData.salePrice!), items: [
                              AnalyticsEventItem(
                                itemName: getCartData.title,
                                price: int.parse(getCartData.regularPrice!),
                              ),
                            ]);
                            context.read<CartCubit>().removefromCart(id: getCartData.id);
                          },
                          icon: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red,
                          ))
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
