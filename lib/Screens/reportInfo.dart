import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/dailyReport.dart';
import 'package:flutter_app/Screens/monthlyReport.dart';
import 'package:flutter_app/Utils/utils.dart';

class ReportInfo extends StatefulWidget {
  String company;
  String projectName;
  ReportInfo(this.company, this.projectName);
  @override
  _ReportInfoState createState() => _ReportInfoState();
}

class _ReportInfoState extends State<ReportInfo> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: ListTile(
            leading: Icon(
              Icons.border_color,
              color: black,
            ),
            title: Text(
              "REPORTS",
              style: TextStyle(
                  color: black, fontWeight: FontWeight.w500, fontSize: 20),
            ),
          ),
          centerTitle: true,
          backgroundColor: grey,
        ),
        body: Container(
          color: grey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: Text(
                  "Daily Report",
                  style: TextStyle(fontSize: 20),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  print("pressed daily report");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DailyReport(widget.company, widget.projectName),
                      ));
                },
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Monthly Report",
                  style: TextStyle(fontSize: 20),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  print("pressed monthly report");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MonthlyReport(widget.company, widget.projectName),
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
