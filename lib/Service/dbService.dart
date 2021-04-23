import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_app/Model/equipmentsModel.dart';
import 'package:flutter_app/Model/materialModel.dart';
import 'package:flutter_app/Model/person.dart';
import 'package:flutter_app/Model/project.dart';
import 'package:flutter_app/Model/taskModel.dart';
import 'package:flutter_app/Model/workers.dart';
import 'package:flutter_app/Utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DbService {
  var db = Firestore.instance;

  addPerson(String id, Person person) async {
    try {
      await db.collection("person").document(id).setData(person.asMap());
    } catch (e) {
      print('error');
    }
  }

  updatePerson(String id, Person person) async {
    try {
      await db.collection("person").document(id).updateData(person.asMap());
    } catch (e) {
      print('error');
    }
  }

  Future<DocumentSnapshot> getPerson(String id) async {
    // Person person;
    try {
      var snapshot = db.collection("person").document(id).snapshots().first;
      // print((await snapshot).data['position']);
      return snapshot;
      // print(person);
      // return person;
    } catch (e) {
      print('error');
    }
  }

  addProject(String company, String id, Project project, File pdf) async {
    StorageReference ref = FirebaseStorage.instance.ref().child(id);
    StorageUploadTask uploadTask = ref.putFile(pdf);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    String url = await taskSnapshot.ref.getDownloadURL();
    pref = await SharedPreferences.getInstance();
    pref.setString('url', url);
    var projectDetails = Map<String,
        dynamic>(); // = {}..addAll(project.asMap())..addAll({'url': url});
    projectDetails.addAll(project.asMap());
    projectDetails.addAll({'url': url});
    try {
      await db
          .collection("company")
          .document(company)
          .collection("project")
          .document(id)
          .setData(projectDetails);
    } catch (e) {
      print(e);
    }
  }

  Future<Stream<QuerySnapshot>> getProject(String company) async {
    try {
      var snapshot = db
          .collection("company")
          .document(company)
          .collection("project")
          .snapshots();
      return snapshot;
    } catch (e) {
      print(e);
    }
  }

  addMaterials(String company, String id, String date,
      MaterialModel materialModel) async {
    try {
      await db
          .collection("company")
          .document(company)
          .collection("project")
          .document(id)
          .collection("materials")
          .document(date)
          .setData(materialModel.asMap());
    } catch (e) {
      print('error');
    }
  }

  updateMaterials(String company, String id, String date,
      MaterialModel materialModel) async {
    try {
      await db
          .collection("company")
          .document(company)
          .collection("project")
          .document(id)
          .collection("materials")
          .document(date)
          .updateData(materialModel.asMap());
    } catch (e) {
      print('error');
    }
  }

  getMaterils(String company, String id, String date) async {
    var snapshot = db
        .collection("company")
        .document(company)
        .collection("project")
        .document(id)
        .collection("materials")
        .document(date)
        .get();
    try {
      var material = MaterialModel.fromDocument(await snapshot);
      return material;
    } catch (e) {
      return null;
    }
  }

  getMaterialsMonthly(
      String company, String id, String month, String year) async {
    var snapshot = db
        .collection("company")
        .document(company)
        .collection("project")
        .document(id)
        .collection("materials")
        .where('monthYear', isEqualTo: '$month-$year')
        .snapshots();
  }

  var material;

  printMaterial(material) async {
    print(material[0].date);
    this.material = material;
  }

  addWorekers(String company, String id, String date, Workers workers) async {
    try {
      await db
          .collection("company")
          .document(company)
          .collection("project")
          .document(id)
          .collection("workers")
          .document(date)
          .setData(workers.asMap());
    } catch (e) {
      print('error');
    }
  }

  updateWorekers(
      String company, String id, String date, Workers workers) async {
    try {
      await db
          .collection("company")
          .document(company)
          .collection("project")
          .document(id)
          .collection("workers")
          .document(date)
          .updateData(workers.asMap());
    } catch (e) {
      print('error');
    }
  }

  getWorkers(String company, String id, String date) async {
    var snapshot = db
        .collection("company")
        .document(company)
        .collection("project")
        .document(id)
        .collection("workers")
        .document(date)
        .get();
    try {
      var workers = Workers.fromDocuments(await snapshot);
      return workers;
    } catch (e) {
      return null;
    }
  }

  addTask(String company, String id, String date, TaskModel task) async {
    try {
      await db
          .collection("company")
          .document(company)
          .collection("project")
          .document(id)
          .collection("tasks")
          .document(date)
          .setData(task.asMap());
    } catch (e) {
      print("error");
    }
  }

  updateTask(String company, String id, String date, TaskModel task) async {
    try {
      await db
          .collection("company")
          .document(company)
          .collection("project")
          .document(id)
          .collection("tasks")
          .document(date)
          .updateData(task.asMap());
    } catch (e) {
      print("error");
    }
  }

  getTasks(String company, String id, String date) async {
    var snapshot = db
        .collection("company")
        .document(company)
        .collection("project")
        .document(id)
        .collection("tasks")
        .document(date)
        .get();
    try {
      var tasks = TaskModel.fromDocuments(await snapshot);
      return tasks;
    } catch (e) {
      return null;
    }
  }

  addEquipment(String company, String id, String date,
      EquipmentsModel equipmentsModel) async {
    try {
      await db
          .collection("company")
          .document(company)
          .collection("project")
          .document(id)
          .collection("equipments")
          .document(date)
          .setData(equipmentsModel.asMap());
    } catch (e) {
      print(e);
    }
  }

  updateEquipment(String company, String id, String date,
      EquipmentsModel equipmentsModel) async {
    try {
      await db
          .collection("company")
          .document(company)
          .collection("project")
          .document(id)
          .collection("equipments")
          .document(date)
          .updateData(equipmentsModel.asMap());
    } catch (e) {
      print(e);
    }
  }

  getEquipments(String company, String id, String date) async {
    var snapshot = db
        .collection("company")
        .document(company)
        .collection("project")
        .document(id)
        .collection("equipments")
        .document(date)
        .get();
    try {
      var equipment = EquipmentsModel.fromDocument(await snapshot);
      return equipment;
    } catch (e) {
      return null;
    }
  }

  addFiles(String company, String id, String date, String name, String filename,
      files) async {
    String url = "";
    if (files != null) {
      StorageReference ref = FirebaseStorage.instance.ref().child(filename);
      StorageUploadTask uploadTask = ref.putFile(files);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      url = await taskSnapshot.ref.getDownloadURL();
    }
    try {
      await db
          .collection("company")
          .document(company)
          .collection("project")
          .document(id)
          .collection("files")
          .document(name)
          .setData({'file': url, 'date': date, 'name': filename});
    } catch (e) {
      print('error');
    }
  }

  addPlansArchitecture(String company, String id, String date, String filename,
      File files) async {
    String url = "";
    if (files != null) {
      StorageReference ref = FirebaseStorage.instance.ref().child(filename);
      StorageUploadTask uploadTask = ref.putFile(files);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      url = await taskSnapshot.ref.getDownloadURL();
    }
    try {
      await db
          .collection("company")
          .document(company)
          .collection("project")
          .document(id)
          .collection("plansArchitecture")
          .document(date + filename)
          .setData({'file': url, 'date': date, 'name': filename});
    } catch (e) {
      print('error');
    }
  }

  addPlansStructure(String company, String id, String date, String filename,
      File files) async {
    String url = "";
    if (files != null) {
      StorageReference ref = FirebaseStorage.instance.ref().child(filename);
      StorageUploadTask uploadTask = ref.putFile(files);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      url = await taskSnapshot.ref.getDownloadURL();
    }
    try {
      await db
          .collection("company")
          .document(company)
          .collection("project")
          .document(id)
          .collection("plansStructure")
          .document(date + filename)
          .setData({'file': url, 'date': date, 'name': filename});
    } catch (e) {
      print('error');
    }
  }

  addPlansElectrical(String company, String id, String date, String filename,
      File files) async {
    String url = "";
    if (files != null) {
      StorageReference ref = FirebaseStorage.instance.ref().child(filename);
      StorageUploadTask uploadTask = ref.putFile(files);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      url = await taskSnapshot.ref.getDownloadURL();
    }
    try {
      await db
          .collection("company")
          .document(company)
          .collection("project")
          .document(id)
          .collection("plansElectrical")
          .document(date + filename)
          .setData({'file': url, 'date': date, 'name': filename});
    } catch (e) {
      print('error');
    }
  }

  addPlansPlumbing(String company, String id, String date, String filename,
      File files) async {
    String url = "";
    if (files != null) {
      StorageReference ref = FirebaseStorage.instance.ref().child(filename);
      StorageUploadTask uploadTask = ref.putFile(files);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      url = await taskSnapshot.ref.getDownloadURL();
    }
    try {
      await db
          .collection("company")
          .document(company)
          .collection("project")
          .document(id)
          .collection("plansPlumbing")
          .document(date + filename)
          .setData({'file': url, 'date': date, 'name': filename});
    } catch (e) {
      print('error');
    }
  }

  addDailyTask(String company, String id, String date, List task) async {
    try {
      await db
          .collection("company")
          .document(company)
          .collection("project")
          .document(id)
          .collection("dailyTask")
          .document(date)
          .setData({'task': FieldValue.arrayUnion(task), 'date': date});
    } catch (e) {
      print('error');
    }
  }

  updateDailyTask(String company, String id, String date, List task) async {
    try {
      await db
          .collection("company")
          .document(company)
          .collection("project")
          .document(id)
          .collection("dailyTask")
          .document(date)
          .updateData({'task': FieldValue.arrayUnion(task), 'date': date});
    } catch (e) {
      await db
          .collection("company")
          .document(company)
          .collection("project")
          .document(id)
          .collection("dailyTask")
          .document(date)
          .setData({'task': FieldValue.arrayUnion(task), 'date': date});
      print('error');
    }
  }
}
