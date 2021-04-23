import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/homepage.dart';
import 'package:flutter_app/Screens/login.dart';
import 'package:flutter_app/Screens/info.dart';
import 'package:flutter_app/Service/dbService.dart';
import 'package:flutter_app/Utils/utils.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  final _code = TextEditingController();

  String varificationCode;

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
    return (await _firebaseAuth.signInWithCredential(credential)).user.uid;
  }

  Future signOut(BuildContext context) async {
    await _firebaseAuth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => LoginPage()));
  }

  Future signInWithPhone(String phone, BuildContext context) async {
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCredential) async {
          var uid = (await _firebaseAuth.signInWithCredential(authCredential))
              .user
              .uid;
          var snapshot = await DbService().getPerson(uid);
          if (snapshot.data.isNotEmpty) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                        snapshot.data['company'], snapshot.data['position'])));
          } else {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => InfoPage(phone)));
          }
          //     .then((value) => Navigator.pushReplacement(context,
          //         MaterialPageRoute(builder: (context) => InfoPage(phone))))
          //     .catchError((e) {
          //   return "error";
          // });
        },
        verificationFailed: (AuthException exception) {
          return "error";
        },
        codeSent: (String verificationCode, [int forceResendingToken]) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: "Enter ",
                    style: TextStyle(color: black),
                  ),
                  TextSpan(
                      text: "OTP",
                      style:
                          TextStyle(color: white, fontWeight: FontWeight.bold))
                ]),
              ),
              content: TextField(
                controller: _code,
              ),
              backgroundColor: grey,
              actions: [
                FlatButton(
                  child: Text("Submit"),
                  onPressed: () async {
                    var _credential = PhoneAuthProvider.getCredential(
                        verificationId: verificationCode,
                        smsCode: _code.text.trim());
                    var uid =
                        (await _firebaseAuth.signInWithCredential(_credential))
                            .user
                            .uid;
                    var snapshot = await DbService().getPerson(uid);
                    if (snapshot.data.isNotEmpty) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                  snapshot.data['company'],
                                  snapshot.data['position'])));
                    } else {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InfoPage(phone)));
                    }
                  },
                )
              ],
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationCode) {
          varificationCode = verificationCode;
        });
  }
}
