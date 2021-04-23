import 'dart:io';

import 'package:flutter/material.dart' as materialPage;
import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/pdfViewerPage.dart';
import 'package:flutter_app/Service/dbService.dart';
import 'package:flutter_app/Utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as widgetImport;

class DailyReport extends StatefulWidget {
  String company;
  String projectName;
  DailyReport(this.company, this.projectName);
  @override
  _DailyReportState createState() => _DailyReportState();
}

class _DailyReportState extends State<DailyReport> {
  String date = "";
  dailyReportScreen(context, material, worker, task, equipment, date) async {
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
              style: widgetImport.TextStyle(color: PdfColors.grey)),
        );
      },
      build: (context) => <widgetImport.Widget>[
        widgetImport.Header(
            level: 0,
            child: widgetImport.Row(
                mainAxisAlignment: widgetImport.MainAxisAlignment.spaceBetween,
                children: [
                  widgetImport.Text('Report - $date', textScaleFactor: 2),
                  widgetImport.PdfLogo(),
                ])),
        widgetImport.Header(level: 1, text: 'Materials'),
        widgetImport.Table.fromTextArray(context: context, data: <List<String>>[
          <String>['Material', 'Available', 'Used', 'Total'],
          <String>[
            materials[0],
            material != null ? material.cementAvailable : '0',
            material != null
                ? (double.parse(material.cementTotal) -
                        double.parse(material.cementAvailable))
                    .toString()
                : '0',
            material != null ? material.cementTotal : '0'
          ],
          <String>[
            materials[1],
            material != null ? material.concreteAvailable : '0',
            material != null
                ? (double.parse(material.concreteTotal) -
                        double.parse(material.concreteAvailable))
                    .toString()
                : '0',
            material != null ? material.concreteTotal : '0'
          ],
          <String>[
            materials[2],
            material != null ? material.woodAvailable : '0',
            material != null
                ? (double.parse(material.woodTotal) -
                        double.parse(material.woodAvailable))
                    .toString()
                : '0',
            material != null ? material.woodTotal : '0'
          ],
          <String>[
            materials[3],
            material != null ? material.steelAvailable : '0',
            material != null
                ? (double.parse(material.steelTotal) -
                        double.parse(material.steelAvailable))
                    .toString()
                : '0',
            material != null ? material.steelTotal : '0'
          ],
          <String>[
            materials[4],
            material != null ? material.plasticAvailable : '0',
            material != null
                ? (double.parse(material.plasticTotal) -
                        double.parse(material.plasticAvailable))
                    .toString()
                : '0',
            material != null ? material.plasticTotal : '0'
          ],
          <String>[
            materials[5],
            material != null ? material.stoneAvailable : '0',
            material != null
                ? (double.parse(material.stoneTotal) -
                        double.parse(material.stoneAvailable))
                    .toString()
                : '0',
            material != null ? material.stoneTotal : '0'
          ],
          <String>[
            materials[6],
            material != null ? material.glassAvailable : '0',
            material != null
                ? (double.parse(material.glassTotal) -
                        double.parse(material.glassAvailable))
                    .toString()
                : '0',
            material != null ? material.glassTotal : '0'
          ],
          <String>[
            materials[7],
            material != null ? material.bricksAvailable : '0',
            material != null
                ? (double.parse(material.bricksTotal) -
                        double.parse(material.bricksAvailable))
                    .toString()
                : '0',
            material != null ? material.bricksTotal : '0'
          ],
        ]),
        widgetImport.Header(level: 1, text: 'Workers'),
        widgetImport.Table.fromTextArray(context: context, data: <List<String>>[
          <String>['', 'No. of Workers'],
          <String>[workers[0], worker != null ? worker.contractor : '1'],
          <String>[workers[1], worker != null ? worker.architecture : '0'],
          <String>[workers[2], worker != null ? worker.siteSupervisors : '0'],
          <String>[workers[3], worker != null ? worker.labours : '0'],
        ]),
        widgetImport.Header(level: 1, text: "Equipments"),
        widgetImport.Table.fromTextArray(context: context, data: <List<String>>[
          <String>["Equipment", "No of Equipment", "No of Hour"],
          <String>[
            equipments[0],
            equipment != null ? equipment.manliftNumber : '0',
            equipment != null ? equipment.manliftHour : '0'
          ],
          <String>[
            equipments[1],
            equipment != null ? equipment.jcbNumber : '0',
            equipment != null ? equipment.jcbHour : '0'
          ],
          <String>[
            equipments[2],
            equipment != null ? equipment.towerCraneNumber : '0',
            equipment != null ? equipment.towerCraneHour : '0'
          ],
          <String>[
            equipments[3],
            equipment != null ? equipment.excavatorNumber : '0',
            equipment != null ? equipment.excavatorHour : '0'
          ],
          <String>[
            equipments[4],
            equipment != null ? equipment.tractorsNumber : '0',
            equipment != null ? equipment.tractorsHour : '0'
          ],
          <String>[
            equipments[5],
            equipment != null ? equipment.loadersNumber : '0',
            equipment != null ? equipment.loadersHour : '0'
          ],
          <String>[
            equipments[6],
            equipment != null ? equipment.pileBoringEquipmentNumber : '0',
            equipment != null ? equipment.pileBoringEquipmentHour : '0'
          ],
        ]),
        widgetImport.Header(level: 1, text: 'Tasks'),
        widgetImport.Table.fromTextArray(context: context, data: <List<String>>[
          <String>['Task', 'Done'],
          <String>[tasks[0], task != null ? task.footing : 'false'],
          <String>[tasks[1], task != null ? task.masonaryWork : 'false'],
          <String>[tasks[2], task != null ? task.rccWork : 'false'],
          <String>[tasks[3], task != null ? task.plaster : 'false'],
          <String>[tasks[4], task != null ? task.plumbing : 'false'],
          <String>[tasks[5], task != null ? task.lightFitting : 'false'],
          <String>[tasks[6], task != null ? task.flooring : 'false'],
          <String>[tasks[7], task != null ? task.painting : 'false'],
          <String>[tasks[8], task != null ? task.basicFurniture : 'false'],
        ])
      ],
    ));
    final String dir = (await getExternalStorageDirectory()).path;
    final path = '$dir/$date.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdf.save());
    materialPage.Navigator.push(
        context,
        materialPage.MaterialPageRoute(
            builder: (context) => PdfViewerPage(path)));
  }

  Future _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000, 1),
        lastDate: DateTime(2100, 12));
    if (picked != null) {
      setState(() {
        date = DateFormat('dd-MM-yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: grey,
            appBar: AppBar(
              title: Text(
                "DAILY REPORT",
                style: TextStyle(color: black),
              ),
              centerTitle: true,
              backgroundColor: grey,
            ),
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Select Date : "),
                      SizedBox(
                        width: 10,
                      ),
                      date != ""
                          ? Row(
                              children: [
                                Text(date),
                                SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  onPressed: () {
                                    _selectDate(context);
                                  },
                                ),
                              ],
                            )
                          : IconButton(
                              icon: Icon(Icons.calendar_today),
                              onPressed: () {
                                _selectDate(context);
                              },
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                      color: blue,
                      elevation: 8.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: 80, child: Center(child: Text("GENERATE"))),
                      ),
                      textColor: white,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                      onPressed: () async {
                        date != "" ? print("pressed") : null;
                        var material = date != ""
                            ? await DbService().getMaterils(
                                    widget.company, widget.projectName, date) ??
                                null
                            : null;
                        var worker = date != ""
                            ? await DbService().getWorkers(
                                    widget.company, widget.projectName, date) ??
                                null
                            : null;
                        var task = date != ""
                            ? await DbService().getTasks(
                                    widget.company, widget.projectName, date) ??
                                null
                            : null;
                        var equipment = date != ""
                            ? await DbService().getEquipments(
                                    widget.company, widget.projectName, date) ??
                                null
                            : null;
                        date != ""
                            ? dailyReportScreen(context, material, worker, task,
                                equipment, date)
                            : print('');
                      }),
                ],
              ),
            )));
  }
}
