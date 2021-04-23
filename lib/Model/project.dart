import 'package:cloud_firestore/cloud_firestore.dart';

class Project {
  String projectName;
  String projectDescription;
  String company;
  String pdf;

  Project(this.projectName, this.projectDescription, this.company, this.pdf);
  factory Project.fromDocument(DocumentSnapshot document) {
    return Project(document['projectName'], document['projectDescription'],
        document['company'], document['pdf']);
  }
  Map<String, dynamic> asMap() => {
        'projectName': projectName,
        'projectDescription': projectDescription,
        'company': company,
        'pdf': pdf,
      };
}
