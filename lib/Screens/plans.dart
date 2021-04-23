import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Service/dbService.dart';
import 'package:flutter_app/Utils/utils.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Plans extends StatefulWidget {
  String company;
  String projectName;
  String position;
  Plans(this.company, this.projectName, this.position);
  @override
  _PlansState createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: grey,
          title: Text("PLANS", style: TextStyle(color: black)),
          centerTitle: true,
        ),
        backgroundColor: grey,
        body: Container(
          child: Column(
            children: [
              ListTile(
                title: Text("Architecture"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ArchitecurePlan(widget.company,
                            widget.projectName, widget.position))),
              ),
              Divider(
                thickness: 1.5,
              ),
              ListTile(
                title: Text("Structure"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => StructurePlan(widget.company,
                            widget.projectName, widget.position))),
              ),
              Divider(
                thickness: 1.5,
              ),
              ListTile(
                title: Text("Electrical"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ElectricalPlan(widget.company,
                            widget.projectName, widget.position))),
              ),
              Divider(
                thickness: 1.5,
              ),
              ListTile(
                title: Text("Plumbing"),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PlumbingPlan(widget.company,
                            widget.projectName, widget.position))),
              ),
              Divider(
                thickness: 1.5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArchitecurePlan extends StatefulWidget {
  String company;
  String projectName;
  String position;
  ArchitecurePlan(this.company, this.projectName, this.position);
  @override
  _ArchitecurePlanState createState() => _ArchitecurePlanState();
}

class _ArchitecurePlanState extends State<ArchitecurePlan> {
  var name;
  var fileName;
  File pdf;
  var nameController = TextEditingController();
  showConfirmBox(String filename) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Confirm"),
              content: Text(filename),
              actions: [
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  showNameBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Enter File Name"),
              content: TextFormField(
                controller: nameController,
              ),
              actions: [
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Confirm"),
                  onPressed: () async {
                    name = nameController.text;
                    Navigator.pop(context);
                    var result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                        allowCompression: true);
                    if (result != null) {
                      pdf = File(result.files.single.path);
                      fileName = result.files.single.name;
                      showConfirmBox(result.files.single.name);
                    }
                    var date = DateFormat('dd-MM-yyyy').format(DateTime.now());
                    await DbService().addPlansArchitecture(
                        widget.company, widget.projectName, date, name, pdf);
                  },
                )
              ],
            ));
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
            .collection("plansArchitecture")
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: grey,
                title: Text(
                  "ARCHITECTURE",
                  style: TextStyle(color: black),
                ),
                centerTitle: true,
              ),
              backgroundColor: grey,
              body: !snapshot.hasData
                  ? Center(
                      child: Text("No Files",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0)),
                    )
                  : snapshot.data.documents.length != 1
                      ? Container(
                          child: ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) => index != 1
                                  ? Column(
                                      children: [
                                        ListTile(
                                            title: Text(snapshot
                                                .data.documents[index]['name']),
                                            trailing: Icon(
                                              Icons.file_download,
                                              color: black,
                                            ),
                                            onTap: () async {
                                              FlutterDownloader.initialize();
                                              Directory dir =
                                                  await getExternalStorageDirectory();
                                              String path = dir.path;
                                              print(path);
                                              await FlutterDownloader.enqueue(
                                                      url: snapshot.data
                                                              .documents[index]
                                                          ['file'],
                                                      savedDir: path,
                                                      fileName: snapshot.data
                                                                  .documents[
                                                              index]['name'] +
                                                          '.pdf',
                                                      showNotification: true,
                                                      openFileFromNotification:
                                                          true)
                                                  .whenComplete(() async {
                                                await OpenFile.open(path +
                                                    '/' +
                                                    snapshot.data
                                                            .documents[index]
                                                        ['name'] +
                                                    '.pdf');
                                              });
                                            }),
                                        Divider(
                                          thickness: 1.5,
                                        )
                                      ],
                                    )
                                  : Center(
                                      child: Text("No Files",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0)),
                                    )),
                        )
                      : Center(
                          child: Text("No Files",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0)),
                        ),
              floatingActionButton: widget.position != "Contractor"
                  ? null
                  : FloatingActionButton(
                      child: Icon(
                        Icons.file_upload,
                        color: white,
                      ),
                      backgroundColor: Colors.red,
                      onPressed: () async {
                        showNameBox();
                      },
                    ),
            ),
          );
        });
  }
}

class StructurePlan extends StatefulWidget {
  String company;
  String projectName;
  String position;
  StructurePlan(this.company, this.projectName, this.position);
  @override
  _StructurePlanState createState() => _StructurePlanState();
}

