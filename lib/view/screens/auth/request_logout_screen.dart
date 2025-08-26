import 'package:carousel_slider/carousel_slider.dart' as carousel_slider;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sd_campus_app/features/cubit/auth/auth_cubit.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';

class RequestLogoutScreen extends StatefulWidget {
  const RequestLogoutScreen({super.key, required this.userEmail, required this.bannerList});
  final String userEmail;
  final List<Widget> bannerList;

  @override
  State<RequestLogoutScreen> createState() => _RequestLogoutScreenState();
}

class _RequestLogoutScreenState extends State<RequestLogoutScreen> {
  TextEditingController message = TextEditingController();
  @override
  void dispose() {
    message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  carousel_slider.CarouselSlider(
                    items: widget.bannerList,
                    options: carousel_slider.CarouselOptions(
                      height: 250,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration: const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  BlocConsumer<AuthCubit, AuthState>(builder: (context, state) {
                    // print(state);
                    if (state is RequestLogoutSuccess) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Thank You!',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(height: 20),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40.0),
                            child: Text(
                              "We have sent your request to admin, we will notify you as soon as the admin approve your request",
                            ),
                          ),
                        ],
                      );
                    } else {
                      return _bodyWidget(context);
                    }
                  }, listener: (context, state) {
                    if (state is ErrorAuth) {
                      Preferences.hideDialog(context);
                    }
                    if (state is LoadingAuth) {
                      Preferences.onLoading(context);
                    }
                    if (state is RequestLogoutSuccess) {
                      Preferences.hideDialog(context);
                      Preferences.hideDialog(context);
                      Preferences.hideDialog(context);
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.pop(context);
                      });
                    }
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column _bodyWidget(BuildContext context) {
    return Column(
      children: [
        Text(
          'Dear User',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'You have tried to login from another device.',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        Text(
          "That's why you are here.",
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const Text(
          'Please request to admin for allowing this device',
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.3,
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: ColorResources.textblack,
            ),
          ),
          child: TextField(
            controller: message,
            maxLines: null,
            decoration: const InputDecoration(border: InputBorder.none, hintText: 'Request to Admin! Type your Message'),
          ),
        ),
        InkWell(
          onTap: () {
            // print(message.text);
            // print('*' * 200);
            if (message.text.isNotEmpty) {
              BlocProvider.of<AuthCubit>(context).requestLogout(widget.userEmail, message.text);
            } else {
              flutterToast('Please enter request message');
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(color: ColorResources.buttoncolor, borderRadius: BorderRadius.circular(14)),
            alignment: Alignment.center,
            child: Text(
              'Send Request',
              style: TextStyle(color: ColorResources.textWhite, fontWeight: FontWeight.w800, fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}
