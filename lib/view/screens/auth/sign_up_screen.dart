// // ignore_for_file: use_build_context_synchronously

// import 'dart:io';

// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:form_validator/form_validator.dart';
// import 'package:sd_campus_app/features/cubit/auth/auth_cubit.dart';
// import 'package:sd_campus_app/features/presentation/widgets/auth_button.dart';
// import 'package:sd_campus_app/features/presentation/widgets/custom_text_field.dart';
// import 'package:sd_campus_app/util/color_resources.dart';
// import 'package:sd_campus_app/util/images_file.dart';
// import 'package:sd_campus_app/util/prefconstatnt.dart';
// import 'package:sd_campus_app/util/preference.dart';
// import 'package:sd_campus_app/view/screens/auth/otp_verification_screen.dart';
// import 'package:sd_campus_app/view/screens/contactus.dart';
// import 'package:sd_campus_app/view/screens/home.dart';

// import 'mobile_number_screen.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({super.key, required this.bannerList});
//   final List<Widget> bannerList;

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController numberController = TextEditingController();
//   TextEditingController nameController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     emailController.dispose();
//     numberController.dispose();
//     nameController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: BlocConsumer<AuthCubit, AuthState>(listener: (context, state) {
//           if (state is RegisterSuccess) {
//             Preferences.hideDialog(context);
//             Navigator.push(
//               context,
//               CupertinoPageRoute(
//                 builder: (context) => OtpVerificationScreen(bannerList: widget.bannerList, userNumber: numberController.text),
//               ),
//             );
//           }
//           if (state is GoogleSuccess) {
//             Navigator.push(
//               context,
//               CupertinoPageRoute(builder: (context) => const HomeScreen()),
//             );
//           }
//           if (state is ErrorAuth) {
//             Preferences.hideDialog(context);
//           }
//           if (state is GooglePhoneNumberVerification) {
//             Navigator.push(
//               context,
//               CupertinoPageRoute(
//                 builder: (context) => MobileNumberScreen(images: widget.bannerList),
//               ),
//             );
//           }
//         }, builder: (context, state) {
//           if (state is LoadingAuth) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           return SingleChildScrollView(
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   CustomPaint(
//                     painter: MyPainter(),
//                     child: SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       height: MediaQuery.of(context).size.height * 0.25,
//                       child: Center(
//                         child: Image.asset(
//                           SvgImages.logo,
//                           height: 110,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   FractionallySizedBox(
//                     widthFactor: 0.85,
//                     child: Column(
//                       children: [
//                         Text(
//                           'Create Account',
//                           style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 28),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Container(
//                           margin: const EdgeInsets.symmetric(vertical: 3),
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: CustomTextFilled(
//                             onChanged: (value) => _formKey.currentState!.validate(),
//                             hintText: 'Email Id',
//                             textController: emailController,
//                             validator: ValidationBuilder().required().email().build(),
//                           ),
//                         ),
//                         Container(
//                           margin: const EdgeInsets.symmetric(vertical: 3),
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: CustomTextFilled(
//                             onChanged: (value) => _formKey.currentState!.validate(),
//                             hintText: 'Mobile No.',
//                             validator: ValidationBuilder().required().phone().maxLength(10).minLength(10).build(),
//                             textController: numberController,
//                           ),
//                         ),
//                         Container(
//                           margin: const EdgeInsets.symmetric(vertical: 3),
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: CustomTextFilled(
//                             onChanged: (value) => _formKey.currentState!.validate(),
//                             hintText: 'Full name',
//                             textController: nameController,
//                             validator: ValidationBuilder().required().build(),
//                           ),
//                         ),
//                         Container(
//                           margin: const EdgeInsets.symmetric(vertical: 3),
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: PasswordTextFilled(
//                             onChanged: (value) => _formKey.currentState!.validate(),
//                             textEditingController: passwordController,
//                             validator: ValidationBuilder().required().minLength(8).regExp(RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'), 'valid password ex:Testing@1').maxLength(50).build(),
//                           ),
//                         ),
//                         SizedBox(
//                           width: MediaQuery.of(context).size.width * 0.60,
//                           child: AuthButton(
//                             text: 'Sign up',
//                             onPressed: () {
//                               if (_formKey.currentState!.validate()) {
//                                 _registerButton();
//                               }
//                             },
//                           ),
//                         ),
//                         // SizedBox(
//                         //   height: MediaQuery.of(context).size.height * 0.02,
//                         // ),
//                         // const Row(
//                         //   children: [
//                         //     Expanded(
//                         //         child: Divider(
//                         //       thickness: 2,
//                         //     )),
//                         //     Text(
//                         //       "  Or Register with  ",
//                         //     ),
//                         //     Expanded(
//                         //       child: Divider(
//                         //         thickness: 2,
//                         //       ),
//                         //     ),
//                         //   ],
//                         // ),
//                         // SizedBox(
//                         //   height: MediaQuery.of(context).size.height * 0.02,
//                         // ),
//                         // Row(
//                         //   mainAxisAlignment: MainAxisAlignment.center,
//                         //   children: [
//                         //     GestureDetector(
//                         //       onTap: () {
//                         //         BlocProvider.of<AuthCubit>(context).googleAuth();
//                         //       },
//                         //       child: Container(
//                         //         height: 50,
//                         //         width: 50,
//                         //         padding: const EdgeInsets.all(5),
//                         //         decoration: BoxDecoration(
//                         //           border: Border.all(color: Colors.grey),
//                         //           borderRadius: BorderRadius.circular(100),
//                         //         ),
//                         //         child: Image.network(SvgImages.google),
//                         //       ),
//                         //     ),
//                         //     const SizedBox(
//                         //       width: 10,
//                         //     ),
//                         //     Platform.isIOS
//                         //         ? Container(
//                         //             height: 50,
//                         //             width: 50,
//                         //             padding: const EdgeInsets.all(5),
//                         //             decoration: BoxDecoration(
//                         //               border: Border.all(color: Colors.grey),
//                         //               borderRadius: BorderRadius.circular(100),
//                         //             ),
//                         //             child: Image.network(SvgImages.apple),
//                         //           )
//                         //         : Container()
//                         //   ],
//                         // ),
//                         // SizedBox(
//                         //   height: MediaQuery.of(context).size.height * 0.02,
//                         // ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text(
//                               'I have an account. ',
//                             ),
//                             TextButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Text(
//                                   'Login',
//                                   style: TextStyle(
//                                     color: ColorResources.buttoncolor,
//                                   ),
//                                 ))
//                           ],
//                         ),
//                         SizedBox(
//                           height: MediaQuery.of(context).size.height * 0.02,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   _registerButton() async {
//     DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//     AndroidDeviceInfo? androidDeviceInfo;
//     IosDeviceInfo? iOSDeviceInfo;
//     if (Platform.isAndroid) {
//       androidDeviceInfo = await deviceInfo.androidInfo;
//     } else if (Platform.isIOS) {
//       iOSDeviceInfo = await deviceInfo.iosInfo;
//     }
//     var body = {
//       "FullName": nameController.text,
//       "email": emailController.text.toLowerCase(),
//       "mobileNumber": numberController.text,
//       "password": passwordController.text,
//       "deviceConfig": androidDeviceInfo!.id.isNotEmpty && Platform.isAndroid ? androidDeviceInfo.id : iOSDeviceInfo!.identifierForVendor,
//       "deviceName": androidDeviceInfo.brand.isNotEmpty && Platform.isAndroid ? androidDeviceInfo.brand : iOSDeviceInfo!.model,
//     };
//     // print(nameController.text + numberController.text);
//     SharedPreferenceHelper.setString(Preferences.name, nameController.text);
//     SharedPreferenceHelper.setString(Preferences.phoneNUmber, numberController.text);
//     BlocProvider.of<AuthCubit>(context).registerUser(body);
//   }
// }
