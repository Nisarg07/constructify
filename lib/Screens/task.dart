import 'package:flutter/material.dart';
import 'package:flutter_app/Model/taskModel.dart';
import 'package:flutter_app/Service/dbService.dart';
import 'package:flutter_app/Utils/utils.dart';
import 'package:intl/intl.dart';

class TaskPage extends StatefulWidget {
  String company;
  String projectName;
  String position;
  TaskPage(this.company, this.projectName, this.position);
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  var done = [
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
  ];
  var remaining = [
    "true",
    "true",
    "true",
    "true",
    "true",
    "true",
    "true",
    "true",
    "true",
  ];
  var checkDone = [
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
    "false",
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: DbService()
              .db
              .collection("company")
              .document(widget.company)
              .collection("project")
              .document(widget.projectName)
              .collection("tasks")
              .orderBy('date', descending: true)
              .limit(1)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              for (var i = 0; i < tasks.length; i++) {
                if (checkDone[i] != snapshot.data.documents[0][tasks[i]]) {
                  checkDone[i] = snapshot.data.documents[0][tasks[i]];
                  done[i] = snapshot.data.documents[0][tasks[i]];
                }
              }
            }
            return Container(
              color: grey,
              child: !snapshot.hasData
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        // done[index] != null
                        //     ? done[index] !=
                        //             snapshot.data.documents[0][tasks[index]]
                        //         ? done[index] =
                        //             snapshot.data.documents[0][tasks[index]]
                        //         : done[index] = "true"
                        //     : done[index] =
                        //         snapshot.data.documents[0][tasks[index]];
                        return ExpansionTile(
                          key: GlobalKey(),
                          title: Text(tasks[index]),
                          children: [
                            ListTile(
                              title: Text("Done"),
                              trailing: done[index] != "true"
                                  ? null
                                  : Icon(Icons.done),
                              onTap: widget.position != "Contractor"
                                  ? null
                                  : () {
                                      setState(() {
                                        done[index] = "true";
                                        remaining[index] = "false";
                                      });
                                    },
                            ),
                            ListTile(
                              title: Text("Remaining"),
                              trailing: done[index] != "false"
                                  ? null
                                  : Icon(Icons.done),
                              onTap: widget.position != "Contractor"
                                  ? null
                                  : () {
                                      setState(() {
                                        remaining[index] = "true";
                                        done[index] = "false";
                                      });
                                    },
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      }),
            );
          }),
      floatingActionButton: widget.position != "Contractor"
          ? null
          : FloatingActionButton(
              onPressed: () async {
                print("pressed");
                print(done);
                var date = DateFormat('dd-MM-yyyy').format(DateTime.now());
                var monthYear = DateFormat('MM-yyyy').format(DateTime.now());
                var task = TaskModel(
                    widget.projectName,
                    done[0],
                    done[1],
                    done[2],
                    done[3],
                    done[4],
                    done[5],
                    done[6],
                    done[7],
                    done[8],
                    date,
                    monthYear);
                await DbService()
                    .addTask(widget.company, widget.projectName, date, task);
              },
              child: Icon(Icons.save),
              backgroundColor: Colors.red,
            ),
    );
  }
}
