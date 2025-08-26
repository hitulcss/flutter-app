import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/getstorecategory.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/view/screens/store/store_catg_list.dart';

class StoreCategoryListScreen extends StatefulWidget {
  final GetStoreCategory storeCategory;
  const StoreCategoryListScreen({super.key, required this.storeCategory});

  @override
  State<StoreCategoryListScreen> createState() => _StoreCategoryListScreenState();
}

class _StoreCategoryListScreenState extends State<StoreCategoryListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        separatorBuilder: (context, index) => const SizedBox(
          height: 5,
        ),
        itemCount: widget.storeCategory.data?.length ?? 0,
        itemBuilder: (context, index) => Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            backgroundColor: Colors.white,
            collapsedBackgroundColor: Colors.white,
            title: ListTile(
              minLeadingWidth: 0,
              contentPadding: EdgeInsets.zero,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StoreCategoryScreen(
                      future: RemoteDataSourceImpl().getProductListRequest(
                        category: widget.storeCategory.data?[index].id ?? "",
                      ),
                      productType: widget.storeCategory.data?[index].title ?? "",
                    ),
                  ),
                );
              },
              title: Text(
                widget.storeCategory.data?[index].title ?? "",
                textAlign: TextAlign.left,
                style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
              ),
            ),
            expandedAlignment: Alignment.bottomLeft,
            children: [
              const Divider(),
              (widget.storeCategory.data?[index].childCat?.isEmpty ?? true)
                  ? Text(
                      "no Sub Category",
                      style: GoogleFonts.notoSansDevanagari(
                        color: ColorResources.textblack,
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.storeCategory.data?[index].childCat?.length ?? 0,
                      itemBuilder: (context, cindex) => ListTile(
                        onTap: () {
                          //  Navigate to StoreDetailsScreen with selected category
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => StoreCategoryScreen(
                                future: RemoteDataSourceImpl().getProductListRequest(
                                  category: widget.storeCategory.data?[index].childCat?[cindex].id ?? "",
                                ),
                                productType: widget.storeCategory.data?[index].childCat?[cindex].title ?? "",
                              ),
                            ),
                          );
                        },
                        title: Text(
                          widget.storeCategory.data?[index].childCat?[cindex].title ?? "",
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
