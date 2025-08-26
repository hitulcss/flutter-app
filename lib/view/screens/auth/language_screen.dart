import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/controller/auth_controller.dart';
import 'package:sd_campus_app/features/cubit/auth/auth_cubit.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/view/screens/home.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  int selected = SharedPreferenceHelper.getString(Preferences.language) == 'en'
      ? 0
      : SharedPreferenceHelper.getString(Preferences.language) == 'N/A'
          ? 5
          : 1;
  List streamList = [];
  List<String> selectedStream = SharedPreferenceHelper.getStringList(Preferences.course);

  bool isSelectedChip = false;
  late Future<List<String>> getStream;
  late List<String> getstreamimage = [];
  AuthController authController = AuthController();
  @override
  void initState() {
    SharedPreferenceHelper.setBoolean(Preferences.isnewUser, false);
    getStream = authController.getStream().then((value) {
      List<String> streams = [];
      for (var element in value.data ?? []) {
        streams.add(element.title);
        getstreamimage.add(element.icon);
      }
      return streams;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is UpdateLanguageStreamSuccess) {
          SharedPreferenceHelper.setBoolean(Preferences.isStreamAdded, true);
          Navigator.popUntil(context, (route) => false);
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      },
      builder: (context, state) {
        if (state is LoadingAuth) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          body: Container(
            constraints: const BoxConstraints(maxWidth: 375),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: Text(
                        'Choose Your Medium',
                        style: GoogleFonts.notoSansDevanagari(
                          fontSize: 24,
                          color: ColorResources.textblack,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      customRadio(
                        'English',
                        'A',
                        0,
                        true,
                      ),
                      customRadio(
                        'Hindi',
                        'अ',
                        1,
                        true,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SharedPreferenceHelper.getStringList(Preferences.course).isEmpty
                      ? Column(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.80,
                                child: Text(
                                  'Select Your Stream',
                                  style: GoogleFonts.notoSansDevanagari(fontSize: 24, color: ColorResources.textblack),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            FutureBuilder<List<String>>(
                                future: getStream,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      streamList = snapshot.data!;
                                      return SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.80,
                                        child: GridView.count(
                                          crossAxisSpacing: 5,
                                          mainAxisSpacing: 5,
                                          crossAxisCount: 2,
                                          physics: const NeverScrollableScrollPhysics(),
                                          childAspectRatio: 1.5,
                                          shrinkWrap: true,
                                          children: _buildChoiceList(),
                                        ),
                                      );
                                    } else {
                                      return Center(
                                          child: SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.5,
                                        width: MediaQuery.of(context).size.width * 0.9,
                                        child: ErrorWidgetapp(image: SvgImages.error404, text: "Page not found"),
                                      )
                                          //Text('Pls Refresh (or) Reopen App'),
                                          );
                                    }
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                }),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        )
                      : Container(),
                  selectedStream.isNotEmpty && selected < 2
                      ? Container(
                          width: MediaQuery.of(context).size.width * 0.60,
                          decoration: BoxDecoration(color: ColorResources.buttoncolor, borderRadius: BorderRadius.circular(14)),
                          child: TextButton(
                            onPressed: () {
                              BlocProvider.of<AuthCubit>(context).updateStreamLanguage(language: selected == 0 ? 'en' : 'hi', stream: selectedStream);
                            },
                            child: Text(
                              'Save & Continue',
                              style: GoogleFonts.notoSansDevanagari(color: ColorResources.textWhite, fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ),
                        )
                      : const Text(''),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _buildChoiceList() {
    List<Widget> choices = [];
    for (var element in streamList) {
      choices.add(ChoiceChip(
        showCheckmark: false,
        backgroundColor: Colors.transparent,
        selectedColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: selectedStream.contains(element) ? ColorResources.buttoncolor : ColorResources.gray.withValues(alpha: 0.5),
            )),
        label: Stack(
          children: [
            selectedStream.contains(element) ? Positioned(top: 0, left: -2, child: Icon(Icons.check_circle, color: ColorResources.buttoncolor)) : const Text(''),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 20,
                    foregroundImage: CachedNetworkImageProvider(
                      getstreamimage[streamList.indexOf(element)],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      element,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: ColorResources.textblack,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        selected: selectedStream.contains(element),
        onSelected: (value) {
          if (selectedStream.isEmpty) {
            selectedStream.add(element);
          } else {
            selectedStream.clear();
            selectedStream.add(element);
          }
          // selectedStream.contains(element) ? selectedStream.remove(element) : selectedStream.add(element);
          safeSetState(() {
            selectedStream;
          });
        },
      ));
    }
    return choices;
  }

  Widget customRadio(String text, String src, int index, bool tick) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: BorderSide(
          width: 2,
          style: BorderStyle.solid,
          color: selected == index ? ColorResources.buttoncolor : ColorResources.gray.withValues(alpha: 0.5),
        ),
      ),
      onPressed: () {
        safeSetState(() {
          selected = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        child: Stack(
          children: [
            SizedBox(
              width: 100,
              child: Column(children: [
                Text(
                  src,
                  style: GoogleFonts.notoSansDevanagari(color: Colors.black, fontSize: 40, fontWeight: FontWeight.w800),
                ),
                //SizedBox(height: 60, child: SvgPicture.asset(src)),
                Text(
                  text,
                  style: GoogleFonts.notoSansDevanagari(color: Colors.black, fontSize: 12),
                ),
              ]),
            ),
            selected == index
                ? Positioned(
                    top: 0,
                    left: 0,
                    child: Icon(
                      Icons.check_circle,
                      color: ColorResources.buttoncolor,
                    ))
                : const Text('')
          ],
        ),
      ),
    );
  }
}
