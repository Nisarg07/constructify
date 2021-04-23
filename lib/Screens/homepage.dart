import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Model/equipmentsModel.dart';
import 'package:flutter_app/Model/materialModel.dart';
import 'package:flutter_app/Model/project.dart';
import 'package:flutter_app/Model/taskModel.dart';
import 'package:flutter_app/Model/workers.dart';
import 'package:flutter_app/Screens/projectdetails.dart';
import 'package:flutter_app/Service/authService.dart';
import 'package:flutter_app/Service/dbService.dart';
import 'package:flutter_app/Utils/utils.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  String company;
  String position;
  HomePage(this.company, this.position);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _nameController = TextEditingController();
  final _detailsController = TextEditingController();
  final detailsNode = FocusNode();
  String name;
  String details;
  String file = "Upload File(.pdf)";
  File pdf;
  String fileName;

  _showDetails(BuildContext context, company, projectName, projectDescription,
      url) async {
    showBottomSheet(
        backgroundColor: transparent,
        context: context,
        builder: (context) {
          return Container(
            // height: MediaQuery.of(context).size.height / 1.5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(projectName),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(projectDescription),
                ),
                SizedBox(
                  height: 80,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RaisedButton(
                        color: blue,
                        elevation: 8.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              width: 80,
                              child: Center(child: Text("DOWNLOAD"))),
                        ),
                        textColor: white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0))),
                        onPressed: () async {
                          // Dio dio = Dio();
                          FlutterDownloader.initialize();
                          Directory dir = await getExternalStorageDirectory();
                          String path = dir.path;
                          print(path);
                          await FlutterDownloader.enqueue(
                                  url: url,
                                  savedDir: path,
                                  fileName: projectName + '.pdf',
                                  showNotification: true,
                                  openFileFromNotification: true)
                              .whenComplete(() async {
                            await OpenFile.open(
                                path + '/' + projectName + '.pdf');
                          });
                          // await dio.download(
                          //     url, path + '/' + projectName + '.pdf');
                          Navigator.pop(context);
                        },
                      ),
                      RaisedButton(
                        color: blue,
                        elevation: 8.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              width: 80, child: Center(child: Text("GO"))),
                        ),
                        textColor: white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0))),
                        onPressed: () async {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ProjectDetailsPage(
                                      company, projectName, widget.position)));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

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

  _addProject(String company) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => Hero(
              tag: "Add Project",
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: Text(
                  "Add Project",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: grey,
                content: Container(
                  child: SingleChildScrollView(
                    child: Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              maxLength: 150,
                              controller: _nameController,
                              autofocus: false,
                              style: TextStyle(color: black),
                              decoration: InputDecoration(
                                labelText: "Name of Project",
                                labelStyle:
                                    TextStyle(color: black, fontSize: 18),
                                helperText: "",
                                border: OutlineInputBorder(),
                                counterText: "",
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter Name";
                                }
                                return null;
                              },
                              onSaved: (value) => name = value,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextFormField(
                              maxLength: 500,
                              controller: _detailsController,
                              focusNode: detailsNode,
                              autofocus: false,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              style: TextStyle(color: black),
                              decoration: InputDecoration(
                                labelText: "Details of Project",
                                labelStyle:
                                    TextStyle(color: black, fontSize: 18),
                                helperText: "",
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (value) => details = value,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "$file",
                                ),
                                IconButton(
                                  icon: Icon(Icons.file_upload),
                                  onPressed: () async {
                                    detailsNode.unfocus();
                                    var result = await FilePicker.platform
                                        .pickFiles(
                                            type: FileType.custom,
                                            allowedExtensions: ['pdf'],
                                            allowCompression: true);
                                    if (result != null) {
                                      pdf = File(result.files.single.path);
                                      fileName = result.files.single.name;
                                      showConfirmBox(result.files.single.name);
                                    }
                                    // print(pdf);
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  FlatButton(
                    child: Text("SUBMIT"),
                    onPressed: () async {
                      // File pdf;
                      var date =
                          DateFormat('dd-MM-yyyy').format(DateTime.now());
                      var monthYear =
                          DateFormat('MM-yyyy').format(DateTime.now());
                      var materialModel = MaterialModel(
                          _nameController.text,
                          "0.0",
                          "0.0",
                          "0.0",
                          "0.0",
                          "0.0",
                          "0.0",
                          "0.0",
                          "0.0",
                          "0.0",
                          "0.0",
                          "0.0",
                          "0.0",
                          "0.0",
                          "0.0",
                          "0.0",
                          "0.0",
                          date,
                          monthYear);
                      var workers = Workers(_nameController.text, "1", "0", "0",
                          "0", date, monthYear);
                      var task = TaskModel(
                          _nameController.text,
                          "false",
                          "false",
                          "false",
                          "false",
                          "false",
                          "false",
                          "false",
                          "false",
                          "false",
                          date,
                          monthYear);
                      var equipment = EquipmentsModel(
                          _nameController.text,
                          '0',
                          '0',
                          '0',
                          '0',
                          '0',
                          '0',
                          '0',
                          '0',
                          '0',
                          '0',
                          '0',
                          '0',
                          '0',
                          '0',
                          date,
                          monthYear);
                      File files;
                      var dailytask = [""];
                      Project project = Project(_nameController.text,
                          _detailsController.text, company, fileName);
                      print(pdf);
                      await DbService().addProject(
                          company, _nameController.text, project, pdf);
                      await DbService().addMaterials(
                          company, _nameController.text, date, materialModel);
                      await DbService().addWorekers(
                          company, _nameController.text, date, workers);
                      await DbService()
                          .addTask(company, _nameController.text, date, task);
                      await DbService().addEquipment(
                          company, _nameController.text, date, equipment);
                      await DbService().addFiles(company, _nameController.text,
                          date, date + "", "", files);
                      await DbService().addPlansArchitecture(
                          company, _nameController.text, date, "", files);
                      await DbService().addPlansStructure(
                          company, _nameController.text, date, "", files);
                      await DbService().addPlansElectrical(
                          company, _nameController.text, date, "", files);
                      await DbService().addPlansPlumbing(
                          company, _nameController.text, date, "", files);
                      await DbService().addDailyTask(
                          company, _nameController.text, date, dailytask);
                      _nameController.clear();
                      _detailsController.clear();
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
          stream: DbService()
              .db
              .collection("company")
              .document(widget.company)
              .collection("project")
              .snapshots(),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? Scaffold(
                    appBar: PreferredSize(
                      preferredSize: Size.fromHeight(60.0),
                      child: AppBar(
                        backgroundColor: Colors.transparent,
                        title: Text(
                          "CONSTRUCTIFY",
                          style: TextStyle(color: black),
                        ),
                        centerTitle: true,
                        elevation: 0.0,
                        actions: [
                          IconButton(
                            icon: Icon(
                              Icons.power_settings_new,
                              color: black,
                            ),
                            onPressed: () => AuthService().signOut(context),
                          )
                        ],
                        // expandedHeight: 60.0,
                        // pinned: true,
                      ),
                    ),
                    body: Center(
                        child: Container(
                      color: grey,
                      child: Center(
                        child: Text(
                          "No Projects",
                          style: TextStyle(color: black, fontSize: 18.0),
                        ),
                      ),
                    )),
                  )
                : widget.company != null && widget.position != null
                    ? Scaffold(
                        appBar: PreferredSize(
                          preferredSize: Size.fromHeight(60.0),
                          child: AppBar(
                            backgroundColor: Colors.transparent,
                            title: Text(
                              "CONSTRUCTIFY",
                              style: TextStyle(color: black),
                            ),
                            centerTitle: true,
                            elevation: 0.0,
                            actions: [
                              IconButton(
                                icon: Icon(
                                  Icons.power_settings_new,
                                  color: black,
                                ),
                                onPressed: () => AuthService().signOut(context),
                              )
                            ],
                            // expandedHeight: 60.0,
                            // pinned: true,
                          ),
                        ),
                        backgroundColor: grey,
                        body: ListView.builder(
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, index) => Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Divider(
                                      thickness: 1.5,
                                    ),
                                    ListTile(
                                      title: Center(
                                        child: Text(
                                          snapshot.data.documents[index]
                                              ['projectName'],
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                      ),
                                      trailing: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: black,
                                      ),
                                      onTap: () async {
                                        _showDetails(
                                            context,
                                            widget.company,
                                            snapshot.data.documents[index]
                                                ['projectName'],
                                            snapshot.data.documents[index]
                                                ['projectDescription'],
                                            snapshot.data.documents[index]
                                                ['url']);
                                      },
                                    ),
                                    Divider(
                                      thickness: 1.5,
                                    ),
                                  ],
                                )),
                        // CustomScrollView(
                        //   slivers: <Widget>[
                        //     PreferredSize(
                        //       preferredSize: Size.fromHeight(70.0),
                        //       child: SliverAppBar(
                        //         backgroundColor: Colors.transparent,
                        //         title: Text(
                        //           "CONSTRUCTIFY",
                        //           style: TextStyle(color: black),
                        //         ),
                        //         centerTitle: true,
                        //         elevation: 0.0,
                        //         actions: [
                        //           IconButton(
                        //             icon: Icon(
                        //               Icons.power_settings_new,
                        //               color: black,
                        //             ),
                        //             onPressed: () => AuthService().signOut(context),
                        //           )
                        //         ],
                        //         expandedHeight: 60.0,
                        //         // pinned: true,
                        //       ),
                        //     ),
                        //     SliverAnimatedList(
                        //       initialItemCount: snapshot.data.documents.length,
                        //       itemBuilder: (context, index, animation) => Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           SizedBox(
                        //             height: 10,
                        //           ),
                        //           GestureDetector(
                        //             child: Container(
                        //               height: 200,
                        //               width: 250,
                        //               decoration: BoxDecoration(
                        //                 borderRadius:
                        //                     BorderRadius.all(Radius.circular(40.0)),
                        //                 // shape: BoxShape.rectangle,
                        //                 border: Border.all(
                        //                     width: 5.0, color: Colors.white),
                        //                 color: blue,
                        //               ),
                        //               child: Center(
                        //                 child: RichText(
                        //                   text: TextSpan(children: [
                        //                     TextSpan(
                        //                         text:
                        //                             snapshot.data.documents['projectName'],
                        //                         style: TextStyle(
                        //                             color: black, fontSize: 20)),
                        //                     TextSpan(
                        //                         text: "$index",
                        //                         style: TextStyle(
                        //                             color: white,
                        //                             fontWeight: FontWeight.bold,
                        //                             fontSize: 20))
                        //                   ]),
                        //                 ),
                        //               ),
                        //             ),
                        //             onTap: () {
                        //               _showDetails(context);
                        //             },
                        //           ),
                        //           Divider(),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        floatingActionButton: widget.position == "Contractor"
                            ? FloatingActionButton(
                                onPressed: () => _addProject(widget.company),
                                child: Icon(
                                  Icons.add,
                                  size: 40,
                                ),
                                backgroundColor: Colors.red,
                              )
                            : null,
                      )
                    : Center(child: CircularProgressIndicator());
          }),
    );
  }
}
