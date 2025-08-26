// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/auth/auth_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/auth_button.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/view/screens/auth/refer_auth_screen.dart';
import 'package:sd_campus_app/view/screens/contactus.dart';
import 'package:sd_campus_app/view/screens/exam_category.dart';
import 'package:sd_campus_app/view/screens/home.dart';

class NameScreen extends StatefulWidget {
  final bool tohome;
  const NameScreen({
    super.key,
    required this.tohome,
  });

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    // Permission.location.request().then((value) {
    //   if (value == PermissionStatus.denied) {
    //     Preferences.checkLocationPermission(context);
    //   }
    // });
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Column(
        children: [
          CustomPaint(
            painter: MyPainter(),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Center(
                child: Image.asset(
                  SvgImages.logo,
                  height: 110,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Enter Your Name',
                  style: TextStyle(
                    color: ColorResources.textBlackSec,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: "Name",
                      hintText: "Enter Your Name",
                    ),
                    validator: ValidationBuilder().required().build(),
                    // onChanged: (value) => _formKey.currentState!.validate(),
                    // hintText: 'Mobile No.',
                    // validator: ValidationBuilder().required().phone().maxLength(10).minLength(10).build(),
                    //  (value) {
                    //   if (value == null || value.trim().isEmpty) {
                    //     return 'Phone is required.';
                    //   } else if (!_isValidEmail(value.trim())) {
                    //     return 'Please enter a valid email address.';
                    //   }
                    //   return null;
                    // },
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AuthButton(
                        text: 'Save',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            updateuserdata();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  // Future<String> getCurrentLocation(BuildContext context) async {
  //   try {
  //     // Request permission to access the device's location
  //     bool status = await Preferences.checkLocationPermission(context);
  //     if (!status) {
  //       return await RemoteDataSourceImpl().getaddressfromip() ?? "";
  //     } else {
  //       // Retrieve the current position
  //       Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high,
  //       );

  //       // Reverse geocode the coordinates to obtain the address
  //       List<Placemark> placemarks = await placemarkFromCoordinates(
  //         position.latitude,
  //         position.longitude,
  //       );

  //       Placemark place = placemarks.first;

  //       // Access the desired location details
  //       String address = place.street!;
  //       String city = place.locality!;
  //       String state = place.administrativeArea!;
  //       String country = place.country!;
  //       String postalCode = place.postalCode!;

  //       // Use the location details as desired
  //       print('Address: ${place.isoCountryCode}');
  //       print('Address: ${place.subAdministrativeArea}');
  //       print('Address: ${place.subThoroughfare}');
  //       print('Address: ${place.name}');
  //       print('Address: $address');
  //       print('Address: ${place.thoroughfare}');
  //       print('Address: ${place.subLocality}');
  //       print('City: $city');
  //       print('State: $state');
  //       print('Country: $country');
  //       print('Postal Code: $postalCode');
  //       return "$city,$state,$country,$postalCode";
  //     }
  //   } catch (e) {
  //     // Handle any errors that occur during location retrieval or geocoding
  //     print(e);
  //     return "";
  //   }
  // }

  updateuserdata() async {
    analytics.logEvent(name: "app_profile_update");
    try {
      Preferences.onLoading(context);
      Response response = await AuthDataSourceImpl().updateUserDetails(nameController.text, "user@gmail.com", "");
      if (response.statusCode == 200) {
        SharedPreferenceHelper.setBoolean(Preferences.isNameAdded, true);
        SharedPreferenceHelper.setString(
          Preferences.name,
          nameController.text,
        );
        SharedPreferenceHelper.setString(
          Preferences.email,
          "user@gmail.com",
        );
        SharedPreferenceHelper.setString(
          Preferences.address,
          "",
        );
        flutterToast(response.data['msg']);
        Navigator.of(context).pop();
        SharedPreferenceHelper.getBoolean(Preferences.isnewUser)
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReferAuthScreen(),
                ))
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => widget.tohome ? const HomeScreen() : const ExamCategoryScreen(),
                ));
      } else {
        Preferences.hideDialog(context);
        flutterToast(response.data['msg']);
      }
    } catch (error) {
      Preferences.hideDialog(context);
      flutterToast('Server Error');
    }
  }
}
