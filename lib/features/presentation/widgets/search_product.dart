import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sd_campus_app/features/cubit/pincode/pincode_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/get_product_list.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/store_product_card.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/view/screens/store/store_product_desc.dart';

class StoreSearchProduct extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // Build the clear button.
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          // When pressed here the query will be cleared from the search bar.
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Build the leading icon.
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
      // Exit from the search screen.
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Build the search results.
    return _buildSearchResults(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Build the search suggestions.
    return _buildSearchsuggestionsResults(query);
  }

  FutureBuilder _buildSearchsuggestionsResults(query) {
    return FutureBuilder<Getproductlist>(
      future: RemoteDataSourceImpl().getsearchRequest(search: query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return snapshot.data!.data!.isEmpty
                ? Center(
                    child: EmptyWidget(
                      image: SvgImages.emptyProduct,
                      text: 'There is no product',
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => PincodeCubit(),
                                child: StroeProductDescScreen(
                                  id: snapshot.data!.data![index].id!,
                                ),
                              ),
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              children: [
                                const Icon(Icons.search_rounded),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    snapshot.data!.data![index].title!,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: snapshot.data!.data!.length);
          } else {
            return ErrorWidgetapp(image: SvgImages.error404, text: "Please check other");
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  FutureBuilder _buildSearchResults(query) {
    return FutureBuilder<Getproductlist>(
      future: RemoteDataSourceImpl().getsearchRequest(search: query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return snapshot.data!.data!.isEmpty
                ? Center(
                    child: EmptyWidget(
                      image: SvgImages.emptyProduct,
                      text: 'There is no product',
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 15.0, right: 15.0),
                    child: AlignedGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 5,
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
                      itemCount: snapshot.data!.data!.length,
                    ),
                  );
          } else {
            return ErrorWidgetapp(image: SvgImages.error404, text: "Please check other");
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
