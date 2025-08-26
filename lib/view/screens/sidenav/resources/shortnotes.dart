import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/cubit/streamselect/streamsetect_cubit.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/resources/resources_data_sources_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/pyq_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/resourcespdfwidget.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/localfiles.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';

class ShortNotesScreen extends StatefulWidget {
  const ShortNotesScreen({super.key});

  @override
  State<ShortNotesScreen> createState() => _ShortNotesScreenState();
}

class _ShortNotesScreenState extends State<ShortNotesScreen>
    with SingleTickerProviderStateMixin {
  final ResourceDataSourceImpl resourceDataSourceImpl =
      ResourceDataSourceImpl();
  TabController? _tabController;
  List<String> subcate = [];
  String selectedSubject = 'ALL';
  @override
  void initState() {
    analytics.logEvent(name: "app_pyqs");
    Localfilesfind.initState();
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose(); // Dispose of the tab controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorResources.textWhite,
        iconTheme: IconThemeData(color: ColorResources.textblack),
        title: Text(
          Preferences.appString.pyqs ?? Languages.shortnotes,
          style:
              GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
        ),
        elevation: 0,
      ),
      body: FutureBuilder<PYQModel>(
        future: resourceDataSourceImpl.getpyq(),
        builder: (BuildContext context, AsyncSnapshot<PYQModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<Tab> tabs = [];
              List<String> category = [];
              Map<String, List<PYQModelData>> datafilter = {};
              for (var element in snapshot.data!.data!) {
                if (!category.contains(element.category?.title)) {
                  category.add(element.category!.title!);
                  tabs.add(Tab(
                    text: element.category!.title,
                  ));
                  datafilter[element.category!.title!] = [];
                }
                datafilter[element.category!.title]!.add(element);
              }
              // for (var ecategory in category) {
              //   for (var edata in snapshot.data!.data!) {
              //     if (ecategory == edata.category!.title) {
              //       print(ecategory);
              //       print(edata);
              //       datafilter[ecategory]?.add(edata);
              //     }
              //   }
              // }
              return BlocBuilder<StreamsetectCubit, StreamsetectState>(
                builder: (context, state) {
                  return DefaultTabController(
                    length: tabs.length,
                    child: Column(children: [
                      Container(
                        constraints: const BoxConstraints.expand(height: 50),
                        color: ColorResources.textWhite,
                        child: TabBar(
                          isScrollable: true,
                          controller: _tabController,
                          indicatorColor: ColorResources.buttoncolor,
                          labelColor: ColorResources.buttoncolor,
                          unselectedLabelColor:
                              ColorResources.textblack.withValues(alpha: 0.6),
                          labelStyle: GoogleFonts.notoSansDevanagari(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          tabs: tabs,
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                            controller: _tabController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: category.map((e) {
                              subcate.clear();
                              for (var element in snapshot.data!.data!) {
                                if (element.category!.title == e) {
                                  if (!subcate
                                      .contains(element.subCategory!.title)) {
                                    subcate.add(element.subCategory!.title!);
                                  }
                                }
                              }
                              return datafilter[e]!.isNotEmpty
                                  ? Align(
                                      alignment: Alignment.topCenter,
                                      child: FractionallySizedBox(
                                        widthFactor: 0.9,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: subjectwidget(
                                                    defaultData:
                                                        snapshot.data!.data!),
                                              ),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                itemCount: selectedSubject ==
                                                        'ALL'
                                                    ? datafilter[e]!.length
                                                    : datafilter[e]!
                                                        .where((element) =>
                                                            element.subCategory!
                                                                .title ==
                                                            selectedSubject)
                                                        .length,
                                                // physics: const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  var element = selectedSubject ==
                                                          'ALL'
                                                      ? datafilter[e]![index]
                                                      : datafilter[e]!
                                                          .where((element) =>
                                                              element
                                                                  .subCategory!
                                                                  .title ==
                                                              selectedSubject)
                                                          .elementAt(index);
                                                  return ResourcesContainerWidget(
                                                    resourcetype: 'pdf',
                                                    title: element.title ?? '',
                                                    uploadFile: element
                                                            .fileUrl?.fileLoc ??
                                                        '',
                                                    fileSize: element.fileUrl
                                                            ?.fileSize ??
                                                        0.toString(),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 400,
                                      child: Center(
                                        child: EmptyWidget(
                                            image: SvgImages.emptyresource,
                                            text: Preferences
                                                    .appString.noResources ??
                                                Languages.noresources),
                                      ),
                                    );
                            }).toList()),
                      )
                    ]),
                  );
                },
              );
            } else {
              return Center(
                  child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.8,
                child: ErrorWidgetapp(
                    image: SvgImages.error404, text: "Page not found"),
              )
                  //Text('Pls Refresh (or) Reopen App'),
                  );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  subjectwidget({required List<PYQModelData> defaultData}) {
    List<Widget> listsubject = [];
    for (var element in subcate) {
      listsubject.add(
        Container(
          padding: const EdgeInsets.all(2.0),
          child: ChoiceChip(
            backgroundColor: Colors.transparent,
            selectedColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: selectedSubject.contains(element)
                      ? ColorResources.buttoncolor
                      : ColorResources.gray.withValues(alpha: 0.5),
                )),
            labelStyle: GoogleFonts.notoSansDevanagari(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: selectedSubject.contains(element)
                  ? ColorResources.buttoncolor
                  : ColorResources.textblack.withValues(alpha: 0.6),
            ),
            label: Text(
              element,
            ),
            selected: selectedSubject == element,
            onSelected: (value) {
              selectedSubject = context
                  .read<StreamsetectCubit>()
                  .selectSubCat(defaultData: defaultData, selected: element);
              // safeSetState(() {
              //   selectedSubject;
              //   spLecturedata.clear();
              //   for (var element in lecturedata) {
              //     if (selectedSubject == 'ALL') {
              //       spLecturedata.add(element);
              //     } else if (element.subject!.title == selectedSubject) {
              //       spLecturedata.add(element);
              //     }
              //   }
              // });
            },
          ),
        ),
      );
    }
    return listsubject;
  }
}
