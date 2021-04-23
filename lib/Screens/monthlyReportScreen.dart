import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as materialPage;
import 'package:flutter_app/Screens/pdfViewerPage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as widgetImport;
import 'package:flutter_app/Service/dbService.dart';
import 'package:flutter_app/Utils/utils.dart';

class MonthlyReportScreen extends StatefulWidget {
  String company;
  String projectName;
  String month;
  String year;
  MonthlyReportScreen(this.company, this.projectName, this.month, this.year);
  @override
  _MonthlyReportScreenState createState() => _MonthlyReportScreenState();
}

class _MonthlyReportScreenState extends State<MonthlyReportScreen> {
  var detailsMaterialTotal = [];
  var detailsMaterialAvailable = [];
  var detailsMaterialDates = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DbService()
            .db
            .collection("company")
            .document(widget.company)
            .collection("project")
            .document(widget.projectName)
            .collection("materials")
            .snapshots(),
        builder: (context, snapshotMaterial) {
          if (snapshotMaterial.hasData) {
            for (var i = 0; i < snapshotMaterial.data.documents.length; i++) {
              if (snapshotMaterial.data.documents[i]['monthYear'] ==
                  '${widget.month}-${widget.year}') {
                for (var j = 0; j < materials.length; j++) {
                  detailsMaterialTotal.add(snapshotMaterial.data.documents[i]
                      [materials[j] + 'Total']);
                  detailsMaterialAvailable.add(snapshotMaterial
                      .data.documents[i][materials[j] + 'Available']);
                  detailsMaterialDates
                      .add(snapshotMaterial.data.documents[i]['date']);
                }
              }
            }
          }

          return !snapshotMaterial.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : DummyPage1(
                  widget.company,
                  widget.projectName,
                  widget.month,
                  widget.year,
                  detailsMaterialTotal,
                  detailsMaterialAvailable,
                  detailsMaterialDates);
        });
  }
}

class DummyPage1 extends StatefulWidget {
  String company;
  String projectName;
  String month;
  String year;
  var materialsTotal;
  var materialsAvailable;
  var materialsDate;

  DummyPage1(this.company, this.projectName, this.month, this.year,
      this.materialsTotal, this.materialsAvailable, this.materialsDate);
  @override
  _DummyPage1State createState() => _DummyPage1State();
}

class _DummyPage1State extends State<DummyPage1> {
  var workersNumber = [];
  var workersDate = [];
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
            .snapshots(),
        builder: (context, snapshotWorkers) {
          if (snapshotWorkers.hasData) {
            for (var i = 0; i < snapshotWorkers.data.documents.length; i++) {
              if (snapshotWorkers.data.documents[i]['monthYear'] ==
                  '${widget.month}-${widget.year}') {
                for (var j = 0; j < workers.length; j++) {
                  workersNumber
                      .add(snapshotWorkers.data.documents[i][workers[j]]);
                  workersDate.add(snapshotWorkers.data.documents[i]['date']);
                }
              }
            }
          }
          return !snapshotWorkers.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : DummyPage2(
                  widget.company,
                  widget.projectName,
                  widget.month,
                  widget.year,
                  widget.materialsTotal,
                  widget.materialsAvailable,
                  widget.materialsDate,
                  workersNumber,
                  workersDate);
        });
  }
}

class DummyPage2 extends StatefulWidget {
  String company;
  String projectName;
  String month;
  String year;

  var materialsTotal;
  var materialsAvailable;
  var materialsDate;
  var workersNumber;
  var workersDate;
  DummyPage2(
      this.company,
      this.projectName,
      this.month,
      this.year,
      this.materialsTotal,
      this.materialsAvailable,
      this.materialsDate,
      this.workersNumber,
      this.workersDate);
  @override
  _DummyPage2State createState() => _DummyPage2State();
}

