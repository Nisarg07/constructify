import 'package:flutter/material.dart';
import 'package:flutter_app/Model/person.dart';
import 'package:flutter_app/Screens/homepage.dart';
import 'package:flutter_app/Service/dbService.dart';
import 'package:flutter_app/Utils/utils.dart';

class InfoPage extends StatefulWidget {
  String phone;
  InfoPage([String phone]) {
    this.phone = phone;
  }

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _companyController = TextEditingController();
  final _form = GlobalKey<FormState>();
  String nemployee = "No of Employees";
  String position = "Choose Position";
  String _warning = "";
  @override
  void initState() {
    super.initState();
    if (widget.phone != null) {
      _phoneController.text = widget.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return (await false);
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: grey,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.80,
                child: Form(
                  key: _form,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _warning.isEmpty
                          ? SizedBox(
                              height: 0,
                            )
                          : Container(
                              color: error,
                              child: ListTile(
                                leading: Icon(Icons.error_outline),
                                title: Expanded(child: Text(_warning)),
                                trailing: IconButton(
                                  icon: Icon(Icons.cancel),
                                  onPressed: () {
                                    setState(() {
                                      _warning = "";
                                    });
                                  },
                                ),
                              ),
                            ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Info Page",
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          maxLength: 50,
                          controller: _fnameController,
                          autofocus: false,
                          style: TextStyle(color: black),
                          decoration: InputDecoration(
                            labelText: "First Name",
                            labelStyle: TextStyle(color: black, fontSize: 18),
                            helperText: "",
                            border: OutlineInputBorder(),
                            counterText: "",
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter First Name";
                            }
                            return null;
                          },
                          // onSaved: (value) => email = value,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          maxLength: 50,
                          controller: _lnameController,
                          autofocus: false,
                          style: TextStyle(color: black),
                          decoration: InputDecoration(
                            labelText: "Last Name",
                            labelStyle: TextStyle(color: black, fontSize: 18),
                            helperText: "",
                            border: OutlineInputBorder(),
                            counterText: "",
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter Last Name";
                            }
                            return null;
                          },
                          // onSaved: (value) => email = value,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          maxLength: 50,
                          controller: _phoneController,
                          autofocus: false,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(color: black),
                          decoration: InputDecoration(
                            labelText: "Phone Number",
                            labelStyle: TextStyle(color: black, fontSize: 18),
                            helperText: "",
                            border: OutlineInputBorder(),
                            counterText: "",
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter Phone Number";
                            }
                            return null;
                          },
                          // onSaved: (value) => email = value,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          maxLength: 50,
                          controller: _companyController,
                          autofocus: false,
                          style: TextStyle(color: black),
                          decoration: InputDecoration(
                            labelText: "Company",
                            labelStyle: TextStyle(color: black, fontSize: 18),
                            helperText: "",
                            border: OutlineInputBorder(),
                            counterText: "",
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter Company";
                            }
                            return null;
                          },
                          // onSaved: (value) => email = value,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DropdownButton(
                          // autofocus: true,
                          isExpanded: true,
                          hint: Text("No of Employees....."),
                          value: nemployee,
                          onChanged: (value) {
                            setState(() {
                              nemployee = value;
                            });
                          },
                          items: <String>[
                            "No of Employees",
                            "0-10",
                            "11-50",
                            "51-250",
                            "251-1000",
                            "1000+",
                          ].map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: DropdownButton(
                          // autofocus: true,
                          isExpanded: true,
                          hint: Text("Choose Position....."),
                          value: position,
                          onChanged: (value) {
                            setState(() {
                              position = value;
                            });
                          },
                          items: <String>[
                            "Choose Position",
                            "Contractor",
                            "Architecture",
                            "Site Supervisor",
                            "Labour",
                          ].map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      RaisedButton(
                        color: blue,
                        elevation: 8.0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              width: 80, child: Center(child: Text("SUBMIT"))),
                        ),
                        textColor: white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0))),
                        onPressed: () async {
                          if (_form.currentState.validate()) {
                            _form.currentState.save();
                            Person person = Person(
                                _fnameController.text,
                                _lnameController.text,
                                _phoneController.text,
                                _companyController.text,
                                nemployee,
                                position);
                            await DbService()
                                .addPerson(pref.getString("uid"), person);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => HomePage(
                                        _companyController.text, position)));
                          }
                        },
                      ),
                    ],
                  ),
                )),
          ),
        ),
      )),
    );
  }
}
