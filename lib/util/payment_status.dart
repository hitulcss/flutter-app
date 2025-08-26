import 'package:flutter/material.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/view/screens/e_book/my_e_book/myebookscreen.dart';
import 'package:sd_campus_app/view/screens/home.dart';
import 'package:sd_campus_app/view/screens/sidenav/mycourses.dart';
import 'package:sd_campus_app/view/screens/store/store_order.dart';

paymentstatus({required BuildContext context, required bool ispaided, required String paymentfor}) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) => Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.close,
              ),
            ),
          ),
          ispaided
              ? Image.asset(
                  SvgImages.paymentsucess,
                  height: 200,
                )
              : Image.asset(
                  SvgImages.paymentfailed,
                  height: 200,
                ),
          ispaided
              ? Column(
                  children: [
                    Text(
                      paymentfor == "course"
                          ? 'You have successfully purchased this Batch'
                          : paymentfor == "store"
                              ? "You have successfully purchased this Product"
                              : paymentfor == "ebook"
                                  ? "You have successfully purchased the E-Book"
                                  : "You have successfully purchased the Test Series",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorResources.textblack,
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      paymentfor == "course"
                          ? 'You can find this batch on My Courses Section'
                          : paymentfor == "store"
                              ? "You can find this Product on My order Page"
                              : paymentfor == "ebook"
                                  ? "You can find this E-Book on My E-Book Section"
                                  : "You can find this Testseries on My Testseries Section",
                      style: TextStyle(
                        color: ColorResources.textBlackSec,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                )
              : Text(
                  "Opps ! \nPayment failed, Please try Again",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorResources.textblack,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
          const SizedBox(
            height: 10,
          ),
          ispaided
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorResources.buttoncolor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (paymentfor == "course") {
                      Navigator.popUntil(
                        context,
                        (route) => route.isFirst,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyCoursesScreen(),
                        ),
                      );
                    } else if (paymentfor == "store") {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const StoreOrderScreen(),
                        ),
                      );
                    } else if (paymentfor == "ebook") {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const MyEbookScreen(),
                        ),
                      );
                    } else {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(
                            index: 0,
                          ),
                        ),
                        (route) => false,
                      );
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Text(
                      'Let’s Start',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    ),
  );
}
