import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sd_campus_app/features/data/remote/data_sources/remote_data_source_impl.dart';
import 'package:sd_campus_app/features/data/remote/models/shorts/get_short_comment.dart';
import 'package:sd_campus_app/features/presentation/widgets/empty_widget.dart';
import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/view/screens/course/community/comments_card_widget.dart';
import 'package:sd_campus_app/view/screens/quick%20learning/short_comment_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CommentShortWidget extends StatefulWidget {
  final String shortId;

  const CommentShortWidget({super.key, required this.shortId});

  @override
  State<CommentShortWidget> createState() => _CommentShortWidgetState();
}

class _CommentShortWidgetState extends State<CommentShortWidget> {
  final TextEditingController _textController = TextEditingController();
  bool isCommentEdit = false;
  bool isReply = false;
  ShortComment? commentEdit;
  ShortCommentReply? commentReplyEdit;
  bool isReplyEdit = false;
  int page = 1;
  bool isLoading = true;
  bool isReachedMax = false;
  List<ShortComment> comments = [];
  final ScrollController _commentScrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    fetch();
    _commentScrollController.addListener(() {
      if (_commentScrollController.position.pixels == _commentScrollController.position.maxScrollExtent) {
        fetch();
      }
    });
  }

  Future<void> fetch() async {
    await RemoteDataSourceImpl().getShortComments(page: page, pageSize: 10, shortId: widget.shortId).then((value) {
      if (mounted) {
        safeSetState(() {
          isLoading = false;
          comments.addAll(value.data?.comments ?? []);
          isReachedMax = comments.length == (value.data?.totalCounts ?? 0);
          page++;
        });
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _commentScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 15),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                'COMMENTS',
                style: TextStyle(
                  color: ColorResources.textblack,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Divider(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.4,
            child: comments.isEmpty
                ? EmptyWidget(image: SvgImages.nochatEmpty, text: "No Comments yet!")
                : ListView.separated(
                    controller: _commentScrollController,
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 10,
                    ),
                    itemCount: comments.isNotEmpty && !isReachedMax ? comments.length + 1 : comments.length,
                    itemBuilder: (context, index) {
                      if (index == comments.length) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        ShortComment comment = comments[index];
                        return ShortCommentCardWidget(
                          comment: comment,
                          shortId: widget.shortId,
                          onReply: () {
                            safeSetState(() {
                              isReply = true;
                              isCommentEdit = false;
                              commentEdit = comment;
                              commentReplyEdit = null;
                              _textController.text = "";
                            });
                          },
                          onEditComment: () {
                            _textController.text = comment.msg ?? "";
                            safeSetState(() {
                              isReply = false;
                              isCommentEdit = true;
                              commentReplyEdit = null;
                              commentEdit = comment;
                            });
                          },
                          onEditReply: (reply) {
                            _textController.text = reply.msg ?? "";
                            safeSetState(() {
                              isCommentEdit = false;
                              isReplyEdit = true;
                              commentEdit = comment;
                              commentReplyEdit = reply;
                            });
                          },
                          onDeleteComment: () {
                            deleteCommentAndReplyPopup(
                                context: context,
                                callback: () {
                                  RemoteDataSourceImpl()
                                      .deleteShortComments(
                                    commentId: comment.id ?? "",
                                  )
                                      .then((value) {
                                    if (value && mounted) {
                                      safeSetState(() {
                                        comments.removeWhere((value) => value.id == comment.id);
                                      });
                                    }
                                  });
                                });
                          },
                          onDeleteReply: (reply) {
                            deleteCommentAndReplyPopup(
                                context: context,
                                callback: () {
                                  RemoteDataSourceImpl()
                                      .deleteShortCommentsReply(
                                    replyId: reply.id ?? "",
                                  )
                                      .then((value) {
                                    if (value && mounted) {
                                      safeSetState(() {
                                        comments.firstWhere((value) => value.id == comment.id).replies?.removeWhere((replys) => replys.id == reply.id);
                                      });
                                    }
                                  });
                                });
                          },
                        );
                      }
                    },
                  ),
          ),
          if (isReply || isReplyEdit)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              decoration: BoxDecoration(
                color: ColorResources.buttoncolor,
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Replying To ${commentEdit?.user?.name}.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Jost',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      safeSetState(() {
                        isReply = false;
                        isReplyEdit = false;
                        commentEdit = null;
                        commentReplyEdit = null;
                      });
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          Container(
            color: ColorResources.secPrimary,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: CachedNetworkImageProvider(SharedPreferenceHelper.getString(Preferences.profileImage) ?? ""),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              onTapOutside: (event) {
                                FocusScope.of(context).unfocus();
                              },
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(borderSide: BorderSide.none),
                                hintText: 'Say Somethings...',
                                hintStyle: TextStyle(
                                  // color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              if (_textController.text.trim().isEmpty) {
                                flutterToast("Please enter Something.");
                              } else if (isCommentEdit && commentEdit != null && (commentEdit?.id?.isNotEmpty ?? false)) {
                                updateComment(commentId: commentEdit?.id ?? "");
                              } else if (isReply) {
                                postReply(commentId: commentEdit?.id ?? "", replyToId: commentEdit?.user?.id ?? "");
                              } else if (isReplyEdit) {
                                updateReply(
                                  commentId: commentEdit?.id ?? "",
                                  replyCommentId: commentReplyEdit?.id ?? "",
                                );
                              } else {
                                postComment();
                              }
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              padding: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: ColorResources.buttoncolor,
                              ),
                              child: Icon(
                                Icons.send_outlined,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  void postComment() {
    RemoteDataSourceImpl().postCommentsInShort(msg: _textController.text, shortId: widget.shortId).then((value) {
      if (value != null && mounted) {
        safeSetState(() {
          _textController.clear();
          comments.insert(0, value);
        });
      } else {
        flutterToast("Failed to Post Comment.");
      }
    });
  }

  void updateComment({required String commentId}) {
    RemoteDataSourceImpl().editShortComments(commentId: commentId, msg: _textController.text).then((value) {
      if (mounted && value != null) {
        safeSetState(() {
          comments.where((element) => element.id == commentId).first.msg = value.msg;
          comments.where((element) => element.id == commentId).first.createdAt = value.createdAt;
          isCommentEdit = false;
          commentEdit = null;
          _textController.clear();
        });
      }
    });
  }

  void postReply({required String commentId, required String replyToId}) {
    RemoteDataSourceImpl().postShortCommentsReply(commentId: commentId, msg: _textController.text, replyTo: replyToId).then((value) {
      if (value != null && mounted) {
        safeSetState(() {
          _textController.clear();
          comments.where((element) => element.id == commentId).first.replies?.insert(0, value.copyWith(isMyReply: true));
          isReply = false;
          commentEdit = null;
          commentReplyEdit = null;
        });
      } else {
        flutterToast("Failed to Post Reply.");
      }
    });
  }

  void updateReply({required String commentId, required String replyCommentId}) {
    RemoteDataSourceImpl().editShortCommentsReply(replyId: replyCommentId, msg: _textController.text).then((value) {
      if (mounted && value != null) {
        safeSetState(() {
          comments.where((element) => element.id == commentId).first.replies?.where((element) => element.id == replyCommentId).first.msg = value.msg;
          comments.where((element) => element.id == commentId).first.replies?.where((element) => element.id == replyCommentId).first.createdAt = value.createdAt;
          isReplyEdit = false;
          commentEdit = null;
          commentReplyEdit = null;
          _textController.clear();
        });
      }
    });
  }
}
