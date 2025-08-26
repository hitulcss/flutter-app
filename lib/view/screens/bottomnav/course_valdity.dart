
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sd_campus_app/features/cubit/course_plan/plan_cubit.dart';
import 'package:sd_campus_app/features/data/remote/models/get_batch_plan.dart';
import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart';
import 'package:sd_campus_app/features/services/payment_fun.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';

class CourseValdityScreen extends StatefulWidget {
  final bool isCheckOut;
  final bool isEnroll;
  final List<GetBatchPlanData> value;
  final String batchName;
  final BatchDetails data;
  const CourseValdityScreen({super.key, required this.value, required this.batchName, required this.data, required this.isCheckOut, required this.isEnroll});

  @override
  State<CourseValdityScreen> createState() => _CourseValdityScreenState();
}

class _CourseValdityScreenState extends State<CourseValdityScreen> {
  final ScrollController _scrollController = ScrollController();
  int selected = 0;
  @override
  void initState() {
    super.initState();
    if (context.read<CoursePlanCubit>().planId?.isNotEmpty ?? false) {
      selected = context.read<CoursePlanCubit>().plans.indexWhere((x) => x.validityId == context.read<CoursePlanCubit>().planId);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.batchName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            Expanded(
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(widget.value.length, (index) {
                        return validtyTypes(
                            isRecommended: widget.value[index].isRecommended ?? false,
                            title: widget.value[index].name ?? "Plan",
                            isSelected: selected == index,
                            onTap: () {
                              safeSetState(() {
                                selected = index;
                                context.read<CoursePlanCubit>().selectPlan(planId: widget.value[index].validityId ?? "", planValidity: widget.value[index].month ?? 0);
                              });
                            });
                      }),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.vertical,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Text(
                                        "Features",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Container(
                                        height: 2,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            transform: GradientRotation(1),
                                            colors: [
                                              Colors.white,
                                              Colors.transparent
                                            ],
                                          ),
                                        ),
                                      ),
                                      ...List.generate(
                                        widget.value.first.features?.length ?? 0,
                                        (index) => SizedBox(
                                          height: 40,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    widget.value.first.features?[index].featureName ?? "Feature",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                                  ),
                                                ),
                                                if (widget.value.first.features?[index].info?.isNotEmpty ?? false) ...[
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Tooltip(
                                                    margin: EdgeInsets.symmetric(horizontal: 15),
                                                    preferBelow: false,
                                                    triggerMode: TooltipTriggerMode.tap,
                                                    richMessage: WidgetSpan(
                                                        child: widget.value.first.features?[index].info?.contains(",") ?? false
                                                            ? Container(
                                                                constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.9, maxHeight: 400),
                                                                child: ListView.builder(
                                                                    itemCount: widget.value.first.features?[index].info?.split(",").length ?? 0,
                                                                    shrinkWrap: true,
                                                                    itemBuilder: (context, sindex) {
                                                                      return Text(
                                                                        "* ${widget.value.first.features?[index].info?.split(",")[sindex] ?? "Feature Description"}",
                                                                        style: TextStyle(fontSize: 10, color: Colors.white),
                                                                      );
                                                                    }),
                                                              )
                                                            : Text(
                                                                widget.value.first.features?[index].info ?? "Feature Description",
                                                                style: TextStyle(fontSize: 10, color: Colors.white),
                                                              )),
                                                    showDuration: Duration(seconds: 5),
                                                    child: Icon(
                                                      Icons.help_outline,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  )
                                                ]
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                  controller: _scrollController,
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        ...List.generate(widget.value.length, (index) {
                                          return GestureDetector(
                                            onTap: () {
                                              safeSetState(() {
                                                selected = index;
                                                context.read<CoursePlanCubit>().selectPlan(planId: widget.value[index].validityId ?? "", planValidity: widget.value[index].month ?? 0);
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(right: 10),
                                              constraints: BoxConstraints(minWidth: 20, maxWidth: 80),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      selected == index ? Color(0xFFFECD3D) : Colors.white,
                                                      selected == index ? Color(0xFF987B25).withValues(alpha: 0.4) : Color(0xFF999999).withValues(alpha: 0.4)
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                    stops: [
                                                      0.5,
                                                      1
                                                    ]),
                                              ),
                                              child: Container(
                                                margin: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.black,
                                                ),
                                                child: Column(
                                                  children: [
                                                    SizedBox(
                                                      height: 70,
                                                      child: Center(
                                                        child: Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                              (widget.value[index].month ?? 0).toString(),
                                                              style: TextStyle(color: selected == index ? Color(0xFFFECD3D) : Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                                            ),
                                                            // SizedBox(
                                                            //   height: 10,
                                                            // ),
                                                            Text(
                                                              (widget.value[index].month ?? 0) > 1 ? "Months" : "Month",
                                                              style: TextStyle(color: selected == index ? Color(0xFFFECD3D) : Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      height: 2,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        gradient: LinearGradient(
                                                          transform: GradientRotation(1),
                                                          colors: [
                                                            selected == index ? Color(0xFFFECD3D) : Colors.white,
                                                            Colors.transparent
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    ...List.generate(
                                                        widget.value[index].features?.length ?? 0,
                                                        (findex) => SizedBox(
                                                              height: 40,
                                                              child: Center(
                                                                child: Icon(
                                                                  widget.value[index].features?[findex].isEnable ?? false ? Icons.check_rounded : Icons.close,
                                                                  color: widget.value[index].features?[findex].isEnable ?? false ? Colors.green : Colors.red,
                                                                ),
                                                              ),
                                                            ))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                ))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.white,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                            text: '₹ ${widget.value[selected].salePrice ?? 0}  ',
                            style: TextStyle(
                              color: ColorResources.textWhite,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: '₹${widget.value[selected].regularPrice ?? 0}',
                            style: TextStyle(
                              color: ColorResources.gray,
                              fontSize: 13,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.grey,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ]),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Color(0xFFC1FFB1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            (widget.value[selected].salePrice ?? 0) < (widget.value[selected].regularPrice ?? 0) && widget.value[selected].salePrice != 0
                                ? "${((((widget.value[selected].regularPrice ?? 0) - (widget.value[selected].salePrice ?? 0)) / (widget.value[selected].regularPrice ?? 0)) * 100).toString().split('.').first}% OFF"
                                // : ""
                                : "",
                            style: const TextStyle(
                              color: Color(0xFF1D7025),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ))
                    ],
                  ),
                  const Spacer(),
                  Expanded(
                      flex: 2,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorResources.buttoncolor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (widget.isCheckOut) {
                              Navigator.of(context).pop();
                            } else {
                              Navigator.of(context).pop();
                              BatchDetails data = widget.data;
                              if (context.read<CoursePlanCubit>().plans.isNotEmpty) {
                                data.discount = (context.read<CoursePlanCubit>().plans.firstWhere((x) => (x.validityId) == context.read<CoursePlanCubit>().planId, orElse: () => context.read<CoursePlanCubit>().plans.first).salePrice ?? 0).toString();
                                data.charges = (context.read<CoursePlanCubit>().plans.firstWhere((x) => (x.validityId) == context.read<CoursePlanCubit>().planId, orElse: () => context.read<CoursePlanCubit>().plans.first).regularPrice ?? 0).toString();
                              }
                              buttonOnTap(context: context, data: data, isEnroll: widget.isEnroll);
                            }
                          },
                          child: Text(
                            'Buy Now', //Languages.addtocart,
                            style: GoogleFonts.notoSansDevanagari(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: ColorResources.textWhite,
                            ),
                          ))),
                ],
              ),
            )
          ],
        ));
  }

  Widget validtyTypes({
    required String title,
    required bool isSelected,
    required bool isRecommended,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            constraints: BoxConstraints(minWidth: 150),
            margin: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 5, color: isSelected ? Color(0xFFFECD3D) : ColorResources.borderColor),
            ),
            child: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ),
          if (isRecommended)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: CustomPaint(
                  painter: LabelPainter(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2),
                    child: const Text(
                      'Recommended',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.black,
              child: isSelected ? Icon(Icons.check_circle_outline, color: Color(0xFFFECD3D), size: 30) : Icon(Icons.circle_outlined, color: ColorResources.borderColor, size: 30),
            ),
          )
        ],
      ),
    );
  }
}

class LabelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFFFCA120) // Orange background color
      ..style = PaintingStyle.fill;

    final Path path = Path();
    path.fillType = PathFillType.evenOdd;
    path.moveTo(20, 0); // Start from the top-left corner with padding
    path.lineTo(size.width - 20, 0); // Top-right corner with padding
    path.lineTo(size.width, size.height); // Bottom-right corner
    path.lineTo(0, size.height); // Bottom-left corner
    path.lineTo(20, 0); // Close the shape back to the top-left corner
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
