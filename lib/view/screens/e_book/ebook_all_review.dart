import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/ebook/get_ebooks_review.dart';
import 'package:sd_campus_app/features/data/remote/models/get_product_by_id.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';

class EbookAllReviewScreen extends StatefulWidget {
  final String? id;
  const EbookAllReviewScreen({super.key, this.id});

  @override
  State<EbookAllReviewScreen> createState() => _EbookAllReviewScreenState();
}

class _EbookAllReviewScreenState extends State<EbookAllReviewScreen> {
  int page = 1;
  List<Reviews> reviews = [];
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  bool hasMore = true;
  @override
  void initState() {
    page = 1;
    apicall();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.addListener(() async {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent * 0.95 && !isLoading) {
          safeSetState(() {
            isLoading = true;
          });
          if (hasMore) {
            apicall();
          }
        }
      });
    });
    super.initState();
  }

  apicall() async {
    GetEbooksReviews data = await RemoteDataSourceImpl().getEbookReviewsRequest(
      page: page,
      id: widget.id,
    );
    if (data.status ?? false) {
      safeSetState(() {
        reviews.addAll(data.data?.reviews ?? []);
        isLoading = false;
        page = page + 1;
        hasMore = data.data?.reviews?.isNotEmpty ?? false;
      });
    }
  }

  @override
  void dispose() {
    // widget.scrollController.dispose();
    page = 1;
    isLoading = false;
    hasMore = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Reviews'),
      ),
      body: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: reviews.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                    decoration: BoxDecoration(
                      color: ColorResources.buttoncolor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 12,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          (reviews[index].rating ?? "").toString(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoSansDevanagari(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    reviews[index].user?.name ?? "",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSansDevanagari(
                      color: ColorResources.textblack,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                reviews[index].title ?? "",
                style: GoogleFonts.notoSansDevanagari(
                  color: ColorResources.textBlackSec,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              )
            ],
          ),
        ),
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}
