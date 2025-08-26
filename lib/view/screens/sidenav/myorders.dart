import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/myorders_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/resourcespdfwidget.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:intl/intl.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RemoteDataSourceImpl remoteDataSourceImpl = RemoteDataSourceImpl();
    analytics.logScreenView(
      screenName: "app_my_Orders_Screen",
      screenClass: "MyOrdersScreen",
    );
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: ColorResources.textblack),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text(
          Preferences.appString.myOrders ?? Languages.myOrders,
          style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
        ),
        elevation: 0,
      ),
      body: FutureBuilder<MyOrdersModel>(
          future: remoteDataSourceImpl.getMyOrder(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                if (snapshot.data!.status) {
                  List<MyOrderDataModel> ordersList = snapshot.data!.data;
                  if (ordersList.isEmpty) {
                    return EmptyWidget(
                      text: Languages.noOrders,
                      image: SvgImages.emptyCard,
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: ordersList.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _myCoursesCardWidget(
                          context,
                          ordersList[index],
                        ),
                      ),
                    );
                  }
                } else {
                  return Text(snapshot.data!.msg);
                }
              } else {
                // print(snapshot.error);
                return Center(child: SizedBox(height: MediaQuery.of(context).size.height * 0.6, width: MediaQuery.of(context).size.width * 0.8, child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found"))
                    //Text('Pls Refresh (or) Reopen App'),
                    );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Center _myCoursesCardWidget(BuildContext context, MyOrderDataModel myOrders) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        width: MediaQuery.of(context).size.width * 0.90,
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
            ),
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.54,
                    child: Text(
                      myOrders.batchName,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSansDevanagari(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    "₹${myOrders.amount}",
                    style: GoogleFonts.notoSansDevanagari(fontWeight: FontWeight.w500, fontSize: 20, color: ColorResources.textblack),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Preferences.appString.enrolldate ?? 'Enrollment Date',
                        style: GoogleFonts.notoSansDevanagari(fontSize: 12, color: ColorResources.textblack),
                      ),
                      Text(
                        '${DateFormat("dd MMM yyyy").format(DateFormat("dd-MM-yyyy").parse(myOrders.transactionDate.split(" ")[0]))} ${DateFormat.jms().format(DateFormat('HH:mm:ss').parse(myOrders.transactionDate.split(" ")[1]))}',
                        style: GoogleFonts.notoSansDevanagari(fontSize: 12, color: ColorResources.textblack),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        Preferences.appString.paymentstatus ?? 'Payment Status',
                        style: GoogleFonts.notoSansDevanagari(fontSize: 12, color: ColorResources.textblack),
                      ),
                      Text(
                        myOrders.success ? Preferences.appString.sucessfully ?? "Successfull" : Preferences.appString.failed ?? "Failed",
                        style: GoogleFonts.notoSansDevanagari(fontSize: 12, color: myOrders.success ? Colors.green : Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
              infowidget(myOrders)
            ],
          ),
        ),
      ),
      // ),
    );
  }

  Widget infowidget(MyOrderDataModel myOrders) {
    if (myOrders.success && !myOrders.isEmi && myOrders.invoice.isNotEmpty && myOrders.invoice.first.fileUrl.isNotEmpty) {
      return ResourcesContainerWidget(
        title: "Download Invoice",
        uploadFile: myOrders.invoice.first.fileUrl,
        resourcetype: "pdf",
        fileSize: "",
        localcheck: false,
      );
    } else if (myOrders.success && myOrders.isEmi) {
      return ListView.separated(
        itemCount: myOrders.invoice.length,
        itemBuilder: (context, index) {
          return ResourcesContainerWidget(
            title: "EMI-${myOrders.invoice[index].installmentNumber}",
            uploadFile: myOrders.invoice[index].fileUrl,
            resourcetype: "pdf",
            fileSize: "",
            localcheck: false,
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      );
    }
    return const SizedBox(
      height: 0,
    );
  }
}
