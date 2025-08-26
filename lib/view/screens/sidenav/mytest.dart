import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/models/Test_series/testseriesdetails.dart';
import 'package:sd_campus_app/util/appstring.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/view/screens/sidenav/test_screen/test_detail_screen.dart';
import 'package:intl/intl.dart';

class TestSeries extends StatefulWidget {
  final String id;
  const TestSeries({
    super.key,
    required this.id,
  });

  @override
  State<TestSeries> createState() => _TestSeriesState();
}

class _TestSeriesState extends State<TestSeries> {
  late Future<TestSeriesDetails> mytestsData;
  RemoteDataSourceImpl remoteDataSourceImpl = RemoteDataSourceImpl();
  @override
  void initState() {
    // print(widget.id);
    mytestsData = remoteDataSourceImpl.getMyTestsdetails(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TestSeriesDetails>(
        future: mytestsData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              TestSeriesDetails? myTestsModel = snapshot.data;
              return Scaffold(
                  appBar: AppBar(
                    backgroundColor: ColorResources.textWhite,
                    iconTheme: IconThemeData(color: ColorResources.textblack),
                    title: Text(
                      "TestSeries",
                      //Languages.myTestseries,
                      style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack, fontWeight: FontWeight.bold),
                    ),
                  ),
                  body: myTestsModel!.data!.isNotEmpty ? testbody(myTestsModel) : EmptyWidget(image: SvgImages.emptytestseries, text: Languages.notestseries));
            } else {
              return Scaffold(
                body: Center(child: SizedBox(height: MediaQuery.of(context).size.height * 0.6, width: MediaQuery.of(context).size.width * 0.8, child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found"))
                    //Text('Pls Refresh (or) Reopen App'),
                    ),
              );
            }
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

  Widget testbody(TestSeriesDetails response) {
    return ListView.builder(
        itemCount: response.data!.length,
        itemBuilder: (context, index) {
          // print(response.data![index].testTitle);
          return testcard(response.data![index]);
        });
  }

  Widget testcard(TestSeriesDetailsData carddata) {
    return Container(
      height: 140,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [
        BoxShadow(color: Colors.grey.shade300, spreadRadius: 2, blurRadius: 8, offset: const Offset(2, 3)),
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    border: carddata.isAttempted!
                        ? Border(
                            left: BorderSide(
                              color: ColorResources.buttoncolor,
                              style: BorderStyle.solid,
                            ),
                          )
                        : const Border(
                            left: BorderSide.none,
                          ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _iconTextWidget('${carddata.noOfQuestions} ${Languages.questions}', Icons.menu),
                      _iconTextWidget('${carddata.totalMarkes} ${Languages.marks}', Icons.verified_outlined),
                      _iconTextWidget('${carddata.duration} Min', Icons.alarm)
                    ],
                  ),
                )),
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: carddata.isAttempted!
                      ? Border(
                          left: BorderSide(
                            color: ColorResources.buttoncolor,
                          ),
                        )
                      : const Border(
                          left: BorderSide.none,
                        ),
                  color: ColorResources.borderColor.withValues(alpha: 0.2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Text(
                            carddata.testTitle!,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.notoSansDevanagari(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: ColorResources.textblack,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.18,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                          decoration: BoxDecoration(color: const Color(0xFFF6CBB4), borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            carddata.testCode!,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Color(0xFF7C3B33),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              carddata.startDate!,
                              style: TextStyle(
                                color: ColorResources.gray,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              '${Languages.score}: ${carddata.score}',
                              style: GoogleFonts.notoSansDevanagari(
                                color: ColorResources.gray,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            if (DateFormat('yyyy-MM-dd').parse(carddata.startDate!).difference(DateTime.now()).inDays <= 0) {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => TestDetailsScreen(
                                    data: carddata,
                                  ),
                                ),
                              );
                            } else {
                              flutterToast('test start on ${carddata.startDate!}');
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: DateFormat('yyyy-MM-dd').parse(carddata.startDate!).difference(DateTime.now()).inDays <= 0 ? ColorResources.buttoncolor : ColorResources.gray,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  //'Continue'
                                  Languages.continueText,
                                  style: GoogleFonts.notoSansDevanagari(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600),
                                ), // <-- Text
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: ColorResources.textWhite.withValues(alpha: 0.3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _iconTextWidget(String text, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
        ),
        const SizedBox(width: 3),
        Text(
          text,
          style: GoogleFonts.notoSansDevanagari(fontSize: Fontsize().h5),
        )
      ],
    );
  }
}
