import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/search_product.dart';
import 'package:sd_campus_app/features/presentation/widgets/store_product_card.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';

class StoreCategoryScreen extends StatefulWidget {
  final Future future;
  final bool isSearchBar;
  final String productType;
  const StoreCategoryScreen({
    super.key,
    required this.future,
    this.isSearchBar = false,
    required this.productType,
  });

  @override
  State<StoreCategoryScreen> createState() => _StoreCategoryScreenState();
}

class _StoreCategoryScreenState extends State<StoreCategoryScreen> {
  List<String> subcate = [];
  String selectedsort = '';
  String selectedlanguage = '';
  String selectedSubject = 'ALL';

  String selectedfsubject = '';

  String selectedmtype = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.textWhite,
          elevation: 0,
          iconTheme: IconThemeData(color: ColorResources.textblack),
          title: Text(
            widget.productType,
            style: TextStyle(
              color: ColorResources.textblack,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  analytics.logEvent(
                    name: "app_store_search_icon_click",
                    parameters: {},
                  );
                  showSearch(context: context, delegate: StoreSearchProduct());
                },
                icon: const Icon(
                  Icons.search_rounded,
                ))
          ],
        ),
        body: FutureBuilder(
            future: widget.future,
            // RemoteDataSourceImpl().getProductListRequest(
            //   category: widget.categoryid,
            //   productType: widget.productType,
            // ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  subcate.clear();
                  subcate.add("ALL");
                  Map<String, List> datafilter = {};
                  datafilter["ALL"] = [];

                  for (var element in snapshot.data!.data!) {
                    //print(datafilter);
                    //print(subcate);
                    if (!subcate.contains(element.badge)) {
                      subcate.add(element.badge!);
                      datafilter[element.badge!] = [];
                    }
                    datafilter[element.badge!]!.add(element);
                  }
                  datafilter["ALL"]!.addAll(snapshot.data!.data!);
                  if (selectedsort.isNotEmpty) {
                    if (selectedsort == "LH") {
                      datafilter.forEach((key, value) {
                        value.sort((a, b) => int.parse(a.salePrice!).compareTo(int.parse(b.salePrice!)));
                      });
                    } else {
                      datafilter.forEach((key, value) {
                        value.sort((a, b) => int.parse(b.salePrice!).compareTo(int.parse(a.salePrice!)));
                      });
                    }
                  }
                  if (selectedlanguage.isNotEmpty) {
                    datafilter.forEach((key, value) {
                      value.removeWhere((element) => element.language == selectedlanguage);
                    });
                  }
                  //print(datafilter);
                  //print("object" * 100);
                  return Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    side: BorderSide(
                                      color: ColorResources.buttoncolor,
                                    )),
                                onPressed: () {
                                  showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    context: context,
                                    isScrollControlled: true,
                                    useSafeArea: true,
                                    builder: (context) => Container(
                                      constraints: BoxConstraints(
                                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                                      ),
                                      child: StatefulBuilder(builder: (context, safeSetState) {
                                        return Column(
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Filters',
                                                style: GoogleFonts.notoSansDevanagari(
                                                  color: ColorResources.textblack,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                            const Divider(),
                                            Expanded(
                                              child: Scrollbar(
                                                thumbVisibility: true,
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      ListTile(
                                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                                        title: Text(
                                                          'Sort',
                                                          style: GoogleFonts.notoSansDevanagari(
                                                            color: ColorResources.textblack,
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w600,
                                                            height: 0,
                                                          ),
                                                        ),
                                                      ),
                                                      RadioListTile<String>(
                                                        title: const Text('High To Low'),
                                                        value: 'HL',
                                                        groupValue: selectedsort,
                                                        onChanged: (value) {
                                                          safeSetState(() {
                                                            selectedsort = value!;
                                                          });
                                                        },
                                                      ),
                                                      RadioListTile<String>(
                                                        title: const Text('Low To High'),
                                                        value: 'LH',
                                                        groupValue: selectedsort,
                                                        onChanged: (value) {
                                                          safeSetState(() {
                                                            selectedsort = value!;
                                                          });
                                                        },
                                                      ),
                                                      // RadioListTile<String>(
                                                      //   title: const Text('2022'),
                                                      //   value: '2022',
                                                      //   groupValue: selectedyear,
                                                      //   onChanged: (value) {
                                                      //     safeSetState(() {
                                                      //       selectedyear = value!;
                                                      //     });
                                                      //   },
                                                      // ),
                                                      const Divider(),
                                                      ListTile(
                                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                                        title: Text(
                                                          'Language',
                                                          style: GoogleFonts.notoSansDevanagari(
                                                            color: ColorResources.textblack,
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.w600,
                                                            height: 0,
                                                          ),
                                                        ),
                                                      ),
                                                      RadioListTile<String>(
                                                        title: const Text('English'),
                                                        value: 'en',
                                                        groupValue: selectedlanguage,
                                                        onChanged: (value) {
                                                          safeSetState(() {
                                                            selectedlanguage = value!;
                                                          });
                                                        },
                                                      ),
                                                      RadioListTile<String>(
                                                        title: const Text('Hindi'),
                                                        value: 'hi',
                                                        groupValue: selectedlanguage,
                                                        onChanged: (value) {
                                                          safeSetState(() {
                                                            selectedlanguage = value!;
                                                          });
                                                        },
                                                      ),
                                                      RadioListTile<String>(
                                                        title: const Text('Hindi + English'),
                                                        value: 'hien',
                                                        groupValue: selectedlanguage,
                                                        onChanged: (value) {
                                                          safeSetState(() {
                                                            selectedlanguage = value!;
                                                          });
                                                        },
                                                      ),
                                                      // const Divider(),
                                                      // ListTile(
                                                      //   title: Text(
                                                      //     'Subjects',
                                                      //     style: GoogleFonts.notoSansDevanagari(
                                                      //       color: ColorResources.textblack,
                                                      //       fontSize: 12,
                                                      //       fontWeight: FontWeight.w600,
                                                      //       height: 0,
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                      // RadioListTile<String>(
                                                      //   title: const Text('Physics'),
                                                      //   value: 'Physics',
                                                      //   groupValue: selectedfsubject,
                                                      //   onChanged: (value) {
                                                      //     safeSetState(() {
                                                      //       selectedfsubject = value!;
                                                      //     });
                                                      //   },
                                                      // ),
                                                      // RadioListTile<String>(
                                                      //   title: const Text('Chemistry'),
                                                      //   value: 'Chemistry',
                                                      //   groupValue: selectedfsubject,
                                                      //   onChanged: (value) {
                                                      //     safeSetState(() {
                                                      //       selectedfsubject = value!;
                                                      //     });
                                                      //   },
                                                      // ),
                                                      // RadioListTile<String>(
                                                      //   title: const Text('Maths'),
                                                      //   value: 'Maths',
                                                      //   groupValue: selectedfsubject,
                                                      //   onChanged: (value) {
                                                      //     safeSetState(() {
                                                      //       selectedfsubject = value!;
                                                      //     });
                                                      //   },
                                                      // ),
                                                      // const Divider(),
                                                      // ListTile(
                                                      //   title: Text(
                                                      //     'Study Material Type',
                                                      //     style: GoogleFonts.notoSansDevanagari(
                                                      //       color: ColorResources.textblack,
                                                      //       fontSize: 12,
                                                      //       fontWeight: FontWeight.w600,
                                                      //       height: 0,
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                      // RadioListTile<String>(
                                                      //   title: const Text('Crash Course'),
                                                      //   value: 'Crash Course',
                                                      //   groupValue: selectedmtype,
                                                      //   onChanged: (value) {
                                                      //     safeSetState(() {
                                                      //       selectedmtype = value!;
                                                      //     });
                                                      //   },
                                                      // ),
                                                      // RadioListTile<String>(
                                                      //   title: const Text('Test Series'),
                                                      //   value: 'Test Series',
                                                      //   groupValue: selectedmtype,
                                                      //   onChanged: (value) {
                                                      //     safeSetState(() {
                                                      //       selectedmtype = value!;
                                                      //     });
                                                      //   },
                                                      // ),
                                                      // RadioListTile<String>(
                                                      //   title: const Text('Question Banks'),
                                                      //   value: 'Question Banks',
                                                      //   groupValue: selectedmtype,
                                                      //   onChanged: (value) {
                                                      //     safeSetState(() {
                                                      //       selectedmtype = value!;
                                                      //     });
                                                      //   },
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Divider(),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                TextButton(
                                                    onPressed: () {
                                                      safeSetState(
                                                        () {
                                                          selectedlanguage = "";
                                                          selectedsort = "";
                                                        },
                                                      );
                                                      Navigator.of(context).pop();
                                                    },
                                                    child: Text(
                                                      'Reset',
                                                      style: GoogleFonts.notoSansDevanagari(
                                                        color: ColorResources.textBlackSec,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                        height: 0,
                                                      ),
                                                    )),
                                                ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: ColorResources.buttoncolor,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                                    child: Text(
                                                      'Apply',
                                                      style: GoogleFonts.notoSansDevanagari(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                        height: 0,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        );
                                      }),
                                    ),
                                  ).then((value) {
                                    safeSetState(() {});
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'Filters',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.notoSansDevanagari(
                                        color: ColorResources.textBlackSec,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Icon(Icons.arrow_drop_down)
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: categorywidget(defaultData: subcate),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: snapshot.data!.data!.isEmpty
                              ? EmptyWidget(
                                  image: SvgImages.emptymycart,
                                  text: 'Empty Data',
                                )
                              : datafilter[selectedSubject]!.isEmpty
                                  ? EmptyWidget(
                                      image: SvgImages.emptymycart,
                                      text: 'Empty Data',
                                    )
                                  : AlignedGridView.count(
                                      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                                      itemCount: datafilter[selectedSubject]!.length,
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      // childAspectRatio: 1,
                                      // ),
                                      itemBuilder: (context, index) => StoreProductCardWidget(
                                        productImage: datafilter[selectedSubject]?[index].featuredImage ?? "",
                                        productName: datafilter[selectedSubject]?[index].title ?? "",
                                        productSalePrice: int.parse(datafilter[selectedSubject]?[index].salePrice ?? "0"),
                                        productRegularPrice: int.parse(datafilter[selectedSubject]?[index].regularPrice ?? "0"),
                                        productRating: datafilter[selectedSubject]?[index].averageRating ?? "0",
                                        productId: datafilter[selectedSubject]?[index].id ?? "",
                                        isWishlisted: datafilter[selectedSubject]?[index].isWishList ?? false,
                                        productBadge: datafilter[selectedSubject]?[index].badge ?? "",
                                      ),
                                    ),
                        ),
                      ],
                    ),
                  );
                } else {
                  //print(snapshot.error);
                  return ErrorWidgetapp(image: SvgImages.error404, text: "Page not found");
                }
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }

  categorywidget({required List<String> defaultData}) {
    List<Widget> listsubject = [];
    for (var element in subcate) {
      listsubject.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: ChoiceChip(
            backgroundColor: Colors.transparent,
            selectedColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(
                  color: selectedSubject.contains(element) ? ColorResources.buttoncolor : ColorResources.gray.withValues(alpha: 0.5),
                )),
            labelStyle: GoogleFonts.notoSansDevanagari(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: selectedSubject.contains(element) ? ColorResources.buttoncolor : ColorResources.textblack.withValues(alpha: 0.6),
            ),
            label: Text(
              element,
            ),
            selected: selectedSubject == element,
            onSelected: (value) {
              safeSetState(() {
                selectedSubject = element;
                // for (var element in lecturedata) {
                //   if (selectedSubject == 'ALL') {
                //     spLecturedata.add(element);
                //   } else if (element.subject!.title == selectedSubject) {
                //     spLecturedata.add(element);
                //   }
                // }
              });
            },
          ),
        ),
      );
    }
    return listsubject;
  }
}
