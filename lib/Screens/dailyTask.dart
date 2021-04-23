import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Service/dbService.dart';
import 'package:flutter_app/Utils/utils.dart';
import 'package:intl/intl.dart';

class DailyTask extends StatefulWidget {
  String company;
  String projectName;
  String position;
  DailyTask(this.company, this.projectName, this.position);
  @override
  _DailyTaskState createState() => _DailyTaskState();
}

class _DailyTaskState extends State<DailyTask> {
  var taskController = TextEditingController();
  addTask() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Enter Task"),
              content: TextFormField(
                controller: taskController,
              ),
              actions: [
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                  child: Text("Add"),
                  onPressed: () async {
                    var taskList = [];
                    var date = DateFormat('dd-MM-yyyy').format(DateTime.now());
                    if (taskController.text != "") {
                      taskList.add(taskController.text + ':false');
                      await DbService().updateDailyTask(
                          widget.company, widget.projectName, date, taskList);
                    }
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  var taskValue = [];
  var taskName = [];
  var updatedValue = [];
  var date = DateFormat('dd-MM-yyyy').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DbService()
            .db
            .collection("company")
            .document(widget.company)
            .collection("project")
            .document(widget.projectName)
            .collection("dailyTask")
            .orderBy('date', descending: true)
            .limit(1)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.documents[0]['date'] == date) {
              if (snapshot.data.documents[0]['task'] != []) {
                for (var i = 0;
                    i < snapshot.data.documents[0]['task'].length;
                    i++) {
                  if (snapshot.data.documents[0]['task'][i] != "") {
                    var value = snapshot.data.documents[0]['task'][i]
                        .toString()
                        .split(":");
                    if (value[1] == "false") {
                      taskValue.add(false);
                    } else {
                      taskValue.add(true);
                    }
                    taskName.add(value[0]);
                  } else {
                    taskValue.add(false);
                    taskName.add("");
                  }
                }
              }
            }
            // print(taskValue);
          }
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: grey,
                title: Text("DAILY TASK", style: TextStyle(color: black)),
                centerTitle: true,
                actions: [
                  widget.position != "Labours"
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: blue,
                            elevation: 8.0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  width: 60,
                                  child: Center(child: Text("UPDATE"))),
                            ),
                            textColor: white,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0))),
                            onPressed: () async {
                              var taskList = [];
                              if (snapshot.hasData) {
                                for (var i = 0;
                                    i <
                                        snapshot
                                            .data.documents[0]['task'].length;
                                    i++) {
                                  if (snapshot.data.documents[0]['task'][i] ==
                                      "") {
                                    taskList.add("");
                                  } else if (taskValue != null) {
                                    var value = snapshot
                                        .data.documents[0]['task'][i]
                                        .toString()
                                        .split(":");
                                    if (taskValue[i].toString() != value[1]) {
                                      taskList.add(taskName[i] +
                                          ':' +
                                          taskValue[i].toString());
                                      await DbService()
                                          .db
                                          .collection("company")
                                          .document(widget.company)
                                          .collection("project")
                                          .document(widget.projectName)
                                          .collection("dailyTask")
                                          .document(date)
                                          .updateData({
                                        'task': FieldValue.arrayRemove([
                                          snapshot.data.documents[0]['task'][i]
                                        ])
                                      });
                                    } else {
                                      taskList.add(snapshot.data.documents[0]
                                          ['task'][i]);
                                    }
                                  }
                                }
                                taskList.sort((a, b) {
                                  return a
                                      .toLowerCase()
                                      .compareTo(b.toLowerCase());
                                });
                                await DbService().updateDailyTask(
                                    widget.company,
                                    widget.projectName,
                                    date,
                                    taskList);

                                print(taskList);
                              }
                            },
                          ),
                        )
                      : SizedBox(
                          height: 0,
                        ),
                ],
              ),
              backgroundColor: grey,
              body: !snapshot.hasData
                  ? Center(
                      child: Text("No Task"),
                    )
                  : snapshot.data.documents[0]['task'].length != 1
                      ? snapshot.data.documents[0]['date'] != date
                          ? Center(
                              child: Text("No Task"),
                            )
                          : Container(
                              child: ListView.builder(
                                  itemCount:
                                      snapshot.data.documents[0]['task'].length,
                                  itemBuilder: (context, index) => index == 0
                                      ? SizedBox(
                                          height: 0,
                                        )
                                      : CheckboxListTile(
                                          title: Text(taskName[index]),
                                          value: taskValue[index],
                                          onChanged: (value) {
                                            setState(() {
                                              taskValue[index] = value;
                                            });
                                          })),
                            )
                      : Center(
                          child: Text("No Task"),
                        ),
              floatingActionButton: widget.position != "Contractor"
                  ? null
                  : FloatingActionButton(
                      child: Icon(
                        Icons.add,
                        color: white,
                      ),
                      backgroundColor: Colors.red,
                      onPressed: () {
                        addTask();
                      },
                    ),
            ),
          );
        });
  }
}
