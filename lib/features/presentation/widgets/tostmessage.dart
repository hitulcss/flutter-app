import 'package:fluttertoast/fluttertoast.dart';
import 'package:sd_campus_app/util/color_resources.dart';
import 'package:sd_campus_app/util/extenstions/string_extenstions.dart';

void flutterToast(String message) {
  Fluttertoast.showToast(
    msg: message.toCapitalize(),
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: ColorResources.gray,
    textColor: ColorResources.textWhite,
    fontSize: 14.0,
  );
}
