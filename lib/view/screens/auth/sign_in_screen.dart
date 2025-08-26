import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:sd_campus_app/features/cubit/auth/auth_cubit.dart';
import 'package:sd_campus_app/features/presentation/widgets/auth_button.dart';
import 'package:sd_campus_app/features/presentation/widgets/custom_text_field.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/view/screens/auth/otp_verification_screen.dart';
import 'package:sd_campus_app/view/screens/auth/request_logout_screen.dart';
import 'package:sd_campus_app/view/screens/contactus.dart';
import 'package:sd_campus_app/view/screens/home.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  List<Widget> bannerList = [];

  @override
  void dispose() {
    numberController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  late Future<List<Widget>> getBanner;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // Preferences.checkLocationPermission(context);
    // getBanner = AuthController().getBanner();
    super.initState();
  }

  // bool _isValidEmail(String email) {
  //   // Regular expression to validate email
  //   const pattern = r'^\s*[\w\-\.\+]+@[a-zA-Z\d\-.]+\.[a-zA-Z]+\s*$';
  //   final regex = RegExp(pattern);
  //   return regex.hasMatch(email);
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Semantics(
        label: "sign in screen",
        child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    // print(state);
                    Preferences.onLoading(context);

                    if (state is LoginSuccess) {
                      // numberController.clear();
                      // passwordController.clear();
                      SharedPreferenceHelper.setString(Preferences.dateoflogin, DateTime.now().toString().split(' ')[0]);
                      Preferences.hideDialog(context);
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => OtpVerificationScreen(
                            bannerList: bannerList,
                            userNumber: numberController.text,
                            optlength: state.optlength,
                          ),
                        ),
                      );
                    }
                    if (state is ErrorSnackbar) {
                      Preferences.hideDialog(context);
                      Preferences.hideDialog(context);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: ColorResources.buttoncolor,
                          margin: const EdgeInsets.all(8.0),
                          behavior: SnackBarBehavior.floating,
                          content: Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: ColorResources.textWhite,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  state.msg,
                                  style: TextStyle(
                                    color: ColorResources.textWhite,
                                  ),
                                ),
                              )
                            ],
                          )));
                    }
                    // if (state is UnVerifiedNumber) {
                    //   numberController.clear();
                    //   passwordController.clear();
                    //   Preferences.hideDialog(context);
                    //   Navigator.push(
                    //     context,
                    //     CupertinoPageRoute(
                    //       builder: (context) => OtpVerificationScreen(
                    //         bannerList: bannerList,
                    //         userNumber: state.phoneNumber,
                    //       ),
                    //     ),
                    //   );
                    // }
                    if (state is ErrorAuth) {
                      Preferences.hideDialog(context);
                    }
                    if (state is RequestToLogout) {
                      Preferences.hideDialog(context);
                      Preferences.hideDialog(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => RequestLogoutScreen(
                            userEmail: numberController.text,
                            bannerList: bannerList,
                          ),
                        ),
                      );
                    }
                    if (state is GoogleAuthRequestToLogout) {
                      Preferences.hideDialog(context);
                      Preferences.hideDialog(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => RequestLogoutScreen(
                            userEmail: state.email,
                            bannerList: bannerList,
                          ),
                        ),
                      );
                    }
                    if (state is GoogleSuccess) {
                      // print(state);
                      Preferences.hideDialog(context);
                      SharedPreferenceHelper.setBoolean(Preferences.isloggedin, true);
                      SharedPreferenceHelper.setString(Preferences.dateoflogin, DateTime.now().toString().split(' ')[0]);
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const HomeScreen(),
                          ));
                    }
                    // if (state is GooglePhoneNumberVerification) {
                    //   Preferences.hideDialog(context);
                    //   // print(state);
                    //   Navigator.push(
                    //     context,
                    //     CupertinoPageRoute(
                    //       builder: (context) => MobileNumberScreen(images: bannerList),
                    //     ),
                    //   );
                    // }
                  },
                  builder: (context, state) {
                    return Form(
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
                            height: 10,
                          ),
                          Container(
                            constraints: const BoxConstraints(maxHeight: 400),
                            child: FractionallySizedBox(
                              widthFactor: 0.85,
                              child: Column(
                                children: [
                                  const Spacer(),
                                  Text.rich(
                                    semanticsLabel: "Welcome \n to SD Campus",
                                    TextSpan(children: [
                                      TextSpan(
                                        text: "Welcome \n",
                                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                              fontSize: 24,
                                              color: ColorResources.buttoncolor.withValues(alpha: 0.75),
                                              height: 2,
                                            ),
                                      ),
                                      TextSpan(
                                        text: ' to SD Campus',
                                        style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                              fontSize: 24,
                                              color: ColorResources.textblack.withValues(alpha: 0.75),
                                            ),
                                      ),
                                    ]),
                                    textAlign: TextAlign.center,
                                  ),
                                  // Text(
                                  //   'Login',
                                  //   style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                  //         fontSize: 28,
                                  //       ),
                                  // ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    margin: const EdgeInsets.symmetric(vertical: 14),
                                    child: CustomTextFilled(
                                      onChanged: (value) => _formKey.currentState!.validate(),
                                      hintText: 'Mobile No.',
                                      textController: numberController,
                                      validator: ValidationBuilder().required().phone().maxLength(10).minLength(10).build(),
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
                                  // PasswordTextFilled(
                                  //   onChanged: (value) => _formKey.currentState!.validate(),
                                  //   textEditingController: passwordController,
                                  //   validator: ValidationBuilder().required().minLength(8).regExp(RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'), 'valid password ex:Testing@1').maxLength(50).build(),
                                  // ),9
                                  // Container(
                                  //   margin: const EdgeInsets.symmetric(vertical: 14),
                                  //   alignment: Alignment.centerRight,
                                  //   child: InkWell(
                                  //     onTap: () {
                                  //       Navigator.push(
                                  //         context,
                                  //         CupertinoPageRoute(
                                  //           builder: (context) => const ResetPasswordScreen(),
                                  //         ),
                                  //       );
                                  //     },
                                  //     child: Text(
                                  //       'Forgot password?',
                                  //       style: GoogleFonts.notoSansDevanagari(
                                  //         color: ColorResources.buttoncolor,
                                  //         fontSize: 14,
                                  //         fontWeight: FontWeight.w500,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AuthButton(
                                          text: 'Continue',
                                          onPressed: () {
                                            if (_formKey.currentState!.validate()) {
                                              _loginButton();
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text.rich(
                                    textAlign: TextAlign.center,
                                    TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'By signing up, you agree to our ',
                                          style: TextStyle(
                                            color: ColorResources.textBlackSec,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Terms of Service ',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              launchUrl(Uri.parse("https://www.sdcampus.com/terms-and-conditions"));
                                            },
                                          style: TextStyle(
                                            color: ColorResources.buttoncolor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'and ',
                                          style: TextStyle(
                                            color: ColorResources.textBlackSec,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            height: 0,
                                          ),
                                        ),
                                        TextSpan(
                                          text: 'Privacy Policy ',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              launchUrl(Uri.parse("https://www.sdcampus.com/privacy-policy"));
                                            },
                                          style: TextStyle(
                                            color: ColorResources.buttoncolor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  // SizedBox(
                                  //   height: MediaQuery.of(context).size.height * 0.05,
                                  // ),
                                  // const Row(
                                  //   children: [
                                  //     Expanded(
                                  //       child: Divider(
                                  //         thickness: 2,
                                  //       ),
                                  //     ),
                                  //     Text(
                                  //       " Or Sign in with ",
                                  //     ),
                                  //     Expanded(
                                  //         child: Divider(
                                  //       thickness: 2,
                                  //     )),
                                  //   ],
                                  // ),
                                  // SizedBox(
                                  //   height: MediaQuery.of(context).size.height * 0.02,
                                  // ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     GestureDetector(
                                  //       onTap: () {
                                  //         BlocProvider.of<AuthCubit>(context).googleAuth();
                                  //       },
                                  //       child: Container(
                                  //         height: 50,
                                  //         width: 50,
                                  //         padding: const EdgeInsets.all(5),
                                  //         decoration: BoxDecoration(
                                  //           border: Border.all(color: Colors.grey),
                                  //           borderRadius: BorderRadius.circular(100),
                                  //         ),
                                  //         child: Image.network(SvgImages.google),
                                  //       ),
                                  //     ),
                                  //     const SizedBox(
                                  //       width: 10,
                                  //     ),
                                  //     Platform.isIOS
                                  //         ? Container(
                                  //             height: 50,
                                  //             width: 50,
                                  //             padding: const EdgeInsets.all(5),
                                  //             decoration: BoxDecoration(
                                  //               border: Border.all(color: Colors.grey),
                                  //               borderRadius: BorderRadius.circular(100),
                                  //             ),
                                  //             child: Image.network(SvgImages.apple),
                                  //           )
                                  //         : Container()
                                  //   ],
                                  // ),
                                  // SizedBox(
                                  //   height: MediaQuery.of(context).size.height * 0.02,
                                  // ),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: [
                                  //     const Text(
                                  //       'Create an account?',
                                  //     ),
                                  //     TextButton(
                                  //       onPressed: () {
                                  //         Navigator.push(
                                  //             context,
                                  //             CupertinoPageRoute(
                                  //               builder: (context) => SignUpScreen(
                                  //                 bannerList: bannerList,
                                  //               ),
                                  //             ));
                                  //       },
                                  //       child: Text(
                                  //         ' Register',
                                  //         style: TextStyle(
                                  //           color: ColorResources.buttoncolor,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _loginButton() async {
    var body = {
      "user_phone": numberController.text.trim().toLowerCase(),
      // "password": passwordController.text,
    };
    Preferences.onLoading(context);
    BlocProvider.of<AuthCubit>(context).loginUser(body);
  }
}
