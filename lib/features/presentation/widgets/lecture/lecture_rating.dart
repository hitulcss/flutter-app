import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/features/data/remote/models/base_model.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';

class LectureRatingScreen extends StatefulWidget {
  final String id;
  final dynamic cubit;
  final bool? isyoutube;
  const LectureRatingScreen({super.key, required this.id, required this.cubit, this.isyoutube});

  @override
  State<LectureRatingScreen> createState() => _LectureRatingScreenState();
}

class _LectureRatingScreenState extends State<LectureRatingScreen> {
  double ratingstar = 0;

  final TextEditingController _ratingController = TextEditingController();
  @override
  void dispose() {
    _ratingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: ColorResources.textWhite,
                boxShadow: [
                  BoxShadow(
                    color: ColorResources.borderColor,
                    spreadRadius: 0,
                    blurRadius: 50,
                    offset: const Offset(0, 4), // changes position of shadow
                  )
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      "Write a Review",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Your rating help us improve"),
                        const SizedBox(
                          height: 5,
                        ),
                        RatingBar.builder(
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (value) {
                            safeSetState(() {
                              ratingstar = value;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Text("Add detailed Review"),
                        const SizedBox(
                          height: 5,
                        ),
                        TextField(
                          controller: _ratingController,
                          maxLines: 3,
                          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Write a review",
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorResources.buttoncolor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_ratingController.text.isNotEmpty && ratingstar > 0) {
                                    BaseModel data = widget.isyoutube ?? false
                                        ? await RemoteDataSourceImpl().submitRatingVideoLearingLibrary(videoId: widget.id, comment: _ratingController.text, rating: ratingstar.toInt())
                                        : await RemoteDataSourceImpl().postRatingRequest(
                                            lectureId: widget.id,
                                            msg: _ratingController.text,
                                            rating: ratingstar,
                                          );
                                    if (data.status) {
                                      analytics.logEvent(name: "rating", parameters: {
                                        'message': _ratingController.text
                                      });
                                      flutterToast(data.msg);
                                      try {
                                        widget.cubit.israted = true;
                                        widget.cubit.statecall();
                                      } catch (e) {
                                        if (kDebugMode) {
                                          print("error");
                                        }
                                      }
                                      _ratingController.clear();
                                    } else {
                                      flutterToast(data.msg);
                                    }
                                  } else {
                                    flutterToast("Please enter your review.");
                                  }
                                },
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    color: ColorResources.textWhite,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
