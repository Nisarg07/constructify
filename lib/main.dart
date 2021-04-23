import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Service/routes.dart';
import 'package:flutter_app/Utils/utils.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // String route = log0Route;

  @override
  Widget build(BuildContext context) {
    // var user = _auth.currentUser();
    // if (user != null) {
    //   setState(() {
    //     route = homeRoute;
    //     // Navigator.pop(context);
    //   });
    // }
    return MultiProvider(
      providers: [
        StreamProvider<FirebaseUser>.value(
          value: _auth.onAuthStateChanged,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.light(),
        debugShowCheckedModeBanner: false,
        initialRoute: splashRoute,
        onGenerateRoute: GenerateRoutes.generateRoute,
      ),
    );
  }
}
