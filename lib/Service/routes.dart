import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/homepage.dart';
import 'package:flutter_app/Screens/login.dart';
import 'package:flutter_app/Screens/info.dart';
import 'package:flutter_app/Screens/projectdetails.dart';
import 'package:flutter_app/Screens/splashScreen.dart';
import 'package:flutter_app/Screens/reportInfo.dart';
import 'package:flutter_app/Utils/utils.dart';

class GenerateRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => HomePage(args, args));
      case homeRoute:
        return MaterialPageRoute(builder: (_) => InfoPage(args));
      case projectRoute:
        return MaterialPageRoute(
            builder: (_) => ProjectDetailsPage(args, args, args));
      case reportRoute:
        return MaterialPageRoute(builder: (_) => ReportInfo(args, args));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              body: Center(child: Text("wrong Page!")),
            ));
  }
}
