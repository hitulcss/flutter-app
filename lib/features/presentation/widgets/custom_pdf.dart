import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:sd_campus_app/features/presentation/widgets/errorwidget.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/images_file.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomPdfScreen extends StatefulWidget {
  final String title;
  final String link;
  const CustomPdfScreen({super.key, required this.link, required this.title});

  @override
  State<CustomPdfScreen> createState() => _CustomPdfScreenState();
}

class _CustomPdfScreenState extends State<CustomPdfScreen> {
  PdfViewerController controller = PdfViewerController();
  bool search = false;
  PdfTextRanges? _selectedText;
  int? _currentSearchSession;
  final _matchIndexToListIndex = <int>[];
  final _listIndexToMatchIndex = <int>[];
  late final textSearcher = PdfTextSearcher(controller)..addListener(_update);
  TextEditingController searchTextFeild = TextEditingController();
  final _markers = <int, List<Marker>>{};
  final TextEditingController _gotopage = TextEditingController();
  final outline = ValueNotifier<List<PdfOutlineNode>?>(null); //bookmark
  var list = [];
  void _update() {
    if (mounted) {
      safeSetState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchTextFeild.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: search
          ? AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  safeSetState(() {
                    search = false;
                  });
                },
              ),
              title: TextField(
                controller: searchTextFeild,
                onChanged: (value) {
                  textSearcher.startTextSearch(
                    value,
                  );
                  _searchResultUpdated();
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  hintText: "seach here",
                  suffixText: searchTextFeild.text.isNotEmpty && textSearcher.hasMatches ? '${textSearcher.currentIndex! + 1} / ${textSearcher.matches.length}' : null,
                  suffixStyle: const TextStyle(fontSize: 10),
                ),
              ),
              actions: [
                IconButton(
                    padding: EdgeInsets.zero,
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      safeSetState(() {
                        search = false;
                        textSearcher.resetTextSearch();
                        searchTextFeild.clear();
                        _matchIndexToListIndex.clear();
                        _listIndexToMatchIndex.clear();
                        _currentSearchSession = null;
                      });
                    },
                    icon: const Icon(Icons.close)),
                IconButton(
                    onPressed: (textSearcher.currentIndex ?? 0) > 0
                        ? () async {
                            await textSearcher.goToPrevMatch();
                            // _conditionScrollPosition();
                            safeSetState(() {});
                          }
                        : null,
                    icon: const Icon(Icons.keyboard_arrow_up)),
                IconButton(
                    onPressed: (textSearcher.currentIndex ?? 0) < textSearcher.matches.length
                        ? () async {
                            await textSearcher.goToNextMatch();
                            safeSetState(() {});
                            // _conditionScrollPosition();
                          }
                        : null,
                    icon: const Icon(Icons.keyboard_arrow_down)),
              ],
            )
          : AppBar(
              title: Text(widget.title),
              actions: [
                IconButton(
                    onPressed: () {
                      list = _getOutlineList(outline.value, 0).toList();
                      // print(list.length);
                      // print("hello");
                      showCupertinoModalPopup(
                          context: context,
                          useRootNavigator: true,
                          // barrierLabel: "Bookmark",
                          builder: (context) {
                            return Dialog.fullscreen(
                              child: Column(
                                children: [
                                  AppBar(
                                    leading: IconButton(
                                      onPressed: () => Navigator.pop(context),
                                      icon: const Icon(Icons.close),
                                    ),
                                    title: const Text("Bookmark"),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                        itemCount: list.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            onTap: () {
                                              controller.goToDest(list[index].node.dest!);
                                              Navigator.of(context).pop();
                                            },
                                            title: Text(list[index].node.title),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    icon: const Icon(Icons.bookmark)),
                IconButton(
                    onPressed: () {
                      safeSetState(() {
                        search = true;
                      });
                    },
                    icon: const Icon(Icons.search)),
              ],
            ),
      body: PdfViewer.uri(Uri.parse(widget.link),
          controller: controller,
          params: PdfViewerParams(
              panEnabled: true,
              pageAnchor: PdfPageAnchor.topCenter,
              pageAnchorEnd: PdfPageAnchor.bottomCenter,
              // pageOverlaysBuilder: (context, rect, pages) => [
              //       GestureDetector(
              //         onPanUpdate: (details) {
              //           // print(details.localPosition);
              //         },
              //       )
              //     ],
              // onInteractionUpdate: (details) {},
              // onInteractionStart: (details) {},
              loadingBannerBuilder: (context, bytesDownloaded, totalBytes) => Center(
                    child: CircularProgressIndicator(
                      value: totalBytes != null ? bytesDownloaded / totalBytes : null,
                      backgroundColor: Colors.grey,
                    ),
                  ),
              linkWidgetBuilder: (context, link, size) => MouseRegion(
                    cursor: SystemMouseCursors.click,
                    hitTestBehavior: HitTestBehavior.translucent,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () async {
                        if (link.url != null) {
                          navigateToUrl(link.url!);
                        } else if (link.dest != null) {
                          controller.goToDest(link.dest);
                        }
                      },
                      child: Container(),
                    ),
                  ),
              viewerOverlayBuilder: (context, rect, pages) => [
                    // Show vertical scroll thumb on the right; it has page number on it
                    PdfViewerScrollThumb(
                      controller: controller,
                      orientation: ScrollbarOrientation.right,
                      thumbSize: const Size(40, 25),
                      thumbBuilder: (context, thumbSize, pageNumber, controller) => GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('Page Number'),
                                  TextField(
                                    controller: _gotopage,
                                    // inputFormatters: [TextInputFormatter],
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(border: OutlineInputBorder()),
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        if (int.parse(value) <= controller.pages.length) controller.goToPage(pageNumber: int.parse(value));
                                      }
                                    },
                                  )
                                ],
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                                TextButton(
                                    onPressed: () {
                                      if (_gotopage.text.isNotEmpty) {
                                        if (int.parse(_gotopage.text) <= controller.pages.length) controller.goToPage(pageNumber: int.parse(_gotopage.text));
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('ok'))
                              ],
                            ),
                          );
                        },
                        child: Container(
                          color: Colors.black,
                          child: Center(
                            child: Text(
                              pageNumber.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Just a simple horizontal scroll thumb on the bottom
                    PdfViewerScrollThumb(
                      controller: controller,
                      orientation: ScrollbarOrientation.bottom,
                      thumbSize: const Size(80, 10),
                      thumbBuilder: (context, thumbSize, pageNumber, controller) => Container(
                        color: Colors.pinkAccent,
                      ),
                    ),
                  ],
              onViewerReady: (document, controller) async {
                // documentRef.value = controller.documentRef;
                outline.value = await document.loadOutline();
                safeSetState(() {
                  list = _getOutlineList(outline.value, 0).toList();
                });
              },
              onDocumentChanged: (document) {
                if (document == null) {
                  // documentRef.value = null;
                  outline.value = null;
                  _selectedText = null;
                  _markers.clear();
                }
              },
              onTextSelectionChange: (selection) {
                // print(selection?.pageText.fragments.first);
                // _selectedText = selection;
                safeSetState(() {});
              },
              pagePaintCallbacks: [
                textSearcher.pageTextMatchPaintCallback,
                _paintMarkers,
              ],
              enableTextSelection: true,
              errorBannerBuilder: (context, error, stacktrace, ref) {
                return ErrorWidgetapp(
                  image: SvgImages.error404,
                  text: "Page not found",
                );
              })),
      bottomNavigationBar: controller.isReady && controller.pageNumber != null && _selectedText != null && _selectedText!.isNotEmpty
          ? BottomAppBar(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.circle,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      // print(_selectedText?.text);
                      // print(_selectedText?.bounds);
                      _addCurrentSelectionToMarkers(Colors.red);
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ],
              ),
            )
          : null,
    );
  }

  void _addCurrentSelectionToMarkers(Color color) {
    if (controller.isReady && controller.pageNumber != null && _selectedText != null && _selectedText!.isNotEmpty) {
      _markers.putIfAbsent(_selectedText!.pageNumber, () => []).add(Marker(color, _selectedText!));
      safeSetState(() {});
    }
  }

  void _searchResultUpdated() {
    if (_currentSearchSession != textSearcher.searchSession) {
      _currentSearchSession = textSearcher.searchSession;
      _matchIndexToListIndex.clear();
      _listIndexToMatchIndex.clear();
    }
    for (int i = _matchIndexToListIndex.length; i < textSearcher.matches.length; i++) {
      if (i == 0 || textSearcher.matches[i - 1].pageNumber != textSearcher.matches[i].pageNumber) {
        _listIndexToMatchIndex.add(-textSearcher.matches[i].pageNumber); // negative index to indicate page header
      }
      _matchIndexToListIndex.add(_listIndexToMatchIndex.length);
      _listIndexToMatchIndex.add(i);
    }

    if (mounted) safeSetState(() {});
  }

  Future<void> navigateToUrl(Uri url) async {
    if (await shouldOpenUrl(context, url)) {
      await launchUrl(url);
    }
  }

  Future<bool> shouldOpenUrl(BuildContext context, Uri url) async {
    final result = await showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Navigate to URL?'),
          content: SelectionArea(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Do you want to navigate to the following location?\n'),
                  TextSpan(
                    text: url.toString(),
                    style: const TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Go'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  void _paintMarkers(Canvas canvas, Rect pageRect, PdfPage page) {
    final markers = _markers[page.pageNumber];
    if (markers == null) {
      return;
    }
    for (final marker in markers) {
      final paint = Paint()
        ..color = marker.color.withAlpha(100)
        ..style = PaintingStyle.fill;

      for (final range in marker.ranges.ranges) {
        final f = PdfTextRangeWithFragments.fromTextRange(
          marker.ranges.pageText,
          range.start,
          range.end,
        );
        if (f != null) {
          canvas.drawRect(
            f.bounds.toRectInPageRect(page: page, pageRect: pageRect),
            paint,
          );
        }
      }
    }
  }

  Iterable<
      ({
        PdfOutlineNode node,
        int level
      })> _getOutlineList(List<PdfOutlineNode>? outline, int level) sync* {
    if (outline == null) return;
    for (var node in outline) {
      yield (
        node: node,
        level: level
      );
      yield* _getOutlineList(node.children, level + 1);
    }
  }
}

class Marker {
  final Color color;
  final PdfTextRanges ranges;

  Marker(this.color, this.ranges);
}
