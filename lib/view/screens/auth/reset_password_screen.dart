import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_validator/form_validator.dart';
import 'package:sd_campus_app/features/cubit/auth/auth_cubit.dart';
import 'package:sd_campus_app/features/presentation/widgets/auth_button.dart';
import 'package:sd_campus_app/features/presentation/widgets/custom_text_field.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/auth/reset_password_verify_otp.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    mobileController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is LoadingAuth) {
              Preferences.onLoading(context);
            }
            if (state is ErrorAuth) {
              Preferences.hideDialog(context);
              Navigator.of(context).pop();
            }
            if (state is ResetPasswordSuccess) {
              Preferences.hideDialog(context);
              Preferences.hideDialog(context);
              if (mobileController.text.isNotEmpty && mobileController.text.length == 10) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ResetPasswordVerifyOtp(emailphoneNumber: mobileController.text),
                  ),
                );
              } else if (emailController.text.isNotEmpty) {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ResetPasswordVerifyOtp(emailphoneNumber: emailController.text),
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            return Container(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 30),
              height: MediaQuery.of(context).size.height * 0.8,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    imageUrl:
                    SvgImages.resetpassword,
                    height: 250,
                  ),
                    Text(
                      'Reset Password',
                      style: Theme.of(context).textTheme.displayMedium!. copyWith(fontSize:24),
                    ),
                    const SizedBox(height: 30),
                    CustomTextFilled(
                      onChanged: (value) => _formKey.currentState!.validate(),
                      hintText: 'Mobile No.',
                      textController: mobileController,
                      validator: ValidationBuilder().required('phone or ').phone().maxLength(10).minLength(10).build(),
                    ),
                    // const SizedBox(height: 20),
                    // const Text('Or'),
                    // const SizedBox(height: 20),
                    // CustomTextFilled(
                    //   onChanged: (value) =>
                    //     _formKey.currentState!.validate(),
                    //   hintText: 'Email ',
                    //   textController: emailController,
                    //   validator:  ValidationBuilder()
                    //       .email()
                    //       .build(),
                    // ),
                    const SizedBox(height: 30),
                    AuthButton(
                      text: 'Send OTP',
                      onPressed: () {
                        if (mobileController.text.isNotEmpty && mobileController.text.length == 10) {
                          BlocProvider.of<AuthCubit>(context).resetPassword(mobileController.text);
                        } else if (emailController.text.isNotEmpty) {
                          BlocProvider.of<AuthCubit>(context).resetPassword(emailController.text);
                        } else {
                          flutterToast('Enter valid data');
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
