// import 'package:sd_campus_app/util/prefConstatnt.dart';
// import 'package:sd_campus_app/util/preference.dart';
// import 'package:workmanager/workmanager.dart';

// @pragma(
//     'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
//  void callbackDispatcher() {
//     Workmanager().executeTask((task, inputData) async {
//         await SharedPreferenceHelper.init();
//     switch (task) {
//       case "timerisset":
//         print("*" * 200);
//         print(
//             "Bool from prefs: ${SharedPreferenceHelper.getBoolean(Preferences.timerisset)}");
//         print("*" * 200);
//         print("sfdfsdrtsd");
//         print("hello time ${inputData!["context"]}");
//         bool test = await SharedPreferenceHelper.setBoolean(
//             Preferences.timerisset, false);
//         print(test);
//         print(
//             "Bool from prefs: ${SharedPreferenceHelper.getBoolean(Preferences.timerisset)}");
//         break;
//     }

//     return Future.value(true);
//   });
// }
