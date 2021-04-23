import 'package:cloud_firestore/cloud_firestore.dart';

class Workers {
  String projectName;
  String contractor;
  String architecture;
  String siteSupervisors;
  String labours;
  String date;
  String monthYear;

  Workers(this.projectName, this.contractor, this.architecture,
      this.siteSupervisors, this.labours, this.date, this.monthYear);

  factory Workers.fromDocuments(DocumentSnapshot document) {
    return Workers(
        document['projectName'],
        document['Contractor'],
        document['Architecture'],
        document['Site Supervisors'],
        document['Labours'],
        document['date'],
        document['monthYear']);
  }
  Map<String, dynamic> asMap() => {
        'projectName': projectName,
        'Contractor': contractor,
        'Architecture': architecture,
        'Site Supervisors': siteSupervisors,
        'Labours': labours,
        'date': date,
        'monthYear': monthYear,
      };
}
