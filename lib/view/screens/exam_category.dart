import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sd_campus_app/features/controller/auth_controller.dart';
import 'package:sd_campus_app/features/cubit/streamselect/streamsetect_cubit.dart';
import 'package:sd_campus_app/features/data/remote/models/stream_model.dart';
import 'package:sd_campus_app/features/presentation/widgets/auth_button.dart';
import 'package:sd_campus_app/features/services/remote_services/auth_services.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/setsate_ext.dart';
import 'package:sd_campus_app/util/langauge.dart';
import 'package:sd_campus_app/util/prefconstatnt.dart';
import 'package:sd_campus_app/util/preference.dart';
import 'package:sd_campus_app/view/screens/home.dart';

class ExamCategoryScreen extends StatelessWidget {
  final bool isFromHomeScreen;
  const ExamCategoryScreen({
    super.key,
    this.isFromHomeScreen = true,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select your Category'),
      ),
      body: FutureBuilder<StreamModel>(
          future: AuthController().getStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (snapshot.hasData) {
                return ExamSelectionScreen(
                  streamDataModel: snapshot.data?.data ?? [],
                  isFromHomeScreen: isFromHomeScreen,
                );
              } else {
                return const Center(
                  child: Text(' No Data Found'),
                );
              }
            }
          }),
    );
  }
}

class ExamSelectionScreen extends StatefulWidget {
  final List<StreamDataModel> streamDataModel;
  final bool isFromHomeScreen;
  const ExamSelectionScreen({
    super.key,
    required this.streamDataModel,
    required this.isFromHomeScreen,
  });

  @override
  ExamSelectionScreenState createState() => ExamSelectionScreenState();
}

class ExamSelectionScreenState extends State<ExamSelectionScreen> {
  String _selectedCategoryIndex = "";
  String _selectedCategoryId = "";
  String _selectedSubCategoryIndex = "";
  String _selectedSubCategoryId = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.streamDataModel.length,
            itemBuilder: (context, index) {
              final category = widget.streamDataModel[index];
              return Card(
                surfaceTintColor: Colors.white,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () {
                        safeSetState(() {
                          _selectedCategoryIndex = category.title ?? "";
                          _selectedCategoryId = category.sId ?? "";
                        });
                      },
                      title: Text(category.title ?? "", style: TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Icon((_selectedCategoryIndex == (category.title ?? "")) ? Icons.radio_button_on : Icons.radio_button_off, color: _selectedCategoryIndex == (category.title ?? "") ? ColorResources.buttoncolor : null),
                    ),
                    if (_selectedCategoryIndex == category.title)
                      ListView.builder(
                        itemCount: category.subCategories?.length ?? 0,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, subIndex) {
                          final subCategory = category.subCategories?[subIndex];
                          return subCategory != null
                              ? RadioListTile(
                                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                                  title: Text(subCategory.title ?? ""),
                                  activeColor: ColorResources.buttoncolor,
                                  value: subCategory.title,
                                  groupValue: _selectedSubCategoryIndex,
                                  controlAffinity: ListTileControlAffinity.trailing,
                                  onChanged: (value) {
                                    safeSetState(() {
                                      _selectedSubCategoryIndex = value ?? "";
                                      _selectedSubCategoryId = subCategory.id ?? "";
                                    });
                                  },
                                )
                              : Container(); // Handle null subCategory
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        if (_selectedCategoryIndex.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: AuthButton(
                      onPressed: () async {
                        await SharedPreferenceHelper.setBoolean(Preferences.isloggedin, true);
                        await SharedPreferenceHelper.setBoolean(Preferences.isStreamAdded, true);
                        // await RemoteDataSourceImpl().postStreamRequest(
                        //   name: _selectedCategoryIndex,
                        //   subname: _selectedSubCategoryId,
                        // );
                        AuthServices().updateStream(stream: _selectedCategoryId, subCategory: _selectedSubCategoryId);
                        context.read<StreamsetectCubit>().topCourseStreamSelected(selected: _selectedCategoryIndex);
                        Languages.initState();
                        if (widget.isFromHomeScreen) {
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      text: 'SAVE ',
                    ),
                  ),
                )
              ],
            ),
          )
      ],
    );
  }
}
