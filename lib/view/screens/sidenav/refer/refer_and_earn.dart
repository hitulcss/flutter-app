import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:share_plus/share_plus.dart';

class ReferEranScreen extends StatelessWidget {
  const ReferEranScreen({super.key});
  @override
  Widget build(BuildContext context) {
    firebaseMessaging.getToken().then((value) {
      // print(value);
    });
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorResources.textWhite,
          iconTheme: IconThemeData(color: ColorResources.textblack),
          title: Text(
            'Refer & Earn',
            style: GoogleFonts.notoSansDevanagari(color: ColorResources.textblack),
          ),
        ),
        body:
            //  FutureBuilder<ReferalContentModel>(
            //     initialData: SharedPreferenceHelper.getString(Preferences.getReferalContent) == 'N/A'
            //         ? ReferalContentModel(
            //             status: true,
            //             data: ReferalContentModelData(
            //               referialAmount: '100',
            //               url: '',
            //             ),
            //           )
            //         : ReferalContentModel.fromJson(
            //             jsonDecode(
            //               SharedPreferenceHelper.getString(
            //                 Preferences.getReferalContent,
            //               )!,
            //             ),
            //           ),
            //     future: RemoteDataSourceImpl().getreferalContent(),
            //     builder: (context, snapshot) {
            //       return
            SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: const BoxDecoration(
                  color: Color(0x26F4B44B),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Earn Cash',
                                    style: TextStyle(
                                      color: ColorResources.textblack,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' upto',
                                    style: TextStyle(
                                      color: ColorResources.textblack,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ₹${Preferences.remoteReferAndEarn["refer_and_earn"]["amount"] ?? 0}',
                                    style: TextStyle(
                                      color: ColorResources.buttoncolor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' in your bank account for',
                                    style: TextStyle(
                                      color: ColorResources.textblack,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' Every Friend',
                                    style: TextStyle(
                                      color: ColorResources.textblack,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' you refer',
                                    style: TextStyle(
                                      color: ColorResources.textblack,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: CachedNetworkImage(
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                              imageUrl: SvgImages.coin,
                              height: 100,
                            ),
                          )
                        ],
                      ),
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   decoration: const BoxDecoration(color: Colors.white),
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         const Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             Text(
                    //               'Total Rewards Earn ',
                    //               style: TextStyle(
                    //                 color: ColorResources.textblack,
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w500,
                    //                 height: 0,
                    //                 letterSpacing: -0.56,
                    //               ),
                    //             ),
                    //             Text(
                    //               '₹0',
                    //               style: TextStyle(
                    //                 color: ColorResources.textblack,
                    //                 fontSize: 14,
                    //                 fontWeight: FontWeight.w500,
                    //                 height: 0,
                    //                 letterSpacing: -0.56,
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //         OutlinedButton(
                    //           onPressed: () {},
                    //           child: const Text('Redeem Now'),
                    //           style: OutlinedButton.styleFrom(
                    //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    //             side: BorderSide(color: ColorResources.buttoncolor),
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: ColorResources.buttoncolor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Share Your Referral Code',
                          style: TextStyle(
                            color: ColorResources.textblack,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            height: 0,
                            letterSpacing: -0.56,
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: ColorResources.buttoncolor.withValues(alpha: 0.1),
                                border: RDottedLineBorder.all(color: ColorResources.buttoncolor),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(text: SharedPreferenceHelper.getString(Preferences.myReferralCode)!));
                                  flutterToast('copy to clipboard successfully');
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      SharedPreferenceHelper.getString(Preferences.myReferralCode)!,
                                      style: TextStyle(
                                        color: ColorResources.buttoncolor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.copy,
                                      color: ColorResources.buttoncolor,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 6,
                            child: GestureDetector(
                              onTap: () {
                                Share.share(
                                  Preferences.remoteReferAndEarn["refer_and_earn"]["sharedata"] ?? "", //'SD Campus is an institute of an excellence for हिन्दी as well as ENGLISH medium which aims to revolutionize education sector. SD Campus takes its motto "सिद्धिर्भवति कर्मजा" from "श्रीमद्भागवत गीता" and disseminates its essence among the students that "Practice Leads To Success" अर्थात् कर्मों से ही सिद्धि प्राप्त होगी \n Download Now ! \n\n  https://sdcampus.com/',
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorResources.buttoncolor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CachedNetworkImage(
                                      placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                      imageUrl: SvgImages.whatsapp,
                                      height: 25,
                                    ),
                                    Text(
                                      Preferences.appString.inviteyourfriends ?? 'Invite Your Friends',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(border: Border.all(color: ColorResources.borderColor), borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                      child: Text(
                        'Invite Your Yaari',
                        style: TextStyle(
                          color: ColorResources.buttoncolor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 0,
                          letterSpacing: -0.56,
                        ),
                      ),
                    ),
                    const Divider(),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CachedNetworkImage(
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                imageUrl: SvgImages.inviteyaari,
                                height: 30,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Get upto ₹${Preferences.remoteReferAndEarn["refer_and_earn"]["amount"] ?? "0"}',
                                            style: TextStyle(
                                              color: ColorResources.textblack,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' Cash',
                                            style: TextStyle(
                                              color: ColorResources.textblack,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'If your friend purchases ',
                                            style: TextStyle(
                                              color: ColorResources.textblack,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Offline / Online SD Campus',
                                            style: TextStyle(
                                              color: ColorResources.buttoncolor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: ColorResources.buttoncolor,
                            ),
                            child: Text(
                              'Your friends gets upto ₹${Preferences.remoteReferAndEarn["refer_and_earn"]["amount"] ?? "0"} Cashback on Batch perchance',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Terms & Conditions',
                            style: TextStyle(
                              color: ColorResources.textblack,
                              fontSize: 8,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How it Works?',
                      style: TextStyle(
                        color: ColorResources.textblack,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.campaign_outlined,
                          color: ColorResources.textblack,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            'Share your referral code or link with your friends. ',
                            style: TextStyle(
                              color: ColorResources.textBlackSec,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.group_add_outlined,
                          color: ColorResources.textblack,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            'Friends sign-up with your link or referral code.',
                            style: TextStyle(
                              color: ColorResources.textblack,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        CachedNetworkImage(
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          imageUrl: SvgImages.rewards,
                          height: 25,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            'When your friend makes a purchase, you get ₹${Preferences.remoteReferAndEarn["refer_and_earn"]["amount"]}  cashback for SD Campus. Your friends to get discount on any purchase of SD Campus.',
                            style: TextStyle(
                              color: ColorResources.textblack,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x26F4B44B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10, right: 10.0),
                      child: Text(
                        'Term and Conditions',
                        style: TextStyle(
                          color: ColorResources.textblack,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        (Preferences.remoteReferAndEarn["refer_and_earn"]["term_and_condition"] as String).contains("{phoneNumber}") ? (Preferences.remoteReferAndEarn["refer_and_earn"]["term_and_condition"] as String).replaceAll("{phoneNumber}", SharedPreferenceHelper.getString(Preferences.phoneNUmber)!) : (Preferences.remoteReferAndEarn["refer_and_earn"]["term_and_condition"] as String), //'Cashback will be credited to your registered mobile number +91${SharedPreferenceHelper.getString(Preferences.phoneNUmber)} . You may change your number to get cashback in another mobile number. ',
                        style: TextStyle(
                          color: ColorResources.textblack,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        )
        //   ;
        // }),
        );
  }
}
