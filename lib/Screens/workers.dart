import 'package:flutter/material.dart';
import 'package:flutter_app/Service/dbService.dart';
import 'package:flutter_app/Utils/utils.dart';
import 'package:flutter_app/Model/workers.dart';
import 'package:intl/intl.dart';

class WorkersPage extends StatefulWidget {
  String company;
  String projectName;
  String position;
  WorkersPage(this.company, this.projectName, this.position);
  @override
  _WorkersPageState createState() => _WorkersPageState();
}

class _WorkersPageState extends State<WorkersPage> {
  var workersCount = List<String>(workers.length);
  var values = List<String>(workers.length);
  var minusCount = [false, false, false, false];
  var plusCount = [false, false, false, false];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DbService()
            .db
            .collection("company")
            .document(widget.company)
            .collection("project")
            .document(widget.projectName)
            .collection("workers")
            .orderBy("date", descending: true)
            .limit(1)
            .snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(child: CircularProgressIndicator())
              : Scaffold(
                  body: Container(
                    color: grey,
                    child: ListView.builder(
                        itemCount: workers.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(workers[index]),
                            trailing: widget.position != "Contractor"
                                ? Text(snapshot.data.documents[0]
                                        [workers[index]] ??
                                    "0")
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          if ((int.parse(
                                                  snapshot.data.documents[0]
                                                      [workers[index]])) !=
                                              null) {
                                            if (minusCount[index]) {
                                              workersCount[index] = (int.parse(
                                                          workersCount[index]) -
                                                      1)
                                                  .toString();
                                              setState(() {
                                                values[index] =
                                                    workersCount[index];
                                              });
                                            } else {
                                              workersCount[index] = (int.parse(
                                                          snapshot.data
                                                                  .documents[0][
                                                              workers[index]]) -
                                                      1)
                                                  .toString();
                                              setState(() {
                                                values[index] =
                                                    workersCount[index];
                                                minusCount[index] = true;
                                                plusCount[index] = true;
                                              });
                                            }
                                          }
                                        },
                                      ),
                                      Text(values[index] != null
                                          ? values[index]
                                          : snapshot.data.documents[0]
                                                  [workers[index]] ??
                                              "0"),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: green,
                                        ),
                                        onPressed: () {
                                          if (plusCount[index]) {
                                            workersCount[index] = (int.parse(
                                                        workersCount[index]) +
                                                    1)
                                                .toString();
                                            setState(() {
                                              values[index] =
                                                  workersCount[index];
                                            });
                                          } else {
                                            workersCount[index] = (int.parse(
                                                        snapshot.data
                                                                .documents[0]
                                                            [workers[index]]) +
                                                    1)
                                                .toString();
                                            setState(() {
                                              values[index] =
                                                  workersCount[index];
                                              plusCount[index] = true;
                                              minusCount[index] = true;
                                            });
                                          }
                                        },
                                      )
                                    ],
                                  ),
                          );
                        }),
                  ),
                  floatingActionButton: widget.position != "Contractor"
                      ? null
                      : FloatingActionButton(
                          backgroundColor: Colors.red,
                          child: Icon(Icons.save),
                          onPressed: () async {
                            var newCount = List<String>(workers.length);
                            var date =
                                DateFormat('dd-MM-yyyy').format(DateTime.now());

                            for (var i = 0; i < workers.length; i++) {
                              if (workersCount[i] != null) {
                                newCount[i] = workersCount[i];
                              } else {
                                newCount[i] =
                                    snapshot.data.documents[0][workers[i]];
                              }
                            }
                            var monthYear =
                                DateFormat('MM-yyyy').format(DateTime.now());
                            var worker = Workers(
                                widget.projectName,
                                newCount[0],
                                newCount[1],
                                newCount[2],
                                newCount[3],
                                date,
                                monthYear);
                            await DbService().addWorekers(widget.company,
                                widget.projectName, date, worker);
                          },
                        ),
                );
        });
  }
}
