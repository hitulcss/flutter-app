import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/auth_button.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/exam_category.dart';

class ReferAuthScreen extends StatefulWidget {
  const ReferAuthScreen({super.key});

  @override
  State<ReferAuthScreen> createState() => _ReferAuthScreenState();
}

class _ReferAuthScreenState extends State<ReferAuthScreen> {
  final TextEditingController _refercodecontroller = TextEditingController();
  @override
  void dispose() {
    _refercodecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            CachedNetworkImage(
                placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                imageUrl: SvgImages.referral),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _refercodecontroller,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: '   HEFDSADSH  ',
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: AuthButton(
                          onPressed: () {
                            if (_refercodecontroller.text.isEmpty) {
                              flutterToast('Please Enter Referal Code');
                            } else {
                              Preferences.onLoading(context);
                              RemoteDataSourceImpl().alpplycoupancodere(referalcode: _refercodecontroller.text.toUpperCase()).then((value) {
                                Preferences.hideDialog(context);
                                flutterToast(value.msg);
                                if (value.status) {
                                  Navigator.pushReplacement(
                                    context,
                                    CupertinoPageRoute(builder: (context) => ExamCategoryScreen()),
                                  );
                                }
                              });
                            }
                          },
                          text: 'Verify',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(builder: (context) => const ExamCategoryScreen()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(color: ColorResources.buttoncolor),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: ColorResources.buttoncolor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
