import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart';
import 'package:sd_campus_app/features/presentation/bloc/batch_doubt/batch_doubt_bloc.dart';
import 'package:sd_campus_app/features/presentation/widgets/locked_content_popup.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/course/doubt/doubt_card.dart';
import 'package:sd_campus_app/view/screens/course/doubt/rise_a_doubt.dart';

class DoubtsTabWidgetScreen extends StatefulWidget {
  final String batchId;
  final bool isFullScreen;
  final bool isLocked;
  final Data? data;
  const DoubtsTabWidgetScreen({super.key, required this.batchId, required this.isFullScreen, required this.isLocked, this.data});

  @override
  State<DoubtsTabWidgetScreen> createState() => _DoubtsTabWidgetScreenState();
}

class _DoubtsTabWidgetScreenState extends State<DoubtsTabWidgetScreen> {
  ScrollController doubtScrollController = ScrollController();

  bool isMyDoubt = false;

  /// Called when the widget is inserted into the tree.
  ///
  /// Fetches the doubts for the given batch id and sets up a scroll
  /// controller to load more doubts when the user reaches the bottom
  /// of the list.
  @override
  void initState() {
    super.initState();
    analytics.logScreenView(
      screenName: 'Doubt Tab Screen',
      parameters: {
        'batchId': widget.batchId,
        'isMyDoubt': isMyDoubt.toString(),
      },
    );
    context.read<BatchDoubtBloc>().add(FetchDoubts(batchId: widget.batchId, page: 1, isMyDoubt: false));
    doubtScrollController.addListener(onscrollfetch);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // List<String> keywords = SharedPreferenceHelper.getStringList(Preferences.showTour); // key
      // if (!keywords.contains(Preferences.showTourDoubt)) {
      //   final showcase = ShowCaseWidget.of(context);
      //   if (showcase.mounted && showcase.context.mounted) {
      //     try {
      //       showcase.startShowCase([
      //         allDoubtTab,
      //         myDoubtTab
      //       ]);
      //     } catch (e) {
      //       print(e);
      //     }
      //   }
      //   SharedPreferenceHelper.setStringList(Preferences.showTour, [
      //     ...keywords,
      //     Preferences.showTourDoubt
      //   ]); // key
      // }
    });
  }

  void onscrollfetch() {
    if (doubtScrollController.offset == doubtScrollController.position.maxScrollExtent && doubtScrollController.hasClients) {
      context.read<BatchDoubtBloc>().add(LoadMoreDoubts(
            batchId: widget.batchId,
            isMyDoubt: isMyDoubt,
          ));
    }
  }

  ///
  /// Dispose the [doubtScrollController] when this widget is dispose.
  ///
  @override
  void dispose() {
    doubtScrollController.removeListener(onscrollfetch);
    doubtScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: widget.isFullScreen
            ? AppBar(
                title: Text("Doubt"),
                actions: [
                  IconButton(
                    icon: Icon(Icons.report_gmailerrorred),
                    onPressed: () {
                      analytics.logEvent(name: "chat_policy_post", parameters: {
                        "batch_id": widget.batchId,
                      });
                      showModalBottomSheet(
                          showDragHandle: true,
                          context: context,
                          builder: (context) => Column(
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Chat Policy",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Divider(),
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Html(
                                        data: jsonDecode(Preferences.remoteNewPolicy)["chat_policy"],
                                      ),
                                    ),
                                  )
                                ],
                              ));
                    },
                    tooltip: 'Policy',
                  ),
                ],
                bottom: TabBar(
                  physics: NeverScrollableScrollPhysics(),
                  indicatorColor: ColorResources.buttoncolor,
                  labelColor: ColorResources.buttoncolor,
                  unselectedLabelColor: ColorResources.textblack.withValues(alpha: 0.6),
                  onTap: (index) {
                    if (index == 0) {
                      context.read<BatchDoubtBloc>().add(FetchDoubts(batchId: widget.batchId, page: 1, isMyDoubt: false));
                      isMyDoubt = false;
                      analytics.logEvent(name: "allDoubts", parameters: {
                        'batchId': widget.batchId,
                      });
                    } else {
                      context.read<BatchDoubtBloc>().add(FetchDoubts(batchId: widget.batchId, page: 1, isMyDoubt: true));
                      isMyDoubt = true;
                      analytics.logEvent(name: "myDoubts", parameters: {
                        'batchId': widget.batchId,
                      });
                      // context.read<BatchDoubtBloc>().add(FetchMyDoubts(batchId: widget.batchId, page: 1));
                    }
                  },
                  tabs: [
                    Tab(
                      child:
                          //  Showcase(titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          //   key: allDoubtTab,
                          //   description: "ALL Doubts",
                          //   targetPadding: EdgeInsets.all(10),
                          //   child:
                          Text("All"),
                      // ),
                    ),
                    Tab(
                      child:
                          //  Showcase(titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          //   key: myDoubtTab,
                          //   targetPadding: EdgeInsets.all(10),
                          //   description: "My Doubts",
                          //   child:
                          Text("My Doubts"),
                      // ),
                    ),
                  ],
                ),
              )
            : null,
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            BlocBuilder<BatchDoubtBloc, BatchDoubtState>(builder: (context, state) {
              if (state is DoubtLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is DoubtLoaded) {
                return state.doubt.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              child: Icon(
                                Icons.live_help_outlined,
                                size: 60,
                                color: ColorResources.buttoncolor,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              Preferences.appString.noDoubts ?? "No Doubt’s Found!",
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        controller: doubtScrollController,
                        padding: EdgeInsets.only(left: 10, right: 10, bottom: 30 + kBottomNavigationBarHeight, top: 10),
                        itemCount: state.doubt.length + (state.hasReachedMax ? 0 : 1),
                        physics: BouncingScrollPhysics(),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 5,
                            ),
                        itemBuilder: (context, index) {
                          if (index >= state.doubt.length) {
                            return state.hasReachedMax ? Container() : Center(child: CircularProgressIndicator());
                          }
                          final doubt = state.doubt[index];
                          return DoubtCardWidget(
                            doubt: doubt,
                            batchId: widget.batchId,
                            isLocked: widget.isLocked,
                            isddetail: false,
                            isMyDoubt: isMyDoubt,
                          );
                        });
              } else if (state is DoubtError) {
                return Center(child: Text(state.message));
              } else {
                return Container();
              }
            }),
            BlocBuilder<BatchDoubtBloc, BatchDoubtState>(builder: (context, state) {
              if (state is DoubtLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is DoubtLoaded) {
                return state.doubt.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              child: Icon(
                                Icons.live_help_outlined,
                                size: 60,
                                color: ColorResources.buttoncolor,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              Preferences.appString.noDoubts ?? "No Doubt’s Found!",
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        controller: doubtScrollController,
                        padding: EdgeInsets.only(left: 10, right: 10, bottom: 30 + kBottomNavigationBarHeight, top: 10),
                        itemCount: state.doubt.length + (state.hasReachedMax ? 0 : 1),
                        physics: BouncingScrollPhysics(),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 5,
                            ),
                        itemBuilder: (context, index) {
                          if (index >= state.doubt.length) {
                            return state.hasReachedMax ? Container() : Center(child: CircularProgressIndicator());
                          }
                          final doubt = state.doubt[index];
                          return DoubtCardWidget(
                            doubt: doubt,
                            batchId: widget.batchId,
                            isLocked: widget.isLocked,
                            isddetail: false,
                            isMyDoubt: isMyDoubt,
                          );
                        });
              } else if (state is DoubtError) {
                return Center(child: Text(state.message));
              } else {
                return Container();
              }
            }),
          ],
        ),
        bottomSheet: BottomAppBar(
          child: GestureDetector(
            onTap: () {
              if (!widget.isLocked) {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => RiseADoubtPopup(
                          batchId: widget.batchId,
                          isMyDoubt: isMyDoubt,
                        ));
              } else {
                // flutterToast("This Content is Locked");
                lockedContentPopup(context: context, data: widget.data!, place: "Doubt");
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(
                      "Write your doubt/ Queries",
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: ColorResources.buttoncolor,
                    child: Icon(
                      Icons.send,
                      color: ColorResources.textWhite,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
