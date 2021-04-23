import 'package:flutter/material.dart';
import 'package:flutter_app/Service/dbService.dart';
import 'package:flutter_app/Model/materialModel.dart';
import 'package:flutter_app/Utils/utils.dart';
import 'package:intl/intl.dart';

class MaterialsPage extends StatefulWidget {
  String company;
  String projectName;
  String position;
  MaterialsPage(this.company, this.projectName, this.position);
  @override
  _MaterialsPageState createState() => _MaterialsPageState();
}

class _MaterialsPageState extends State<MaterialsPage> {
  final usage = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  var usageValues = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];
  var totalValues = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  ];
  final total = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  var totalFocus = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];
  var availableFocus = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
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
            .collection("materials")
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
                        itemCount: materials.length,
                        itemBuilder: (context, index) {
                          // print(snapshot.data.documents[0]['date']);
                          // print(snapshot.data.documents[0]['glassTotal']);
                          return ExpansionTile(
                            key: GlobalKey(),
                            leading: IconButton(
                              icon: Image.asset(materialItem[index]),
                              onPressed: () {},
                            ),
                            title: Center(child: Text(materials[index])),
                            children: [
                              ListTile(
                                title: Text("Available"),
                                trailing: widget.position != "Contractor"
                                    ? Text(snapshot.data.documents[0]
                                            [materials[index] + "Available"] ??
                                        "0.0")
                                    : Container(
                                        width: 165,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 70,
                                              child: TextFormField(
                                                  focusNode:
                                                      availableFocus[index],
                                                  controller: usage[index],
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                      hintText: snapshot.data
                                                                  .documents[
                                                              0][materials[
                                                                  index] +
                                                              "Available"] ??
                                                          "0.0",
                                                      hintStyle: TextStyle(
                                                          color: black)),
                                                  onSaved: (value) {
                                                    usageValues[index] = value;

                                                    usage[index].text = value;
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
                                                  usageValues[index] =
                                                      usage[index].text;
                                                  availableFocus[index]
                                                      .unfocus();
                                                }),
                                          ],
                                        ),
                                      ),
                              ),
                              ListTile(
                                  title: Text("Used"),
                                  trailing: Text((double.parse(
                                                  snapshot.data.documents[0][
                                                          materials[index] +
                                                              "Total"] ??
                                                      "0") -
                                              double.parse(
                                                  snapshot.data.documents[0][
                                                          materials[index] +
                                                              "Available"] ??
                                                      "0"))
                                          .toString()) ??
                                      "0.0"),
                              ListTile(
                                title: Text("Total"),
                                trailing: widget.position != "Contractor"
                                    ? Text(snapshot.data.documents[0]
                                            [materials[index] + "Total"] ??
                                        "0.0")
                                    : Container(
                                        width: 165,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 70,
                                              child: TextFormField(
                                                focusNode: totalFocus[index],
                                                controller: total[index],
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  hintText: snapshot
                                                              .data.documents[0]
                                                          [materials[index] +
                                                              "Total"] ??
                                                      "0.0",
                                                  hintStyle: TextStyle(
                                                    color: black,
                                                  ),
                                                ),
                                                onSaved: (value) {
                                                  total[index].text = value;
                                                },
                                              ),
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
                                                  totalValues[index] =
                                                      total[index].text;
                                                  totalFocus[index].unfocus();
                                                  // FocusScope.of(context).unfocus();
                                                }),
                                          ],
                                        ),
                                      ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        }),
                  ),
                  floatingActionButton: widget.position != "Contractor"
                      ? null
                      : FloatingActionButton(
                          backgroundColor: Colors.red,
                          child: Center(
                            child: Icon(
                              Icons.save,
                            ),
                          ),
                          onPressed: () async {
                            print("pressed");

                            var values = List<String>(materials.length);
                            var totalMaterial = List<String>(materials.length);
                            for (var i = 0; i < materials.length; i++) {
                              if (usageValues[i] !=
                                      snapshot.data.documents[0]
                                          [materials[i] + "Available"] &&
                                  usageValues[i] != "") {
                                values[i] = usageValues[i];
                              } else {
                                values[i] = snapshot.data.documents[0]
                                    [materials[i] + "Available"];
                              }
                              if (totalValues[i] !=
                                      snapshot.data.documents[0]
                                          [materials[i] + "Total"] &&
                                  totalValues[i] != "") {
                                totalMaterial[i] = totalValues[i];
                              } else {
                                totalMaterial[i] = snapshot.data.documents[0]
                                    [materials[i] + "Total"];
                              }
                            }

                            var date =
                                DateFormat('dd-MM-yyyy').format(DateTime.now());
                            var monthYear =
                                DateFormat('MM-yyyy').format(DateTime.now());
                            var materialModel = MaterialModel(
                                widget.projectName,
                                totalMaterial[0],
                                values[0],
                                totalMaterial[1],
                                values[1],
                                totalMaterial[2],
                                values[2],
                                totalMaterial[3],
                                values[3],
                                totalMaterial[4],
                                values[4],
                                totalMaterial[5],
                                values[5],
                                totalMaterial[6],
                                values[6],
                                totalMaterial[7],
                                values[7],
                                date,
                                monthYear);
                            await DbService().addMaterials(widget.company,
                                widget.projectName, date, materialModel);
                          },
                        ),
                );
        });
  }
}
