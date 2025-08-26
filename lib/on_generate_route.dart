import 'package:flutter/material.dart';
import 'package:sd_campus_app/app_const.dart';
import 'package:sd_campus_app/view/screens/home.dart';

class OnGenerateRoute {
  static Route<dynamic> route(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case PageConst.home:
        {
          return materialBuilder(widget: const HomeScreen());
        }
      default:
        return materialBuilder(
          widget: const ErrorPage(),
        );
    }
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error"),
      ),
      body: const Center(
        child: Text("Error"),
      ),
    );
  }
}

MaterialPageRoute materialBuilder({required Widget widget}) {
  return MaterialPageRoute(builder: (_) => widget);
}