class _StructurePlanState extends State<StructurePlan> {
  var name;
  var fileName;
  File pdf;
  var nameController = TextEditingController();
  showConfirmBox(String filename) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Confirm"),
              content: Text(filename),
              actions: [
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  showNameBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Enter File Name"),
              content: TextFormField(
                controller: nameController,
              ),
              actions: [
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Confirm"),
                  onPressed: () async {
                    name = nameController.text;
                    Navigator.pop(context);
                    var result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                        allowCompression: true);
                    if (result != null) {
                      pdf = File(result.files.single.path);
                      fileName = result.files.single.name;
                      showConfirmBox(result.files.single.name);
                    }
                    var date = DateFormat('dd-MM-yyyy').format(DateTime.now());
                    await DbService().addPlansStructure(
                        widget.company, widget.projectName, date, name, pdf);
                  },
                )
              ],
            ));
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
            .collection("plansStructure")
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: grey,
                title: Text(
                  "STRUCTURE",
                  style: TextStyle(color: black),
                ),
                centerTitle: true,
              ),
              backgroundColor: grey,
              body: !snapshot.hasData
                  ? Center(
                      child: Text("No Files",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0)),
                    )
                  : snapshot.data.documents.length != 1
                      ? Container(
                          child: ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) => index != 1
                                  ? Column(
                                      children: [
                                        ListTile(
                                            title: Text(snapshot
                                                .data.documents[index]['name']),
                                            trailing: Icon(
                                              Icons.file_download,
                                              color: black,
                                            ),
                                            onTap: () async {
                                              FlutterDownloader.initialize();
                                              Directory dir =
                                                  await getExternalStorageDirectory();
                                              String path = dir.path;
                                              print(path);
                                              await FlutterDownloader.enqueue(
                                                      url: snapshot.data
                                                              .documents[index]
                                                          ['file'],
                                                      savedDir: path,
                                                      fileName: snapshot.data
                                                                  .documents[
                                                              index]['name'] +
                                                          '.pdf',
                                                      showNotification: true,
                                                      openFileFromNotification:
                                                          true)
                                                  .whenComplete(() async {
                                                await OpenFile.open(path +
                                                    '/' +
                                                    snapshot.data
                                                            .documents[index]
                                                        ['name'] +
                                                    '.pdf');
                                              });
                                            }),
                                        Divider(
                                          thickness: 1.5,
                                        )
                                      ],
                                    )
                                  : Center(
                                      child: Text("No Files",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0)),
                                    )),
                        )
                      : Center(
                          child: Text("No Files",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0)),
                        ),
              floatingActionButton: widget.position != "Contractor"
                  ? null
                  : FloatingActionButton(
                      child: Icon(
                        Icons.file_upload,
                        color: white,
                      ),
                      backgroundColor: Colors.red,
                      onPressed: () async {
                        showNameBox();
                      },
                    ),
            ),
          );
        });
  }
}

class ElectricalPlan extends StatefulWidget {
  String company;
  String projectName;
  String position;
  ElectricalPlan(this.company, this.projectName, this.position);
  @override
  _ElectricalPlanState createState() => _ElectricalPlanState();
}

class _ElectricalPlanState extends State<ElectricalPlan> {
  var name;
  var fileName;
  File pdf;
  var nameController = TextEditingController();
  showConfirmBox(String filename) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Confirm"),
              content: Text(filename),
              actions: [
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  showNameBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Enter File Name"),
              content: TextFormField(
                controller: nameController,
              ),
              actions: [
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Confirm"),
                  onPressed: () async {
                    name = nameController.text;
                    Navigator.pop(context);
                    var result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                        allowCompression: true);
                    if (result != null) {
                      pdf = File(result.files.single.path);
                      fileName = result.files.single.name;
                      showConfirmBox(result.files.single.name);
                    }
                    var date = DateFormat('dd-MM-yyyy').format(DateTime.now());
                    await DbService().addPlansElectrical(
                        widget.company, widget.projectName, date, name, pdf);
                  },
                )
              ],
            ));
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
            .collection("plansElectrical")
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: grey,
                title: Text(
                  "ELECTRICAL",
                  style: TextStyle(color: black),
                ),
                centerTitle: true,
              ),
              backgroundColor: grey,
              body: !snapshot.hasData
                  ? Center(
                      child: Text("No Files",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0)),
                    )
                  : snapshot.data.documents.length != 1
                      ? Container(
                          child: ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) => index != 1
                                  ? Column(
                                      children: [
                                        ListTile(
                                            title: Text(snapshot
                                                .data.documents[index]['name']),
                                            trailing: Icon(
                                              Icons.file_download,
                                              color: black,
                                            ),
                                            onTap: () async {
                                              FlutterDownloader.initialize();
                                              Directory dir =
                                                  await getExternalStorageDirectory();
                                              String path = dir.path;
                                              print(path);
                                              await FlutterDownloader.enqueue(
                                                      url: snapshot.data
                                                              .documents[index]
                                                          ['file'],
                                                      savedDir: path,
                                                      fileName: snapshot.data
                                                                  .documents[
                                                              index]['name'] +
                                                          '.pdf',
                                                      showNotification: true,
                                                      openFileFromNotification:
                                                          true)
                                                  .whenComplete(() async {
                                                await OpenFile.open(path +
                                                    '/' +
                                                    snapshot.data
                                                            .documents[index]
                                                        ['name'] +
                                                    '.pdf');
                                              });
                                            }),
                                        Divider(
                                          thickness: 1.5,
                                        )
                                      ],
                                    )
                                  : Center(
                                      child: Text("No Files",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0)),
                                    )),
                        )
                      : Center(
                          child: Text("No Files",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0)),
                        ),
              floatingActionButton: widget.position != "Contractor"
                  ? null
                  : FloatingActionButton(
                      child: Icon(
                        Icons.file_upload,
                        color: white,
                      ),
                      backgroundColor: Colors.red,
                      onPressed: () async {
                        showNameBox();
                      },
                    ),
            ),
          );
        });
  }
}

