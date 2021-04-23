import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  String fname;
  String lname;
  String phone;
  String company;
  String nepmloyee;
  String position;

  Person(this.fname, this.lname, this.phone, this.company, this.nepmloyee,
      this.position);
  factory Person.fromDocument(DocumentSnapshot document) {
    return Person(document['fname'], document['lname'], document['phone'],
        document['company'], document['nemployee'], document['position']);
  }

  Map<String, dynamic> asMap() => {
        'lname': lname,
        'fname': fname,
        'phone': phone,
        'company': company,
        'nemployee': nepmloyee,
        'position': position,
      };
}
