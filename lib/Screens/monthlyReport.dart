import 'package:flutter/material.dart';
import 'package:flutter_app/Screens/monthlyReportScreen.dart';
import 'package:flutter_app/Service/dbService.dart';
import 'package:flutter_app/Utils/utils.dart';

class MonthlyReport extends StatefulWidget {
  String company;
  String projectName;
  MonthlyReport(this.company, this.projectName);
  @override
  _MonthlyReportState createState() => _MonthlyReportState();
}

class _MonthlyReportState extends State<MonthlyReport> {
  String month = "Select Month";
  String year = "Select Year";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: grey,
        appBar: AppBar(
          title: Text(
            "MONTHLY REPORT",
            style: TextStyle(color: black),
          ),
          centerTitle: true,
          backgroundColor: grey,
        ),
        body: Container(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Text(
                  "Select Month : ",
                  style: TextStyle(fontSize: 20),
                ),
                title: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: DropdownButton(
                    // autofocus: true,
                    isExpanded: true,
                    hint: Text("Select Month....."),
                    value: month,
                    onChanged: (value) {
                      setState(() {
                        month = value;
                      });
                    },
                    items: months.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Text(
                  "Select Year : ",
                  style: TextStyle(fontSize: 20),
                ),
                title: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: DropdownButton(
                    // autofocus: true,
                    isExpanded: true,
                    hint: Text("Select Year....."),
                    value: year,
                    onChanged: (value) {
                      setState(() {
                        year = value;
                      });
                    },
                    items: years.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
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
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  onPressed: () async {
                    print("pressed");
                    // await DbService().getMaterialsMonthly(
                    //     widget.company, widget.projectName, month, year);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => MonthlyReportScreen(widget.company,
                                widget.projectName, month, year)));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