class PlumbingPlan extends StatefulWidget {
  String company;
  String projectName;
  String position;
  PlumbingPlan(this.company, this.projectName, this.position);
  @override
  _PlumbingPlanState createState() => _PlumbingPlanState();
}

class _PlumbingPlanState extends State<PlumbingPlan> {
  var name;
  var fileName;
  File pdf;
  var nameController = TextEditingController();
  showConfirmBox(String filename) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Confirm"),
              content: Text(filename),
              actions: [
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Confirm"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  showNameBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Enter File Name"),
              content: TextFormField(
                controller: nameController,
              ),
              actions: [
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Confirm"),
                  onPressed: () async {
                    name = nameController.text;
                    Navigator.pop(context);
                    var result = await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                        allowCompression: true);
                    if (result != null) {
                      pdf = File(result.files.single.path);
                      fileName = result.files.single.name;
                      showConfirmBox(result.files.single.name);
                    }
                    var date = DateFormat('dd-MM-yyyy').format(DateTime.now());
                    await DbService().addPlansPlumbing(
                        widget.company, widget.projectName, date, name, pdf);
                  },
                )
              ],
            ));
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
            .collection("plansPlumbing")
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: grey,
                title: Text(
                  "PLUMBING",
                  style: TextStyle(color: black),
                ),
                centerTitle: true,
              ),
              backgroundColor: grey,
              body: !snapshot.hasData
                  ? Center(
                      child: Text("No Files",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0)),
                    )
                  : snapshot.data.documents.length != 1
                      ? Container(
                          child: ListView.builder(
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) => index != 1
                                  ? Column(
                                      children: [
                                        ListTile(
                                            title: Text(snapshot
                                                .data.documents[index]['name']),
                                            trailing: Icon(
                                              Icons.file_download,
                                              color: black,
                                            ),
                                            onTap: () async {
                                              FlutterDownloader.initialize();
                                              Directory dir =
                                                  await getExternalStorageDirectory();
                                              String path = dir.path;
                                              print(path);
                                              await FlutterDownloader.enqueue(
                                                      url: snapshot.data
                                                              .documents[index]
                                                          ['file'],
                                                      savedDir: path,
                                                      fileName: snapshot.data
                                                                  .documents[
                                                              index]['name'] +
                                                          '.pdf',
                                                      showNotification: true,
                                                      openFileFromNotification:
                                                          true)
                                                  .whenComplete(() async {
                                                await OpenFile.open(path +
                                                    '/' +
                                                    snapshot.data
                                                            .documents[index]
                                                        ['name'] +
                                                    '.pdf');
                                              });
                                            }),
                                        Divider(
                                          thickness: 1.5,
                                        )
                                      ],
                                    )
                                  : Center(
                                      child: Text("No Files",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0)),
                                    )),
                        )
                      : Center(
                          child: Text("No Files",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0)),
                        ),
              floatingActionButton: widget.position != "Contractor"
                  ? null
                  : FloatingActionButton(
                      child: Icon(
                        Icons.file_upload,
                        color: white,
                      ),
                      backgroundColor: Colors.red,
                      onPressed: () async {
                        showNameBox();
                      },
                    ),
            ),
          );
        });
  }
}
