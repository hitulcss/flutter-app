import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/coursesmodel.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/features/presentation/widgets/shimmer_custom.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/view/screens/bottomnav/coursesdetails.dart';

class CourseSearchWidget extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Platform.isAndroid ? const Icon(Icons.arrow_back) : const Icon(Icons.arrow_back_ios),
      onPressed: () => Navigator.of(context).pop(),
      // Exit from the search screen.
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement your search results view
    // Your search results UI here
    return _buildSearchResults(query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Implement your suggestions view
    // Your suggestions UI here
    if (query.trim().isEmpty) {
      return Container();
    } else {
      return _buildSearchsuggestionsResults(query);
    }
  }

  FutureBuilder _buildSearchsuggestionsResults(query) {
    return FutureBuilder<CoursesModel>(
      future: RemoteDataSourceImpl().getSearchCourseRequest(search: query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return snapshot.data!.data.isEmpty
                ? Center(
                    child: Text(
                      'There is no product.',
                      style: GoogleFonts.notoSansDevanagari(
                        fontSize: 22,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    // snapshot.data?.data[index].isPaid ?? false
                                    // ? CourseViewScreen(batchId: snapshot.data!.data[index].id, courseName: snapshot.data!.data[index].batchName)
                                    // :
                                    CoursesDetailsScreens(
                                  courseId: snapshot.data!.data[index].id,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              snapshot.data!.data[index].batchName,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: snapshot.data!.data.length);
          } else {
            return ErrorWidgetapp(image: SvgImages.error404, text: "Please check other");
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  FutureBuilder _buildSearchResults(query) {
    return FutureBuilder<CoursesModel>(
      future: RemoteDataSourceImpl().getSearchCourseRequest(search: query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return snapshot.data!.data.isEmpty
                ? Center(
                    child: EmptyWidget(
                      image: SvgImages.emptyProduct,
                      text: 'There is no product',
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.data.length,
                    itemBuilder: (context, index) {
                      return _cardWidget(snapshot.data!.data[index], context);
                    });
          } else {
            return ErrorWidgetapp(image: SvgImages.error404, text: "Please check other");
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Container _cardWidget(CoursesDataModel data, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorResources.textWhite,
        boxShadow: [
          BoxShadow(
            color: ColorResources.gray.withValues(alpha: 0.5),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => CoursesDetailsScreens(
              courseId: data.id,
            ),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          data.batchName,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.notoSansDevanagari(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: ColorResources.textblack,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: ColorResources.buttoncolor.withValues(
                            alpha: 0.1,
                          ),
                        ),
                        child: Text(
                          data.language == 'enhi'
                              ? 'English | Hindi'
                              : data.language == 'hi'
                                  ? 'Hindi'
                                  : 'English',
                          style: GoogleFonts.notoSansDevanagari(
                            color: ColorResources.buttoncolor,
                            fontSize: 8,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: CachedNetworkImage(
                          imageUrl: data.banner[0].fileLoc,
                          placeholder: (context, url) => Center(
                            child: ShimmerCustom.rectangular(height: 150),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 15,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Start`s on ',
                              style: TextStyle(
                                color: ColorResources.textBlackSec,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: data.startingDate.toString().split(" ").first,
                              style: TextStyle(
                                color: ColorResources.textblack,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: ' | End`s on ',
                              style: TextStyle(
                                color: ColorResources.textBlackSec,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: data.endingDate.toString().split(" ").first,
                              style: TextStyle(
                                color: ColorResources.textblack,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        int.parse(data.discount) == 0 ? "Free" : '₹${(int.parse(data.discount))}',
                        style: GoogleFonts.notoSansDevanagari(
                          color: int.parse(data.discount) == 0 ? Colors.green : ColorResources.buttoncolor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        int.parse(data.discount) < int.parse(data.charges) ? '₹${data.charges}  ' : "",
                        style: GoogleFonts.notoSansDevanagari(
                          decoration: TextDecoration.lineThrough,
                          color: ColorResources.gray,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        int.parse(data.discount) < int.parse(data.charges)
                            ? data.charges != "0"
                                ? '(${(((int.parse(data.charges) - int.parse(data.discount)) / int.parse(data.charges)) * 100).toString().split('.').first}% OFF)'
                                : ""
                            : "",
                        style: GoogleFonts.notoSansDevanagari(
                          color: const Color(0xFF1D7025),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                        ),
                        color: ColorResources.buttoncolor.withValues(alpha: 0.2),
                      ),
                      child: Text(
                        'View Details',
                        style: TextStyle(
                          color: ColorResources.textblack,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
