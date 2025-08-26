// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/auth/auth_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String name = '';
  String email = '';
  String phoneNumber = '';
  String address = 'Address';
  String profileImage = SvgImages.avatar;

  final authDataSourceImpl = AuthDataSourceImpl();

  final TextEditingController _emailcontroller = TextEditingController();

  @override
  void initState() {
    analytics.logScreenView(screenName: "app_edit_profile", screenClass: "EditProfileScreen");
    name = SharedPreferenceHelper.getString(Preferences.name)!;
    _emailcontroller.text = SharedPreferenceHelper.getString(Preferences.email)!;
    phoneNumber = SharedPreferenceHelper.getString(Preferences.phoneNUmber)!;
    address = SharedPreferenceHelper.getString(Preferences.address)!;
    profileImage = SharedPreferenceHelper.getString(Preferences.profileImage)!;
    super.initState();
  }

  bool isEnable = true;
  @override
  void dispose() {
    _emailcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: ColorResources.textWhite,
          elevation: 0,
          iconTheme: IconThemeData(
            color: ColorResources.textblack,
          ),
          title: Text(
            Languages.personalInformation,
            style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
          ),
          actions: [
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                size: 30,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  textStyle: GoogleFonts.notoSansDevanagari(
                    color: ColorResources.buttoncolor,
                  ),
                  child: const Text(
                    "Delete Account",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 1) {
                  analytics.logEvent(name: "app_delete_account_request");
                  deleteaccount();
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 70.0,
                        backgroundImage: CachedNetworkImageProvider(profileImage),
                        backgroundColor: Colors.grey,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: InkWell(
                          onTap: getImage,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(color: ColorResources.buttoncolor, borderRadius: BorderRadius.circular(100)),
                            child: Icon(
                              Icons.mode,
                              size: 25,
                              color: ColorResources.textWhite,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2),
                  child: IntrinsicWidth(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            scrollPadding: EdgeInsets.zero,
                            onChanged: (value) {
                              name = value;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9 ?!@#\$%^&*/\n(),]"))
                            ],
                            keyboardType: TextInputType.name,
                            textAlign: TextAlign.center,
                            enabled: isEnable,
                            initialValue: name,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                            ),
                            style: GoogleFonts.notoSansDevanagari(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            safeSetState(() {
                              isEnable = !isEnable;
                              // print(isEnable);
                            });
                          },
                          child: Text(
                            Preferences.appString.edit ?? "Edit",
                            style: const TextStyle(color: Colors.blue, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SelectableText(SharedPreferenceHelper.getString(Preferences.enrollId) ?? ''),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(Languages.mobile),
                      Container(
                        margin: const EdgeInsets.only(top: 5),
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: ColorResources.gray.withValues(alpha: 0.2),
                          border: Border.all(color: ColorResources.gray, width: 1.0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '+91 $phoneNumber',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(Languages.email),
                      TextFormField(
                        controller: _emailcontroller,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: ColorResources.gray, width: 1.0),
                          ),
                          hintText: email,
                        ),
                      ),
                      // Container(
                      //   margin: const EdgeInsets.only(top: 5),
                      //   height: 60,
                      //   padding: const EdgeInsets.symmetric(horizontal: 10),
                      //   alignment: Alignment.centerLeft,
                      //   decoration: BoxDecoration(
                      //     color: ColorResources.gray.withValues(alpha:0.2),
                      //     border: Border.all(color: ColorResources.gray, width: 1.0),
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: Text(email),
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(Languages.address),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: TextFormField(
                          onChanged: (value) {
                            address = value;
                          },
                          maxLines: 3,
                          initialValue: address,
                          keyboardType: TextInputType.streetAddress,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: ColorResources.gray, width: 1.0),
                            ),
                            hintText: address,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.80,
                        decoration: BoxDecoration(color: ColorResources.buttoncolor, borderRadius: BorderRadius.circular(14)),
                        child: TextButton(
                          onPressed: () async {
                            analytics.logEvent(name: "app_profile_update");
                            if (name.trim().isNotEmpty && _emailcontroller.text.trim().isNotEmpty && address.trim().isNotEmpty) {
                              try {
                                Preferences.onLoading(context);
                                Response response = await authDataSourceImpl.updateUserDetails(name.trim(), _emailcontroller.text.trim(), address);
                                if (response.statusCode == 200) {
                                  SharedPreferenceHelper.setBoolean(Preferences.isNameAdded, name.trim().isEmpty ? false : true);
                                  SharedPreferenceHelper.setString(
                                    Preferences.name,
                                    name,
                                  );
                                  SharedPreferenceHelper.setString(
                                    Preferences.email,
                                    _emailcontroller.text,
                                  );
                                  SharedPreferenceHelper.setString(
                                    Preferences.address,
                                    address,
                                  );
                                  flutterToast(response.data['msg']);
                                  Preferences.hideDialog(context);
                                  Navigator.of(context).pop();
                                } else {
                                  Preferences.hideDialog(context);
                                  flutterToast(response.data['msg']);
                                }
                              } catch (error) {
                                Preferences.hideDialog(context);
                                flutterToast('Server Error');
                              }
                            } else {
                              flutterToast('Please fill all the fields');
                            }
                          },
                          child: Text(
                            Languages.saveChanges,
                            style: GoogleFonts.notoSansDevanagari(color: ColorResources.textWhite, fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        Response response = await authDataSourceImpl.updateUserProfilePhoto(image);
        if (response.statusCode == 200) {
          await SharedPreferenceHelper.setString(
            Preferences.profileImage,
            response.data['data']['fileUploadedLocation'],
          );
          // var Image = SharedPreferenceHelper.getString(Preferences.profileImage)!;
          safeSetState(() {
            profileImage = response.data['data']['fileUploadedLocation'];
          });
          flutterToast(response.data['msg']);
        } else {
          flutterToast(response.data['msg']);
        }
      }
    } catch (error) {
      log(error.toString());
      flutterToast('Server Error');
    }
  }

  Future deleteaccount() async {
    Preferences.onLoading(context);
    try {
      Response response = await authDataSourceImpl.accountDelete();
      if (response.statusCode == 200) {
        if (response.data['status'] = true) {
          flutterToast(response.data["msg"]);
          safeSetState(() {
            Preferences.hideDialog(context);
          });
          SharedPreferenceHelper.clearPref();
          Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        }
      }
    } catch (error) {
      flutterToast('Server Error');
      Preferences.hideDialog(context);
    }
  }
}
