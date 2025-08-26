import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/get_product_list.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/store_product_card.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';

class DiscountProductScreen extends StatelessWidget {
  final int discount;
  const DiscountProductScreen({super.key, required this.discount});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Preferences.appString.discountProduct ?? 'Discount Product'),
      ),
      body: FutureBuilder(
        future: RemoteDataSourceImpl().getProductListRequest(minDiscount: discount),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return DicountProductList(
                productlist: snapshot.data!.data ?? [],
                discount: discount,
              );
            } else {
              return ErrorWidgetapp(image: SvgImages.error404, text: "Page not found");
            }
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        },
      ),
    );
  }
}

class DicountProductList extends StatefulWidget {
  final List<GetproductlistData> productlist;
  final int discount;
  const DicountProductList({super.key, required this.productlist, required this.discount});

  @override
  State<DicountProductList> createState() => _DicountProductListState();
}

class _DicountProductListState extends State<DicountProductList> {
  int page = 2;
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  bool hasMore = true;
  List<GetproductlistData> productlist = [];
  @override
  void initState() {
    super.initState();

    productlist = widget.productlist;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      hasMore = scrollController.position.maxScrollExtent > 0 ? true : false;
      scrollController.addListener(() async {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent * 0.95 && !isLoading) {
          safeSetState(() {
            isLoading = true;
          });
          if (hasMore) {
            Getproductlist data = await RemoteDataSourceImpl().getProductListRequest(
              minDiscount: widget.discount,
              page: page,
            );
            safeSetState(() {
              productlist.addAll(data.data ?? []);
              isLoading = false;
              page = page + 1;
              hasMore = data.data?.isNotEmpty ?? false;
            });
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AlignedGridView.count(
            padding: const EdgeInsets.all(10.0),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 8,
            controller: scrollController,
            itemCount: productlist.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) => hasMore && index == productlist.length
                ? const Center(child: CircularProgressIndicator())
                : StoreProductCardWidget(
                    productName: productlist[index].title ?? "",
                    productImage: productlist[index].featuredImage ?? "",
                    productSalePrice: int.parse(productlist[index].salePrice ?? "0"),
                    productRegularPrice: int.parse(productlist[index].regularPrice ?? "0"),
                    productRating: productlist[index].averageRating ?? "0",
                    productId: productlist[index].id ?? "",
                    isWishlisted: productlist[index].isWishList ?? false,
                    productBadge: productlist[index].badge ?? "",
                  )));
  }
}
