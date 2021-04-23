import 'package:flutter/material.dart';
import 'package:flutter_app/Model/equipmentsModel.dart';
import 'package:flutter_app/Service/dbService.dart';
import 'package:flutter_app/Utils/utils.dart';
import 'package:intl/intl.dart';

class Equipments extends StatefulWidget {
  String company;
  String projectName;
  String position;
  Equipments(this.company, this.projectName, this.position);
  @override
  _EquipmentsState createState() => _EquipmentsState();
}

class _EquipmentsState extends State<Equipments> {
  var equipmentNumber = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  var equipmentHour = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  var equipmentNumberFocus = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  var equipmentHourFocus = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  var equipNumber = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];
  var equipHour = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DbService()
            .db
            .collection("company")
            .document(widget.company)
            .collection("project")
            .document(widget.projectName)
            .collection("equipments")
            .orderBy('date', descending: true)
            .limit(1)
            .snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Scaffold(
                  backgroundColor: grey,
                  body: Container(
                    child: ListView.builder(
                        itemCount: equipments.length,
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            key: GlobalKey(),
                            title: Center(child: Text(equipments[index])),
                            children: [
                              ListTile(
                                title: Text("No of Equipments"),
                                trailing: widget.position != "Contractor"
                                    ? Text(snapshot.data.documents[0]
                                        [equipments[index] + ' Number'])
                                    : Container(
                                        width: 165,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 70,
                                              child: TextFormField(
                                                  focusNode:
                                                      equipmentNumberFocus[
                                                          index],
                                                  controller:
                                                      equipmentNumber[index],
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      hintText: snapshot.data
                                                                  .documents[0][
                                                              equipments[
                                                                      index] +
                                                                  ' Number'] ??
                                                          "0",
                                                      hintStyle: TextStyle(
                                                          color: black)),
                                                  onSaved: (value) {
                                                    equipmentNumber[index]
                                                        .text = value;
                                                  }),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            RaisedButton(
                                                child: Text(
                                                  "Update",
                                                  style:
                                                      TextStyle(color: white),
                                                ),
                                                color: blue,
                                                onPressed: () {
                                                  equipNumber[index] =
                                                      equipmentNumber[index]
                                                          .text;
                                                  equipmentNumberFocus[index]
                                                      .unfocus();
                                                }),
                                          ],
                                        ),
                                      ),
                              ),
                              ListTile(
                                title: Text("No of Hours"),
                                trailing: widget.position != "Contractor"
                                    ? Text(snapshot.data.documents[0]
                                        [equipments[index] + ' Hour'])
                                    : Container(
                                        width: 165,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 70,
                                              child: TextFormField(
                                                  focusNode:
                                                      equipmentHourFocus[index],
                                                  controller:
                                                      equipmentHour[index],
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      hintText: snapshot.data
                                                                  .documents[0][
                                                              equipments[
                                                                      index] +
                                                                  ' Hour'] ??
                                                          "0",
                                                      hintStyle: TextStyle(
                                                          color: black)),
                                                  onSaved: (value) {
                                                    equipmentHour[index].text =
                                                        value;
                                                  }),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            RaisedButton(
                                                child: Text(
                                                  "Update",
                                                  style:
                                                      TextStyle(color: white),
                                                ),
                                                color: blue,
                                                onPressed: () {
                                                  equipHour[index] =
                                                      equipmentHour[index].text;
                                                  equipmentHourFocus[index]
                                                      .unfocus();
                                                  // FocusScope.of(context).unfocus();
                                                }),
                                          ],
                                        ),
                                      ),
                              )
                            ],
                          );
                        }),
                  ),
                  floatingActionButton: widget.position != "Contractor"
                      ? null
                      : FloatingActionButton(
                          child: Icon(Icons.save),
                          backgroundColor: Colors.red,
                          onPressed: () async {
                            var number = List<String>(equipments.length);
                            var hour = List<String>(equipments.length);
                            for (var i = 0; i < equipments.length; i++) {
                              if (equipNumber[i] !=
                                      snapshot.data.documents[0]
                                          [equipments[i] + ' Number'] &&
                                  equipNumber[i] != "") {
                                number[i] = equipNumber[i];
                              } else {
                                number[i] = snapshot.data.documents[0]
                                    [equipments[i] + ' Number'];
                              }
                              if (equipHour[i] !=
                                      snapshot.data.documents[0]
                                          [equipments[i] + ' Hour'] &&
                                  equipHour[i] != "") {
                                hour[i] = equipHour[i];
                              } else {
                                hour[i] = snapshot.data.documents[0]
                                    [equipments[i] + ' Hour'];
                              }
                            }

                            var date =
                                DateFormat('dd-MM-yyyy').format(DateTime.now());
                            var monthYear =
                                DateFormat('MM-yyyy').format(DateTime.now());
                            var equipmentModel = EquipmentsModel(
                                widget.projectName,
                                number[0],
                                hour[0],
                                number[1],
                                hour[1],
                                number[2],
                                hour[2],
                                number[3],
                                hour[3],
                                number[4],
                                hour[4],
                                number[5],
                                hour[5],
                                number[6],
                                hour[6],
                                date,
                                monthYear);
                            await DbService().addEquipment(widget.company,
                                widget.projectName, date, equipmentModel);
                          },
                        ),
                );
        });
  }
}
