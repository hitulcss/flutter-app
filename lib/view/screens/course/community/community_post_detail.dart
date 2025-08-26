import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sd_campus_app/features/data/remote/models/get_community_comments.dart';
import 'package:sd_campus_app/features/presentation/bloc/batch_community/batch_community_bloc.dart';
import 'package:sd_campus_app/features/presentation/widgets/community_card.dart';
import 'package:sd_campus_app/features/data/remote/models/batch_community_model.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/view/screens/course/community/comments_card_widget.dart';
import 'package:sd_campus_app/view/screens/course/community/popup_comment_edit.dart';

class CommunityPostDetailScreen extends StatefulWidget {
  final String postid;
  final String batchId;
  final bool isMyCommunity;
  const CommunityPostDetailScreen({
    super.key,
    required this.postid,
    required this.batchId,
    required this.isMyCommunity,
  });

  @override
  State<CommunityPostDetailScreen> createState() => _CommunityPostDetailScreenState();
}

class _CommunityPostDetailScreenState extends State<CommunityPostDetailScreen> {
  int page = 1;
  TextEditingController commentController = TextEditingController();

  ScrollController commnetScrollController = ScrollController();

  int totalComments = 0;

  int loadeCommentsCount = 0;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<BatchCommunityBloc>(context).add(PostCommunityDetails(postId: widget.postid));
    commnetScrollController.addListener(() {
      if (commnetScrollController.position.atEdge) {
        if (loadeCommentsCount != totalComments) {
          page += 1;
          BlocProvider.of<BatchCommunityBloc>(context).add(FetchCommunityComments(communityId: widget.postid, page: page));
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    analytics.logEvent(name: "post_details", parameters: {
      "post_id": widget.postid,
      "batch_id": widget.batchId,
    });
    return Scaffold(
      appBar: AppBar(
        title: Text('View Post'),
        actions: [
          IconButton(
            icon: Icon(Icons.report_gmailerrorred),
            onPressed: () {
              analytics.logEvent(name: "chat_policy_post", parameters: {
                "post_id": widget.postid,
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<BatchCommunityBloc, BatchCommunityState>(
          builder: (context, state) {
            if (state is CommunityLoaded) {
              totalComments = state.communities
                      .firstWhere(
                        (element) => element.id == widget.postid,
                        orElse: () => Community(comments: []),
                      )
                      .commentCounts ??
                  0;
              loadeCommentsCount = state.communities
                      .firstWhere(
                        (element) => element.id == widget.postid,
                        orElse: () => Community(comments: []),
                      )
                      .comments
                      ?.length ??
                  0;
              return SingleChildScrollView(
                controller: commnetScrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommunityCardWidget(
                      isLocked: false,
                      post: state.communities.where((element) => element.id == widget.postid).first,
                      isddetail: true,
                      batchId: widget.batchId,
                      isMyCommunity: widget.isMyCommunity,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (state.communities.where((element) => element.id == widget.postid).first.comments?.isNotEmpty ?? false)
                      Text(
                        '${(state.communities.where((element) => element.id == widget.postid).first.commentCounts ?? 0) > 1 ? "Comments" : "Comment"} ${(state.communities.where((element) => element.id == widget.postid).first.commentCounts ?? 0) > 0 ? "${"(${state.communities.where((element) => element.id == widget.postid).first.commentCounts ?? 0}"})" : ""}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    (state.communities.where((element) => element.id == widget.postid).first.comments?.isEmpty ?? true)
                        ? SizedBox(height: 200, child: Center(child: Text("No comments yet")))
                        : ListView.separated(
                            padding: EdgeInsets.only(top: 10),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.communities.where((element) => element.id == widget.postid).first.comments?.length ?? 0,
                            separatorBuilder: (context, index) => SizedBox(height: 10),
                            itemBuilder: (context, index) => CommentCardWidget(
                              comment: state.communities.where((element) => element.id == widget.postid).first.comments![index] ?? Comment(commentId: "", cmntsMsg: "", createdAt: "", user: User(name: "", profilePhoto: "")),
                              communityId: widget.postid,
                            ),
                          ),
                  ],
                ),
              );
            } else if (state is CommunityLoading) {
              return Center(child: CircularProgressIndicator());
            } else {
              // print("this is not able to happen");
              return SizedBox();
            }
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              builder: (context) => PopupCommentEdit(
                isCommentEdit: true,
                communityId: widget.postid,
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: ColorResources.buttoncolor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
                    child: Text('Write a comment'),
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
    );
  }
}
