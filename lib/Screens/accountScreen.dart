import 'package:flutter/material.dart';
import 'package:flutter_app/Service/dbService.dart';
import 'package:flutter_app/Utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var name;
  var company;
  var phone;
  var position;
  var id;

  @override
  void initState() {
    super.initState();
    getpref();
  }

  getpref() async {
    pref = await SharedPreferences.getInstance();
    id = pref.getString('uid');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DbService().db.collection("person").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            for (var i = 0; i < snapshot.data.documents.length; i++) {
              if (snapshot.data.documents[i]['id'] == id) {
                name = snapshot.data.documents[i]['fname'] +
                    ' ' +
                    snapshot.data.documents[i]['lname'];

                company = snapshot.data.documents[i]['company'];
                phone = snapshot.data.documents[i]['phone'];
                position = snapshot.data.documents[i]['position'];
              }
            }
          } else {
            name = "";

            company = "";
            phone = "";
            position = "";
          }
          return !snapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: grey,
                      title: Text("ACCOUNT",
                          style: TextStyle(
                            color: black,
                          )),
                      centerTitle: true,
                    ),
                    backgroundColor: grey,
                    body: SingleChildScrollView(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                  leading: Text("Name : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0)),
                                  title: Center(child: Text(name ?? ""))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                  leading: Text("Phone No : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0)),
                                  title: Center(child: Text(phone ?? ""))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                  leading: Text("Company : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0)),
                                  title: Center(child: Text(company ?? ""))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                  leading: Text("Position : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0)),
                                  title: Center(child: Text(position ?? ""))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        });
  }
}
