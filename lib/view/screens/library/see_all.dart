import 'package:flutter/material.dart';
import 'package:sd_campus_app/features/data/remote/models/stream_model.dart';

class SeeAllScreen extends StatelessWidget {
  final String title;
  final String image;
  final void Function(int index) onTap;
  final List<StreamDataModel> catagory;
  const SeeAllScreen({
    super.key,
    required this.title,
    required this.catagory,
    required this.image,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: GridView.builder(
            itemCount: catagory.length,
            padding: EdgeInsets.all(10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () => onTap(index),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Image.network(
                            image,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              catagory[index].title ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
