import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/ebook/get_all_ebook.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/shimmer_custom.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/payment_status.dart';
import 'package:sd_campus_app/util/pdf_render.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/view/screens/e_book/ebook_checkout_screen.dart';
import 'package:sd_campus_app/view/screens/e_book/ebookdetail.dart';

class EBookScreen extends StatefulWidget {
  const EBookScreen({super.key});

  @override
  State<EBookScreen> createState() => _EBookScreenState();
}

class _EBookScreenState extends State<EBookScreen> {
  Category selectedcategories = Category();
  bool isLowtohigh = false;
  String? language;
  int? minprice;
  int? maxprice;

  String? sortby;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          initialData: SharedPreferenceHelper.getString(Preferences.getAllEbookApi) != 'N/A' ? GetAllEbooks.fromJson(jsonDecode(SharedPreferenceHelper.getString(Preferences.getAllEbookApi)!)) : GetAllEbooks(status: true, data: GetAllEbooksData(categories: [], ebooks: []), msg: ''),
          future: RemoteDataSourceImpl().getAllEbooksRequest(
            category: selectedcategories.id,
            language: language,
            minPrice: minprice,
            maxPrice: maxprice,
            sort: sortby,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (selectedcategories.title?.isEmpty ?? true) {
                SharedPreferenceHelper.setString(Preferences.getAllEbookApi, jsonEncode(snapshot.data!.toJson()));
              }
              return Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  snapshot.data?.data?.categories?.isEmpty ?? true
                      ? Container()
                      : Row(
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () async {
                                final result = await showModalBottomSheet<List<dynamic>>(
                                  barrierLabel: "Filter",
                                  useSafeArea: true,
                                  context: context,
                                  isScrollControlled: true,
                                  showDragHandle: true,
                                  builder: (context) {
                                    return StatefulBuilder(builder: (context, state) {
                                      return SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  Preferences.appString.filter ?? "Filter",
                                                  style: GoogleFonts.roboto(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            MediaQuery.removePadding(
                                              context: context,
                                              removeBottom: true,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: snapshot.data?.data?.categories?.length ?? 0,
                                                itemBuilder: (context, index) {
                                                  return RadioListTile(
                                                    value: snapshot.data?.data?.categories?[index].id,
                                                    groupValue: selectedcategories.id,
                                                    title: Text(snapshot.data?.data?.categories?[index].title ?? ""),
                                                    onChanged: (value) {
                                                      state(() {
                                                        selectedcategories = snapshot.data?.data?.categories?.firstWhere((element) => element.id == value) ?? Category();
                                                      });
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                Preferences.appString.language ?? "Language",
                                                style: GoogleFonts.notoSansDevanagari(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            MediaQuery.removePadding(
                                              context: context,
                                              removeBottom: true,
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: 2,
                                                itemBuilder: (context, index) {
                                                  List<String> lag = [
                                                    "English",
                                                    "Hindi"
                                                  ];
                                                  List<String> lag2 = [
                                                    "en",
                                                    "hi"
                                                  ];
                                                  return RadioListTile(
                                                    value: lag2[index],
                                                    groupValue: language,
                                                    title: Text(lag[index]),
                                                    onChanged: (value) {
                                                      state(() {
                                                        language = value.toString();
                                                      });
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Price",
                                                  style: GoogleFonts.notoSansDevanagari(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )),
                                            RangeSlider(
                                                min: 0,
                                                max: 10000,
                                                values: RangeValues(minprice?.toDouble() ?? 10, maxprice?.toDouble() ?? 1000),
                                                labels: RangeLabels(
                                                  minprice.toString(),
                                                  maxprice.toString(),
                                                ),
                                                onChanged: (value) {
                                                  state(() {
                                                    minprice = value.start.toInt();
                                                    maxprice = value.end.toInt();
                                                  });
                                                }),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Text(
                                                "Sort By",
                                                style: GoogleFonts.notoSansDevanagari(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            RadioListTile(
                                              title: const Text("Low to High"),
                                              value: "low",
                                              groupValue: sortby,
                                              onChanged: (value) {
                                                state(() {
                                                  sortby = value.toString();
                                                });
                                              },
                                            ),
                                            RadioListTile(
                                              title: const Text("High to Low"),
                                              value: "high",
                                              groupValue: sortby,
                                              onChanged: (value) {
                                                state(() {
                                                  sortby = value.toString();
                                                });
                                              },
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: OutlinedButton(
                                                      onPressed: () => Navigator.pop(context),
                                                      style: ElevatedButton.styleFrom(
                                                        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                                                        side: BorderSide(width: 1.0, color: ColorResources.buttoncolor),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10), // <-- Radius
                                                        ),
                                                      ),
                                                      child: const Text('Cancel'),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      onPressed: () => Navigator.pop(context, [
                                                        selectedcategories,
                                                        language,
                                                        minprice,
                                                        maxprice
                                                      ]),
                                                      style: ElevatedButton.styleFrom(
                                                        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                                                        backgroundColor: ColorResources.buttoncolor,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10), // <-- Radius
                                                        ),
                                                      ),
                                                      child: Text(
                                                        Preferences.appString.apply ?? 'Apply',
                                                        style: const TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                                  },
                                );
                                if (result != null) {
                                  safeSetState(() {});
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorResources.buttoncolor,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.tune,
                                      color: ColorResources.buttoncolor,
                                    ),
                                    Text(
                                      Preferences.appString.filter ?? 'Filter',
                                      style: TextStyle(color: ColorResources.buttoncolor),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: ColorResources.buttoncolor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(children: lableWidegets(categories: snapshot.data?.data?.categories ?? [])),
                              ),
                            ),
                          ],
                        ),
                  snapshot.connectionState == ConnectionState.done
                      ? Expanded(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: EbookCardScreen(
                                ebooks: snapshot.data?.data?.ebooks,
                                selectedcategories: selectedcategories.id,
                                language: language ?? "en",
                                isLowtohigh: isLowtohigh,
                              )),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ],
              );
            } else {
              return ErrorWidgetapp(image: SvgImages.error404, text: "Page not found");
            }
          }),
    );
  }

  List<Widget> lableWidegets({required List<Category> categories}) {
    return categories
        .map((e) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1.0),
              child: ChoiceChip(
                  label: Text(e.title ?? ""),
                  selected: selectedcategories.id == e.id,
                  onSelected: (selected) {
                    safeSetState(() {
                      if (selectedcategories.id == e.id) {
                        selectedcategories = Category();
                      } else {
                        selectedcategories = e;
                      }
                    });
                  }),
            ))
        .toList();
  }
}

class EbookCardScreen extends StatefulWidget {
  final List<Ebooks>? ebooks;
  final String? selectedcategories;
  final String language;
  final bool isLowtohigh;
  const EbookCardScreen({
    super.key,
    required this.ebooks,
    this.selectedcategories,
    this.language = "en",
    this.isLowtohigh = false,
  });

  @override
  State<EbookCardScreen> createState() => _EbookCardScreenState();
}

class _EbookCardScreenState extends State<EbookCardScreen> {
  int page = 2;
  List<Ebooks> ebooks = [];
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  bool hasMore = true;
  @override
  void initState() {
    page = 2;
    ebooks = widget.ebooks ?? [];
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (scrollController.hasClients) {
        safeSetState(() {
          hasMore = scrollController.position.maxScrollExtent > 0 ? true : false;
        });
        scrollController.addListener(() async {
          if (scrollController.position.pixels >= scrollController.position.maxScrollExtent * 0.95 && !isLoading) {
            safeSetState(() {
              isLoading = true;
            });
            if (hasMore) {
              GetAllEbooks data = await RemoteDataSourceImpl().getAllEbooksRequest(
                page: page,
                category: widget.selectedcategories == "" ? null : widget.selectedcategories,
              );
              safeSetState(() {
                ebooks.addAll(data.data?.ebooks ?? []);
                isLoading = false;
                page = page + 1;
                hasMore = data.data?.ebooks?.isNotEmpty ?? false;
              });
            }
          }
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    page = 1;
    isLoading = false;
    hasMore = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ebooks.isEmpty
          ? Center(child: EmptyWidget(image: SvgImages.noEbooks, text: Preferences.appString.noEbooks ?? "No Ebooks Found"))
          : ListView.builder(
              controller: scrollController,
              itemCount: ebooks.length + (hasMore ? 1 : 0),
              itemBuilder: (context, index) => index != ebooks.length
                  ? card(ebooks: ebooks[index])
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
    );
  }

  Widget card({required Ebooks ebooks}) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: ebooks.banner ?? "",
                    placeholder: (context, url) => ShimmerCustom.rectangular(height: 200),
                    errorWidget: (context, url, error) => const SizedBox(
                      height: 100,
                      child: Center(
                        child: Icon(Icons.error),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton.filled(
                      tooltip: "Preview",
                      style: IconButton.styleFrom(
                        backgroundColor: ColorResources.buttoncolor.withValues(alpha: 0.8),
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
                          builder: (context) => PdfRenderScreen(
                            isoffline: false,
                            filePath: ebooks.preview ?? "",
                            name: ebooks.title ?? "",
                          ),
                        ));
                      },
                      icon: const Icon(Icons.remove_red_eye_outlined),
                    ),
                  )
                ],
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ebooks.title ?? "",
                  style: TextStyle(
                    color: ColorResources.textblack,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 0,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(
                  height: 5,
                ),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFF2EBFF),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              strokeAlign: BorderSide.strokeAlignOutside,
                              color: ColorResources.buttoncolor.withValues(alpha: 0.3),
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        child: Text(
                          ebooks.language == 'en' ? 'English' : 'Hindi',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: ColorResources.buttoncolor,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      (ebooks.chapterCount ?? 0) > 0
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: ShapeDecoration(
                                color: const Color(0xFFF2EBFF),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                    color: ColorResources.buttoncolor.withValues(alpha: 0.3),
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.book_outlined,
                                    size: 15,
                                    color: ColorResources.buttoncolor,
                                  ),
                                  Text(
                                    '${ebooks.chapterCount} ${Preferences.appString.chapters ?? "Chapters"}',
                                    style: TextStyle(
                                      color: ColorResources.buttoncolor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  itemCount: ebooks.keyFeatures?.length ?? 0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Row(children: [
                      Icon(
                        Icons.emoji_objects_outlined,
                        size: 20,
                        color: ColorResources.buttoncolor,
                      ),
                      Expanded(
                          child: Text(
                        ebooks.keyFeatures?[index] ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: ColorResources.textblack,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ))
                    ]);
                  },
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      ebooks.averageRating == "0.0" ? "5.0" : ebooks.averageRating ?? "5.0",
                      style: const TextStyle(
                        color: Color(0xFF333333),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow[700],
                      size: 15,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    (ebooks.reviewCount ?? 0) > 0
                        ? Row(
                            children: [
                              Icon(
                                Icons.verified,
                                size: 15,
                                color: ColorResources.buttoncolor,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '(${ebooks.reviewCount} ${Preferences.appString.reviews ?? "Reviews"})',
                                style: const TextStyle(
                                  color: Color(0xBF333333),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                int.parse(ebooks.salePrice ?? "0") > 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '₹${ebooks.salePrice}',
                                  style: TextStyle(
                                    color: ColorResources.buttoncolor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                                TextSpan(
                                  text: ' ₹${int.parse(ebooks.regularPrice ?? "0") - int.parse(ebooks.salePrice ?? "0")}  ',
                                  style: const TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    color: Color(0xBF333333),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '(${((int.parse(ebooks.regularPrice ?? "0") - int.parse(ebooks.salePrice ?? "0")) / int.parse(ebooks.regularPrice ?? "0") * 100).truncate()}% OFF)',
                            style: const TextStyle(
                              color: Color(0xFF1D7025),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      )
                    : Text(
                        'Free',
                        style: GoogleFonts.notoSansDevanagari(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                const Divider(),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).push(
                            CupertinoPageRoute(
                              builder: (context) => EBookDetailScreen(
                                id: ebooks.id ?? "",
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
                          backgroundColor: ColorResources.buttoncolor.withValues(alpha: 0.05),
                          side: BorderSide.none, //(width: 1.0, color: ColorResources.buttoncolor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // <-- Radius
                          ),
                        ),
                        child: Text(
                          Preferences.appString.explore ?? 'Explore',
                          style: GoogleFonts.notoSansDevanagari(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: ColorResources.buttoncolor,
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
                          if (int.parse(ebooks.salePrice ?? "0") <= 0) {
                            RemoteDataSourceImpl().postFreePaymentEbookRequest(ebookid: ebooks.id ?? "").then((value) {
                              if (value.status == true) {
                                paymentstatus(context: context, ispaided: true, paymentfor: "ebook");
                                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyEbookScreen()));
                              } else {
                                flutterToast(value.msg);
                              }
                            });
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EbookCheckoutScreen(
                                          salePrice: double.parse(ebooks.salePrice ?? "0"),
                                          originalPrice: double.parse(ebooks.regularPrice ?? "0"),
                                          bookName: ebooks.title ?? "",
                                          bookId: ebooks.id ?? "",
                                        )));
                          }

                          // callApiaddtocart(snapshot.data!.data[index].id);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                          backgroundColor: ColorResources.buttoncolor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // <-- Radius
                          ),
                        ),
                        child: Text(
                          Preferences.appString.buyNow ?? 'Buy Now',
                          style: GoogleFonts.notoSansDevanagari(
                            fontSize: 16,
                            color: ColorResources.textWhite,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
