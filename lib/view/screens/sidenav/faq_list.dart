import 'package:flutter/material.dart';
import 'package:sd_campus_app/models/gethelp_and_support.dart';
import 'package:sd_campus_app/util/color_resources.dart';

class FAQList extends StatefulWidget {
  final String title;
  final List<TopicName> faqs;
  const FAQList({
    super.key,
    required this.title,
    required this.faqs,
  });

  @override
  State<FAQList> createState() => _FAQListState();
}

class _FAQListState extends State<FAQList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Us"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: ColorResources.borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Text(widget.title),
              ),
              Divider(),
              MediaQuery.removePadding(
                context: context,
                removeTop: true,
                removeBottom: true,
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.faqs.length,
                  separatorBuilder: (context, index) => Divider(),
                  itemBuilder: (context, index) => ExpandedWidget(
                    answer: widget.faqs[index].a ?? "",
                    title: widget.faqs[index].q ?? "",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpandedWidget extends StatefulWidget {
  final String title;
  final String answer;
  const ExpandedWidget({super.key, required this.title, required this.answer});

  @override
  State<ExpandedWidget> createState() => _ExpandedWidgetState();
}

class _ExpandedWidgetState extends State<ExpandedWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 5),
            title: Text(widget.title),
            trailing: CircleAvatar(
              radius: 15,
              backgroundColor: isExpanded ? null : ColorResources.buttoncolor,
              child: Icon(
                isExpanded ? Icons.remove : Icons.add,
                color: isExpanded ? ColorResources.buttoncolor : Colors.white,
              ),
            ),
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
          if (isExpanded) ...[
            Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.answer,
                style: TextStyle(
                  fontSize: 14,
                  color: ColorResources.textBlackSec,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
