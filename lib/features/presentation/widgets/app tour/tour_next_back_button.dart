import 'package:flutter/material.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:showcaseview/showcaseview.dart';

TooltipActionButton tourNext({required BuildContext context, void Function()? onTap}) {
  return TooltipActionButton(
    type: TooltipDefaultActionType.next,
    name: 'Next',
    textStyle: const TextStyle(color: Colors.white),
    backgroundColor: ColorResources.buttoncolor,
    borderRadius: BorderRadius.circular(10),
    onTap: () {
      ShowCaseWidget.of(context).next();
      if (onTap != null) {
        onTap.call();
      }
    },
  );
}

TooltipActionButton tourPrevious({required BuildContext context, void Function()? onTap}) {
  return TooltipActionButton(
    type: TooltipDefaultActionType.previous,
    name: 'Previous',
    borderRadius: BorderRadius.circular(10),
    backgroundColor: ColorResources.borderColor,
    textStyle: const TextStyle(color: Colors.black),
    onTap: () {
      ShowCaseWidget.of(context).previous();
      if (onTap != null) {
        onTap.call();
      }
    },
  );
}

TooltipActionButton tourSkip({required BuildContext context}) {
  return TooltipActionButton(
    type: TooltipDefaultActionType.skip,
    borderRadius: BorderRadius.circular(10),
    name: 'Skip',
    backgroundColor: ColorResources.buttoncolor,
    textStyle: const TextStyle(color: Colors.white),
    onTap: () {
      ShowCaseWidget.of(context).dismiss();
    },
  );
}
