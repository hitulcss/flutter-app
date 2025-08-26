import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sd_campus_app/features/data/remote/models/batch_community_model.dart';
import 'package:sd_campus_app/features/data/remote/models/course_details_model.dart';
import 'package:sd_campus_app/features/presentation/bloc/batch_community/batch_community_bloc.dart';
import 'package:sd_campus_app/features/presentation/widgets/community_card.dart';
import 'package:sd_campus_app/features/presentation/widgets/locked_content_popup.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/course/community/create_a_post.dart';

class CommunityTabWidgetScreen extends StatefulWidget {
  final String batchId;
  final bool isFullScreen;
  final bool isLocked;
  final Data? data;
  const CommunityTabWidgetScreen({super.key, required this.batchId, required this.isFullScreen, required this.isLocked, this.data});

  @override
  State<CommunityTabWidgetScreen> createState() => _CommunityTabWidgetScreenState();
}

class _CommunityTabWidgetScreenState extends State<CommunityTabWidgetScreen> {
  ScrollController doubtScrollController = ScrollController();
  bool isMyCommunity = false;

  /// Called when the widget is inserted into the tree.
  ///
  /// Fetches the doubts for the given batch id and sets up a scroll
  /// controller to load more doubts when the user reaches the bottom
  /// of the list.
  @override
  void initState() {
    super.initState();
    analytics.logScreenView(
      screenName: 'CommunityTabScreen',
      parameters: {
        "batchid": widget.batchId,
        "isLocked": widget.isLocked.toString(),
        "isMyCommunity": isMyCommunity.toString(),
      },
    );
    context.read<BatchCommunityBloc>().add(FetchCommunitys(batchId: widget.batchId, page: 1, isMyCommunity: false));

    doubtScrollController.addListener(() {
      if (doubtScrollController.offset == doubtScrollController.position.maxScrollExtent && doubtScrollController.hasClients) {
        context.read<BatchCommunityBloc>().add(LoadMoreCommunitys(
              batchId: widget.batchId,
              isMyCommunity: isMyCommunity,
            ));
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // List<String> keywords = SharedPreferenceHelper.getStringList(Preferences.showTour); // key
      // if (!keywords.contains(Preferences.showTourCommunity)) {
      //   ShowCaseWidget.of(context).startShowCase([
      //     allCommunityTab,
      //     myCommunityTab,
      //   ]);
      //   SharedPreferenceHelper.setStringList(Preferences.showTour, [
      //     ...keywords,
      //     Preferences.showTourCommunity
      //   ]); // key
      // }
    });
  }

  ///
  /// Dispose the [doubtScrollController] when this widget is dispose.
  ///
  @override
  void dispose() {
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
                title: Text("Community"),
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
                      context.read<BatchCommunityBloc>().add(FetchCommunitys(batchId: widget.batchId, page: 1, isMyCommunity: false));
                      isMyCommunity = false;
                    } else {
                      context.read<BatchCommunityBloc>().add(FetchCommunitys(batchId: widget.batchId, page: 1, isMyCommunity: true));
                      isMyCommunity = true;
                      // context.read<BatchDoubtBloc>().add(FetchMyDoubts(batchId: widget.batchId, page: 1));
                    }
                  },
                  tabs: [
                    Tab(
                        child:
                            // Showcase(titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),key: allCommunityTab, description: "All Community", targetPadding: EdgeInsets.all(10), child:
                            Text("All")
                        // ),
                        ),
                    Tab(
                        child:
                            //  Showcase(titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),key: myCommunityTab, description: "My Community Posts", targetPadding: EdgeInsets.all(10), child:
                            Text("My Posts")
                        // ),
                        ),
                  ],
                ),
              )
            : null,
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            BlocBuilder<BatchCommunityBloc, BatchCommunityState>(
              builder: (context, state) {
                if (state is CommunityLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is CommunityLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      return context.read<BatchCommunityBloc>().add(FetchCommunitys(batchId: widget.batchId, page: 1, isMyCommunity: false));
                    },
                    child: state.communities.isEmpty
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
                                  "No Posts Found!",
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            controller: doubtScrollController,
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              bottom: 30 + kBottomNavigationBarHeight,
                              top: 10,
                            ),
                            itemCount: state.communities.length + (state.hasReachedMax ? 0 : 1),
                            physics: BouncingScrollPhysics(),
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 10,
                                ),
                            itemBuilder: (context, index) {
                              if (index >= state.communities.length) {
                                return state.hasReachedMax ? Container() : Center(child: CircularProgressIndicator());
                              }
                              final post = state.communities[index];
                              return CommunityCardWidget(
                                post: post,
                                batchId: widget.batchId,
                                isLocked: widget.isLocked,
                                isMyCommunity: isMyCommunity,
                              );
                            }),
                  );
                } else if (state is CommunityError) {
                  return Center(child: Text(state.message));
                } else {
                  return Container();
                }
              },
            ),
            BlocBuilder<BatchCommunityBloc, BatchCommunityState>(
              builder: (context, state) {
                if (state is CommunityLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is CommunityLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      return context.read<BatchCommunityBloc>().add(FetchCommunitys(batchId: widget.batchId, page: 1, isMyCommunity: true));
                    },
                    child: state.communities.isEmpty
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
                                  "No Posts Found!",
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            controller: doubtScrollController,
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              bottom: 30 + kBottomNavigationBarHeight,
                              top: 10,
                            ),
                            itemCount: state.communities.length + (state.hasReachedMax ? 0 : 1),
                            physics: BouncingScrollPhysics(),
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 10,
                                ),
                            itemBuilder: (context, index) {
                              if (index >= state.communities.length) {
                                return state.hasReachedMax ? Container() : Center(child: CircularProgressIndicator());
                              }
                              final post = state.communities[index];
                              return CommunityCardWidget(
                                post: post,
                                batchId: widget.batchId,
                                isLocked: widget.isLocked,
                                isMyCommunity: isMyCommunity,
                              );
                            }),
                  );
                } else if (state is CommunityError) {
                  return Center(child: Text(state.message));
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
        bottomSheet: BottomAppBar(
          child: GestureDetector(
            onTap: () {
              if (widget.isLocked) {
                lockedContentPopup(context: context, data: widget.data!, place: "Community");
              } else {
                postCommunity(batchId: widget.batchId, context: context, isMyCommunity: isMyCommunity);
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
                      "What’s on your mind?",
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

postCommunity({required BuildContext context, Community? community, required batchId, required isMyCommunity}) {
  showModalBottomSheet(
      context: context,
      // showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => CreateAPostPopup(
            batchId: batchId,
            community: community,
            isMyCommunity: isMyCommunity,
          ));
}
