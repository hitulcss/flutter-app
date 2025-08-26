import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sd_campus_app/features/data/remote/models/store_discount.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/store/dicount_product.dart';

class SaleDiscountScreen extends StatelessWidget {
  final List<StoreDiscount> discount = (Preferences.remoteStore["salediscount"] as List).map((e) => StoreDiscount.fromJson(e)).toList();
  SaleDiscountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text( Preferences.appString.sale ?? 'Sale'),
      ),
      body: GridView(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 500, mainAxisSpacing: 10, crossAxisSpacing: 8),
        children: List.generate(
          discount.length,
          (index) => GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DiscountProductScreen(
                    discount: discount[index].discount ?? 0,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: MediaQuery.sizeOf(context).width > 500 ? 10 : 20),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(discount[index].image ?? ""),
                  fit: BoxFit.fitHeight,
                ),
              ),
              alignment: Alignment.bottomCenter,
              child: Text(
                "Min\n${discount[index].discount}%\nOFF",
                style: TextStyle(
                  fontSize: MediaQuery.sizeOf(context).width > 500 ? 30 : 40,
                  fontWeight: FontWeight.bold,
                  height: MediaQuery.sizeOf(context).width > 500 ? 1 : 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
