import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialModel {
  String projectName;
  String cementTotal;
  String cementAvailable;
  String concreteTotal;
  String concreteAvailable;
  String woodTotal;
  String woodAvailable;
  String steelTotal;
  String steelAvailable;
  String plasticTotal;
  String plasticAvailable;
  String stoneTotal;
  String stoneAvailable;
  String glassTotal;
  String glassAvailable;
  String bricksTotal;
  String bricksAvailable;
  String date;
  String monthYear;

  MaterialModel(
      this.projectName,
      this.cementTotal,
      this.cementAvailable,
      this.concreteTotal,
      this.concreteAvailable,
      this.woodTotal,
      this.woodAvailable,
      this.steelTotal,
      this.steelAvailable,
      this.plasticTotal,
      this.plasticAvailable,
      this.stoneTotal,
      this.stoneAvailable,
      this.glassTotal,
      this.glassAvailable,
      this.bricksTotal,
      this.bricksAvailable,
      this.date,
      this.monthYear);
  factory MaterialModel.fromDocument(DocumentSnapshot document) {
    return MaterialModel(
        document['projectName'],
        document['CementTotal'],
        document['CementAvailable'],
        document['ConcreteTotal'],
        document['ConcreteAvailable'],
        document['WoodTotal'],
        document['WoodAvailable'],
        document['SteelTotal'],
        document['SteelAvailable'],
        document['PlasticTotal'],
        document['PlasticAvailable'],
        document['StoneTotal'],
        document['StoneAvailable'],
        document['GlassTotal'],
        document['GlassAvailable'],
        document['BricksTotal'],
        document['BricksAvailable'],
        document['date'],
        document['monthYear']);
  }
  Map<String, dynamic> asMap() => {
        'projectName': projectName,
        'CementTotal': cementTotal,
        'CementAvailable': cementAvailable,
        'ConcreteTotal': concreteTotal,
        'ConcreteAvailable': concreteAvailable,
        'WoodTotal': woodTotal,
        'WoodAvailable': woodAvailable,
        'SteelTotal': steelTotal,
        'SteelAvailable': steelAvailable,
        'PlasticTotal': plasticTotal,
        'PlasticAvailable': plasticAvailable,
        'StoneTotal': stoneTotal,
        'StoneAvailable': stoneAvailable,
        'GlassTotal': glassTotal,
        'GlassAvailable': glassAvailable,
        'BricksTotal': bricksTotal,
        'BricksAvailable': bricksAvailable,
        'date': date,
        'monthYear': monthYear,
      };
}
