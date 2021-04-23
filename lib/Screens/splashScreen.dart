import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/homepage.dart';
import 'package:flutter_app/Screens/login.dart';
import 'package:flutter_app/Service/dbService.dart';
import 'package:flutter_app/Utils/utils.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  var user;
  @override
  Widget build(BuildContext context) {
    user = Provider.of<FirebaseUser>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: grey,
        body: Hero(
          tag: "Welcome",
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/under-construction.png',
                    height: 150,
                    width: 150,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Welcome to ",
                            style: TextStyle(fontSize: 26.0, color: black)),
                        TextSpan(
                            text: "CONSTRUCTIFY",
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 26.0))
                      ]),
                    )),
                SizedBox(
                  height: 30,
                ),
                RaisedButton(
                  color: blue,
                  elevation: 8.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: 100, child: Center(child: Text("Let's Start"))),
                  ),
                  textColor: white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  onPressed: () async {
                    if (user != null) {
                      var uid = await Utils().auth.currentUser();
                      var snapshot = await DbService().getPerson(uid.uid);
                      var company = snapshot.data['company'];
                      print(snapshot.data['position']);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => HomePage(
                                  company, snapshot.data['position'])));
                    } else {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => LoginPage()));
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
