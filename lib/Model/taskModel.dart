import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String projectName;
  String footing;
  String masonaryWork;
  String rccWork;
  String plaster;
  String plumbing;
  String lightFitting;
  String flooring;
  String painting;
  String basicFurniture;
  String date;
  String monthYear;

  TaskModel(
      this.projectName,
      this.footing,
      this.masonaryWork,
      this.rccWork,
      this.plaster,
      this.plumbing,
      this.lightFitting,
      this.flooring,
      this.painting,
      this.basicFurniture,
      this.date,
      this.monthYear);
  factory TaskModel.fromDocuments(DocumentSnapshot document) {
    return TaskModel(
        document['projectName'],
        document['Footing'],
        document['Masonary Work'],
        document['RCC Work'],
        document['Plaster'],
        document['Plumbing'],
        document['Light Fitting'],
        document['Flooring'],
        document['Painting'],
        document['Basic Furniture'],
        document['date'],
        document['monthYear']);
  }

  Map<String, dynamic> asMap() => {
        'projectName': projectName,
        'Footing': footing,
        'Masonary Work': masonaryWork,
        'RCC Work': rccWork,
        'Plaster': plaster,
        'Plumbing': plumbing,
        'Light Fitting': lightFitting,
        'Flooring': flooring,
        'Painting': painting,
        'Basic Furniture': basicFurniture,
        'date': date,
        'monthYear': monthYear,
      };
}
