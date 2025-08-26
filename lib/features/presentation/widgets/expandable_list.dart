import 'package:flutter/material.dart';
import 'package:sd_campus_app/util/color_resources.dart';

class ExpandableListWidget extends StatefulWidget {
  final int minlength;
  final List<Widget> children;
  final String emptyText;
  final bool isexpandedinitial;

  const ExpandableListWidget({
    super.key,
    required this.children,
    this.minlength = 3,
    this.emptyText = "Content coming soon...",
    this.isexpandedinitial = false,
  });

  @override
  State<ExpandableListWidget> createState() => _ExpandableListWidgetState();
}

class _ExpandableListWidgetState extends State<ExpandableListWidget> {
  bool isexpanded = false;

  @override
  void initState() {
    super.initState();
    isexpanded = widget.isexpandedinitial;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.children.isEmpty) {
      return Center(child: Text(widget.emptyText, style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey)));
    }

    List<Widget> visibleItems = isexpanded ? widget.children : widget.children.take(widget.minlength).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedList.separated(
          removedSeparatorBuilder: (context, index, animation) => const Divider(),
          shrinkWrap: true,
          key: ValueKey(isexpanded), // Ensures proper rebuilding
          initialItemCount: visibleItems.length,
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (_, __, animation) => const Divider(),
          itemBuilder: (_, index, animation) => visibleItems[index],
        ),
        if (widget.children.length > widget.minlength)
          Column(
            children: [
              Divider(),
              Center(
                child: GestureDetector(
                  onTap: () => setState(() => isexpanded = !isexpanded),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isexpanded ? Icons.expand_less : Icons.expand_more,
                        color: ColorResources.buttoncolor,
                      ),
                      Text(
                        isexpanded ? "Show Less" : "Show More",
                        style: TextStyle(
                          color: ColorResources.buttoncolor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
