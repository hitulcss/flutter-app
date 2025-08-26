import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/view/screens/home.dart';
import 'package:sd_campus_app/view/screens/sidenav/mycourses.dart';
import 'package:sd_campus_app/view/screens/store/store_order.dart';

class PaymentScreen extends StatefulWidget {
  final String paymentfor;
  final bool status;
  const PaymentScreen({super.key, required this.paymentfor, required this.status});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).popUntil((route) => route.isFirst);
      widget.paymentfor == "course"
          ? Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyCoursesScreen(),
              ),
            )
          : widget.paymentfor == "store"
              ? Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const StoreOrderScreen(),
                  ),
                )
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(
                      index: 2,
                    ),
                  ),
                );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: widget.status ? Image.asset(SvgImages.paymentsucess) : Image.asset(SvgImages.paymentfailed)),
    );
  }
}
