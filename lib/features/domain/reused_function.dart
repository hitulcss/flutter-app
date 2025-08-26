import 'package:sd_campus_app/features/presentation/widgets/tostmessage.dart';
import 'package:sd_campus_app/main.dart';
import 'package:sd_campus_app/util/preference.dart';

void loginRoute() {
  flutterToast('Section Expired');
  SharedPreferenceHelper.clearPref();
  navigatorKey.currentState!.popUntil((route) => false); // navigate to login, with null-aware check
  navigatorKey.currentState!.pushNamed('/'); // navigate to login, with null-aware check
}
