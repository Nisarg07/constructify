import 'package:cloud_firestore/cloud_firestore.dart';

class EquipmentsModel {
  String projectName;
  String manliftNumber;
  String manliftHour;
  String jcbNumber;
  String jcbHour;
  String towerCraneNumber;
  String towerCraneHour;
  String excavatorNumber;
  String excavatorHour;
  String tractorsNumber;
  String tractorsHour;
  String loadersNumber;
  String loadersHour;
  String pileBoringEquipmentNumber;
  String pileBoringEquipmentHour;
  String date;
  String monthYear;

  EquipmentsModel(
      this.projectName,
      this.manliftNumber,
      this.manliftHour,
      this.jcbNumber,
      this.jcbHour,
      this.towerCraneNumber,
      this.towerCraneHour,
      this.excavatorNumber,
      this.excavatorHour,
      this.tractorsNumber,
      this.tractorsHour,
      this.loadersNumber,
      this.loadersHour,
      this.pileBoringEquipmentNumber,
      this.pileBoringEquipmentHour,
      this.date,
      this.monthYear);

  factory EquipmentsModel.fromDocument(DocumentSnapshot document) {
    return EquipmentsModel(
      document['projectName'],
      document['Manlift Number'],
      document['Manlift Hour'],
      document['JCB Number'],
      document['JCB Hour'],
      document['Tower Crane Number'],
      document['Tower Crane Hour'],
      document['Excavator Number'],
      document['Excavator Hour'],
      document['Tractors Number'],
      document['Tractors Hour'],
      document['Loaders Number'],
      document['Loaders Hour'],
      document['Pile Boring Equipment Number'],
      document['Pile Boring Equipment Hour'],
      document['date'],
      document['monthYear'],
    );
  }
  Map<String, dynamic> asMap() => {
        'projectName': projectName,
        'Manlift Number': manliftNumber,
        'Manlift Hour': manliftHour,
        'JCB Number': jcbNumber,
        'JCB Hour': jcbHour,
        'Tower Crane Number': towerCraneNumber,
        'Tower Crane Hour': towerCraneHour,
        'Excavator Number': excavatorNumber,
        'Excavator Hour': excavatorHour,
        'Tractors Number': tractorsNumber,
        'Tractors Hour': tractorsHour,
        'Loaders Number': loadersNumber,
        'Loaders Hour': loadersHour,
        'Pile Boring Equipment Number': pileBoringEquipmentNumber,
        'Pile Boring Equipment Hour': pileBoringEquipmentHour,
        'date': date,
        'monthYear': monthYear,
      };
}