class _DummyPage2State extends State<DummyPage2> {
  var taskDone = [];
  var taskDate = [];
  monthlyReportScreen(context, materialsTotal, materialsAvaiable, materialsDate,
      workersNumber, workersDate, taskDone, taskDate) async {
    print(materialsTotal.length);
    var materialIndex = materialsTotal.length != 0
        ? materialsTotal.length - materials.length
        : 0;

    var workerIndex = workersNumber.length - workers.length;

    var taskIndex = taskDone.length != 0 ? taskDone.length - tasks.length : 0;

    final widgetImport.Document pdf = widgetImport.Document();
    pdf.addPage(widgetImport.MultiPage(
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: widgetImport.CrossAxisAlignment.start,
        header: (context) {
          if (context.pageNumber == 1) {
            return null;
          }
          return widgetImport.Container(
              alignment: widgetImport.Alignment.centerRight,
              margin: const widgetImport.EdgeInsets.only(
                  bottom: 3.0 * PdfPageFormat.mm),
              padding: const widgetImport.EdgeInsets.only(
                  bottom: 3.0 * PdfPageFormat.mm),
              child: widgetImport.Text('Report',
                  style: widgetImport.TextStyle(color: PdfColors.grey)));
        },
        build: (context) => <widgetImport.Widget>[
              widgetImport.Header(
                  level: 0,
                  child: widgetImport.Row(
                      mainAxisAlignment:
                          widgetImport.MainAxisAlignment.spaceBetween,
                      children: [
                        widgetImport.Text(
                            'Report - ${widget.month}-${widget.year}'),
                        widgetImport.PdfLogo()
                      ])),
              widgetImport.Header(level: 1, text: 'Materials'),
              widgetImport.Table
                  .fromTextArray(context: context, data: <List<String>>[
                <String>['Material', 'Available', 'Used', 'Total'],
                <String>[
                  materials[0],
                  materialsAvaiable.length != 0
                      ? materialsAvaiable[materialIndex]
                      : '0',
                  materialsAvaiable.length != 0
                      ? (double.parse(materialsTotal[materialIndex]) -
                              double.parse(materialsAvaiable[materialIndex]))
                          .toString()
                      : '0',
                  materialsTotal.length != 0
                      ? materialsTotal[materialIndex]
                      : '0'
                ],
                <String>[
                  materials[1],
                  materialsAvaiable.length != 0
                      ? materialsAvaiable[materialIndex + 1]
                      : '0',
                  materialsAvaiable.length != 0
                      ? (double.parse(materialsTotal[materialIndex + 1]) -
                              double.parse(
                                  materialsAvaiable[materialIndex + 1]))
                          .toString()
                      : '0',
                  materialsTotal.length != 0
                      ? materialsTotal[materialIndex + 1]
                      : '0'
                ],
                <String>[
                  materials[2],
                  materialsAvaiable.length != 0
                      ? materialsAvaiable[materialIndex + 2]
                      : '0',
                  materialsAvaiable.length != 0
                      ? (double.parse(materialsTotal[materialIndex + 2]) -
                              double.parse(
                                  materialsAvaiable[materialIndex + 2]))
                          .toString()
                      : '0',
                  materialsTotal.length != 0
                      ? materialsTotal[materialIndex + 2]
                      : '0'
                ],
                <String>[
                  materials[3],
                  materialsAvaiable.length != 0
                      ? materialsAvaiable[materialIndex + 3]
                      : '0',
                  materialsAvaiable.length != 0
                      ? (double.parse(materialsTotal[materialIndex + 3]) -
                              double.parse(
                                  materialsAvaiable[materialIndex + 3]))
                          .toString()
                      : '0',
                  materialsTotal.length != 0
                      ? materialsTotal[materialIndex + 3]
                      : '0'
                ],
                <String>[
                  materials[4],
                  materialsAvaiable.length != 0
                      ? materialsAvaiable[materialIndex + 4]
                      : '0',
                  materialsAvaiable.length != 0
                      ? (double.parse(materialsTotal[materialIndex + 4]) -
                              double.parse(
                                  materialsAvaiable[materialIndex + 4]))
                          .toString()
                      : '0',
                  materialsTotal.length != 0
                      ? materialsTotal[materialIndex + 4]
                      : '0'
                ],
                <String>[
                  materials[5],
                  materialsAvaiable.length != 0
                      ? materialsAvaiable[materialIndex + 5]
                      : '0',
                  materialsAvaiable.length != 0
                      ? (double.parse(materialsTotal[materialIndex + 5]) -
                              double.parse(
                                  materialsAvaiable[materialIndex + 5]))
                          .toString()
                      : '0',
                  materialsTotal.length != 0
                      ? materialsTotal[materialIndex + 5]
                      : '0'
                ],
                <String>[
                  materials[6],
                  materialsAvaiable.length != 0
                      ? materialsAvaiable[materialIndex + 6]
                      : '0',
                  materialsAvaiable.length != 0
                      ? (double.parse(materialsTotal[materialIndex + 6]) -
                              double.parse(
                                  materialsAvaiable[materialIndex + 6]))
                          .toString()
                      : '0',
                  materialsTotal.length != 0
                      ? materialsTotal[materialIndex + 6]
                      : '0'
                ],
                <String>[
                  materials[7],
                  materialsAvaiable.length != 0
                      ? materialsAvaiable[materialIndex + 7]
                      : '0',
                  materialsAvaiable.length != 0
                      ? (double.parse(materialsTotal[materialIndex + 7]) -
                              double.parse(
                                  materialsAvaiable[materialIndex + 7]))
                          .toString()
                      : '0',
                  materialsTotal.length != 0
                      ? materialsTotal[materialIndex + 7]
                      : '0'
                ],
              ]),
              widgetImport.Header(level: 1, text: 'Tasks'),
              widgetImport.Table.fromTextArray(
                  context: context,
                  data: <List<String>>[
                    <String>['Task', 'Done'],
                    <String>[
                      tasks[0],
                      taskDone.length != 0 ? taskDone[taskIndex] : 'false'
                    ],
                    <String>[
                      tasks[1],
                      taskDone.length != 0 ? taskDone[taskIndex + 1] : 'false'
                    ],
                    <String>[
                      tasks[2],
                      taskDone.length != 0 ? taskDone[taskIndex + 2] : 'false'
                    ],
                    <String>[
                      tasks[3],
                      taskDone.length != 0 ? taskDone[taskIndex + 3] : 'false'
                    ],
                    <String>[
                      tasks[4],
                      taskDone.length != 0 ? taskDone[taskIndex + 4] : 'false'
                    ],
                    <String>[
                      tasks[5],
                      taskDone.length != 0 ? taskDone[taskIndex + 5] : 'false'
                    ],
                    <String>[
                      tasks[6],
                      taskDone.length != 0 ? taskDone[taskIndex + 6] : 'false'
                    ],
                    <String>[
                      tasks[7],
                      taskDone.length != 0 ? taskDone[taskIndex + 7] : 'false'
                    ],
                    <String>[
                      tasks[8],
                      taskDone.length != 0 ? taskDone[taskIndex + 8] : 'false'
                    ],
                  ])
            ]));
    final String dir = (await getExternalStorageDirectory()).path;
    final path = '$dir/${widget.month}-${widget.year}.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdf.save());
    materialPage.Navigator.push(
        context,
        materialPage.MaterialPageRoute(
            builder: (context) => PdfViewerPage(path)));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DbService()
            .db
            .collection("company")
            .document(widget.company)
            .collection("project")
            .document(widget.projectName)
            .collection("tasks")
            .snapshots(),
        builder: (context, snapshotTasks) {
          if (snapshotTasks.hasData) {
            for (var i = 0; i < snapshotTasks.data.documents.length; i++) {
              if (snapshotTasks.data.documents[i]['monthYear'] ==
                  '${widget.month}-${widget.year}') {
                for (var j = 0; j < tasks.length; j++) {
                  taskDone.add(snapshotTasks.data.documents[i][tasks[j]]);
                  taskDate.add(snapshotTasks.data.documents[i]['date']);
                }
              }
            }
          }
          return !snapshotTasks.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : monthlyReportScreen(
                  context,
                  widget.materialsTotal,
                  widget.materialsAvailable,
                  widget.materialsDate,
                  widget.workersNumber,
                  widget.workersDate,
                  taskDone,
                  taskDate);
        });
  }
}
