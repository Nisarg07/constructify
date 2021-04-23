import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/homepage.dart';
import 'package:flutter_app/Screens/info.dart';
import 'package:flutter_app/Service/authService.dart';
import 'package:flutter_app/Service/dbService.dart';
import 'package:flutter_app/Utils/utils.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _sigupEmail = TextEditingController();
  final _signupPass = TextEditingController();
  final _rePass = TextEditingController();
  String _phone;
  String email;
  String pass;
  String _warning = "";
  bool obsecureText = true;
  bool obsecureTextPass = true;
  bool obsecureTextRePass = true;
  final _formKey = GlobalKey<FormState>();
  var formType = FormType.signIn;
  var userId;

  Future<bool> _validateForm() async {
    try {
      if (_pass.text.length < 6) {
        setState(() {
          _warning = "Password must be at least 6 characters long.";
        });
        return false;
      }
      var result = await Utils()
          .auth
          .signInWithEmailAndPassword(email: _email.text, password: _pass.text);
      userId = result.user.uid;
      return true;
    } catch (e) {
      setState(() {
        _warning = e.message;
        return false;
      });
      return false;
    }
  }

  _validateSignUp() async {
    try {
      if (_signupPass.text != _rePass.text) {
        setState(() {
          _warning = "Please enter same passwords";
        });
        return false;
      } else {
        var result = await Utils().auth.createUserWithEmailAndPassword(
            email: _sigupEmail.text, password: _signupPass.text);
        pref = await SharedPreferences.getInstance();
        pref.setString("uid", result.user.uid);
        return true;
      }
    } catch (e) {
      setState(() {
        _warning = e.toString();
        return false;
      });
      return false;
    }
  }

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      _phone = internationalizedPhoneNumber;
    });
  }

  Widget getBody(typeForm) {
    return typeForm == FormType.phoneSignIn
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _warning.isEmpty
                  ? SizedBox(
                      height: 0,
                    )
                  : Container(
                      color: error,
                      child: ListTile(
                        leading: Icon(Icons.error_outline),
                        title: Expanded(child: Text(_warning)),
                        trailing: IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            setState(() {
                              _warning = "";
                            });
                          },
                        ),
                      ),
                    ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Phone Login",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: InternationalPhoneInput(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.phone),
                      labelText: "Phone",
                      labelStyle: TextStyle(color: black),
                      helperText: "",
                      border: OutlineInputBorder(),
                      counterText: "",
                    ),
                    onPhoneNumberChange: onPhoneNumberChange,
                    initialPhoneNumber: _phone,
                    initialSelection: 'IN',
                    showCountryCodes: true),
              ),
              RaisedButton(
                color: blue,
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: 80, child: Center(child: Text("Continue"))),
                ),
                textColor: white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                onPressed: () async {
                  var result =
                      await AuthService().signInWithPhone(_phone, context);
                  if (_phone == null || result == "error") {
                    setState(() {
                      _warning = "Phone authentication is invalid";
                    });
                  }
                },
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                child: Text("Cancel"),
                onTap: () {
                  setState(() {
                    formType = FormType.signIn;
                  });
                },
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _warning.isEmpty
                  ? SizedBox(
                      height: 0,
                    )
                  : Container(
                      color: error,
                      child: ListTile(
                        leading: Icon(Icons.error_outline),
                        title: Expanded(child: Text(_warning)),
                        trailing: IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            setState(() {
                              _warning = "";
                            });
                          },
                        ),
                      ),
                    ),
              SizedBox(
                height: 30,
              ),
              Text(
                "SignUp Page",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  maxLength: 50,
                  controller: _sigupEmail,
                  autofocus: false,
                  style: TextStyle(color: black),

                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.mail),
                    labelText: "Email",
                    labelStyle: TextStyle(color: black, fontSize: 18),
                    helperText: "",
                    border: OutlineInputBorder(),
                    counterText: "",
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter Email";
                    }
                    return null;
                  },
                  // onSaved: (value) => email = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  maxLength: 50,
                  controller: _signupPass,
                  autofocus: false,
                  style: TextStyle(color: black),
                  obscureText: obsecureTextPass,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () {
                        setState(() {
                          obsecureTextPass = !obsecureTextPass;
                        });
                      },
                    ),
                    labelText: "Password",
                    labelStyle: TextStyle(color: black, fontSize: 18),
                    helperText: "",
                    border: OutlineInputBorder(),
                    counterText: "",
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter Password";
                    }
                    return null;
                  },
                  // onSaved: (value) => email = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  maxLength: 50,
                  controller: _rePass,
                  autofocus: false,
                  style: TextStyle(color: black),
                  obscureText: obsecureTextRePass,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () {
                        setState(() {
                          obsecureTextRePass = !obsecureTextRePass;
                        });
                      },
                    ),
                    labelText: "Re-enter Password",
                    labelStyle: TextStyle(color: black, fontSize: 18),
                    helperText: "",
                    border: OutlineInputBorder(),
                    counterText: "",
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter Password again";
                    }
                    return null;
                  },
                  // onSaved: (value) => email = value,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              RaisedButton(
                color: blue,
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: 80, child: Center(child: Text("CONTINUE"))),
                ),
                textColor: white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0))),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    if (await _validateSignUp()) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => InfoPage()));
                    }
                  }
                  setState(() {
                    formType = FormType.signUp;
                  });
                },
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                child: Text("Cancel"),
                onTap: () {
                  setState(() {
                    formType = FormType.signIn;
                  });
                },
              ),
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: grey,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * .80,
              child: Form(
                key: _formKey,
                autovalidate: false,
                child: formType == FormType.signIn
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _warning.isEmpty
                              ? SizedBox(
                                  height: 0,
                                )
                              : Container(
                                  color: error,
                                  child: ListTile(
                                    leading: Icon(Icons.error_outline),
                                    title: Expanded(child: Text(_warning)),
                                    trailing: IconButton(
                                      icon: Icon(Icons.cancel),
                                      onPressed: () {
                                        setState(() {
                                          _warning = "";
                                        });
                                      },
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Login Page",
                            style: TextStyle(fontSize: 30),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              maxLength: 50,
                              controller: _email,
                              autofocus: false,
                              style: TextStyle(color: black),
                              decoration: InputDecoration(
                                suffixIcon: Icon(
                                  Icons.email,
                                ),
                                labelText: "Email",
                                labelStyle:
                                    TextStyle(color: black, fontSize: 18),
                                helperText: "",
                                border: OutlineInputBorder(),
                                counterText: "",
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter Email";
                                }
                                return null;
                              },
                              onSaved: (value) => email = value,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              maxLength: 50,
                              controller: _pass,
                              autofocus: false,
                              obscureText: obsecureText,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.remove_red_eye),
                                  onPressed: () {
                                    setState(() {
                                      obsecureText = !obsecureText;
                                    });
                                  },
                                ),
                                labelText: "Password",
                                labelStyle: TextStyle(color: black),
                                helperText: "",
                                border: OutlineInputBorder(),
                                counterText: "",
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter Password";
                                }
                                return null;
                              },
                              onSaved: (value) => pass = value,
                            ),
                          ),
                          GestureDetector(
                            child: Center(child: Text("Forget Password?")),
                            onTap: () async {
                              if (_email.text.isEmpty) {
                                setState(() {
                                  _warning = "Please fill the email.";
                                });
                              } else {
                                await Utils()
                                    .auth
                                    .sendPasswordResetEmail(email: _email.text);

                                setState(() {
                                  _warning = "Email has been sent";
                                });
                              }
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          RaisedButton(
                            color: blue,
                            elevation: 8.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  width: 80,
                                  child: Center(child: Text("LOGIN"))),
                            ),
                            textColor: white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0))),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                if (await _validateForm()) {
                                  var snapshot =
                                      await DbService().getPerson(userId);
                                  pref = await SharedPreferences.getInstance();
                                  pref.setString("uid", userId);
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => HomePage(
                                              snapshot.data['company'],
                                              snapshot.data['position'])));
                                }
                              }
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          RaisedButton(
                            color: blue,
                            elevation: 8.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  width: 80,
                                  child: Center(child: Text("SIGNUP"))),
                            ),
                            textColor: white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0))),
                            onPressed: () async {
                              setState(() {
                                formType = FormType.signUp;
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          GoogleSignInButton(
                            onPressed: () async {
                              try {
                                var uid =
                                    await AuthService().signInWithGoogle();
                                pref = await SharedPreferences.getInstance();
                                pref.setString("uid", uid);
                                var snapshot = await DbService().getPerson(uid);
                                if (snapshot.data.isNotEmpty) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => HomePage(
                                              snapshot.data['company'],
                                              snapshot.data['position'])));
                                } else {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => InfoPage()));
                                }
                              } catch (e) {
                                print(e);
                              }
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          RaisedButton(
                            textColor: white,
                            color: green,
                            elevation: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.phone),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      "Sign in with Phone",
                                      style: TextStyle(fontSize: 16.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                formType = FormType.phoneSignIn;
                              });
                            },
                          ),
                        ],
                      )
                    : getBody(formType),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
