import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/accountScreen.dart';
import 'package:flutter_app/Screens/dailyTask.dart';
import 'package:flutter_app/Screens/equipments.dart';
import 'package:flutter_app/Screens/files.dart';
import 'package:flutter_app/Screens/materials.dart';
import 'package:flutter_app/Screens/plans.dart';
import 'package:flutter_app/Screens/task.dart';
import 'package:flutter_app/Screens/workers.dart';
import 'package:flutter_app/Screens/reportInfo.dart';
import 'package:flutter_app/Service/authService.dart';
import 'package:flutter_app/Service/dbService.dart';
import 'package:flutter_app/Utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProjectDetailsPage extends StatefulWidget {
  String company;
  String projectName;
  String position;
  ProjectDetailsPage(this.company, this.projectName, this.position);
  @override
  _ProjectDetailsPageState createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  int indexV = 0;
  List<String> title = ["MATERIALS", "EQUIPMENTS", "WORKERS", "TASKS"];
  _changeBody(int index1, company, projectName, position) {
    if (index1 == 0) {
      return MaterialsPage(company, projectName, position);
    }
    if (index1 == 1) {
      return Equipments(company, projectName, position);
    }
    if (index1 == 2) {
      return WorkersPage(company, projectName, position);
    }
    if (index1 == 3) {
      return TaskPage(company, projectName, position);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getpref();
  }

  var id;

  getpref() async {
    pref = await SharedPreferences.getInstance();
    id = pref.getString('uid');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DbService().db.collection("person").snapshots(),
        builder: (context, snapshot) {
          // print(pref.getString('uid') + ":" + id);
          var name;
          if (snapshot.hasData) {
            for (var i = 0; i < snapshot.data.documents.length; i++) {
              if (snapshot.data.documents[i]['id'] == id) {
                name = snapshot.data.documents[i]['fname'] +
                    ' ' +
                    snapshot.data.documents[i]['lname'];
              }
            }
          } else {
            name = "";
          }
          return !snapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SafeArea(
                  child: Scaffold(
                    backgroundColor: grey,
                    appBar: AppBar(
                      title: Text(
                        title[indexV],
                        style: TextStyle(color: black),
                      ),
                      centerTitle: true,
                      backgroundColor: grey,
                      elevation: 0.0,
                      iconTheme: IconThemeData(color: black),
                    ),
                    body: _changeBody(indexV, widget.company,
                        widget.projectName, widget.position),
                    drawer: Container(
                      width: 200,
                      child: Drawer(
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            UserAccountsDrawerHeader(
                              decoration: BoxDecoration(color: grey),
                              currentAccountPicture: CircleAvatar(
                                child: Icon(
                                  Icons.person,
                                  color: black,
                                  size: 50,
                                ),
                              ),
                              accountEmail: Text(""),
                              accountName: Text(name ?? ''),
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.person,
                                color: black,
                              ),
                              title: Text("ACCOUNT"),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AccountScreen(),
                                    ));
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.announcement,
                                color: black,
                              ),
                              title: Text("PLANS"),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Plans(
                                          widget.company,
                                          widget.projectName,
                                          widget.position),
                                    ));
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.receipt,
                                color: black,
                              ),
                              title: Text("REPORTS"),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReportInfo(
                                          widget.company, widget.projectName),
                                    ));
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.card_travel,
                                color: black,
                              ),
                              title: Text("DAILY TASK"),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => DailyTask(
                                            widget.company,
                                            widget.projectName,
                                            widget.position)));
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.attach_file,
                                color: black,
                              ),
                              title: Text("FILES"),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => Files(
                                            widget.company,
                                            widget.projectName,
                                            widget.position)));
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.power_settings_new,
                                color: black,
                              ),
                              title: Text("LOGOUT"),
                              onTap: () {
                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                                AuthService().signOut(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    bottomNavigationBar: CurvedNavigationBar(
                      index: 0,
                      height: 50,
                      color: darkGrey,
                      backgroundColor: grey,
                      buttonBackgroundColor: Colors.transparent,
                      onTap: (index) {
                        setState(() {
                          this.indexV = index;
                        });
                      },
                      items: <Widget>[
                        IconButton(
                          icon: Image.asset("assets/maintenance_icon.png"),
                          onPressed: null,
                          color: white,
                        ),
                        IconButton(
                          icon: Image.asset("assets/construction-machine.png"),
                          onPressed: null,
                          color: white,
                        ),
                        IconButton(
                          icon: Image.asset("assets/workers_icon.png"),
                          onPressed: null,
                          color: white,
                        ),
                        IconButton(
                          icon: Image.asset("assets/task_icon.png"),
                          onPressed: null,
                          color: white,
                        ),
                      ],
                    ),
                  ),
                );
        });
  }
}
