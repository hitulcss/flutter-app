import 'package:flutter/material.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailedExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final TextStyle style;

  const DetailedExpandableText({
    super.key,
    required this.text,
    this.maxLines = 2,
    required this.style,
  });

  @override
  DetailedExpandableTextState createState() => DetailedExpandableTextState();
}

class DetailedExpandableTextState extends State<DetailedExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final span = TextSpan(
              text: widget.text,
              style: widget.style,
            );
            final tp = TextPainter(
              maxLines: widget.maxLines,
              textAlign: TextAlign.left,
              textDirection: TextDirection.ltr,
              text: span,
            );
            tp.layout(maxWidth: constraints.maxWidth);

            if (tp.didExceedMaxLines) {
              return GestureDetector(
                  onTap: () {
                    safeSetState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ParsedText(
                        text: widget.text,
                        maxLines: isExpanded ? null : widget.maxLines,
                        overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                        style: widget.style,
                        parse: [
                          MatchText(
                            type: ParsedType.URL,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                            onTap: (url) {
                              launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                            },
                          ),
                          MatchText(
                            type: ParsedType.EMAIL,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                            onTap: (url) {
                              launchUrl(Uri(
                                scheme: 'mailto',
                                path: url,
                              ));
                            },
                          ),
                          MatchText(
                            type: ParsedType.PHONE,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 12,
                            ),
                            onTap: (url) {
                              launchUrl(Uri.parse(
                                "tel:$url",
                              ));
                            },
                          ),
                        ],
                      ),
                      Text(
                        isExpanded ? 'Show Less' : 'Show More',
                        style: TextStyle(
                          color: ColorResources.buttoncolor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ));
            } else {
              return ParsedText(
                text: widget.text,
                style: widget.style,
                parse: [
                  MatchText(
                    type: ParsedType.URL,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                    ),
                    onTap: (url) {
                      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                    },
                  ),
                  MatchText(
                    type: ParsedType.EMAIL,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                    ),
                    onTap: (url) {
                      launchUrl(Uri(
                        scheme: 'mailto',
                        path: url,
                      ));
                    },
                  ),
                  MatchText(
                    type: ParsedType.PHONE,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                    ),
                    onTap: (url) {
                      launchUrl(Uri.parse(
                        "tel:$url",
                      ));
                    },
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }
}
