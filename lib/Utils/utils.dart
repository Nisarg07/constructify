import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FormType { signIn, phoneSignIn, signUp }

Color grey = Colors.grey[400];

Color blue = Colors.blue;

Color error = Colors.amberAccent;

Color white = Colors.white;

Color black = Colors.black;

Color green = Colors.green;

Color transparent = Colors.transparent;

Color darkGrey = Colors.grey[600];

const String splashRoute = '/';

const String loginRoute = '/login';

const String homeRoute = '/home';

const String signupRoute = '/signup';

const String projectRoute = '/project';

const String reportRoute = '/report';

SharedPreferences pref;

List<String> materials = [
  "Cement",
  "Concrete",
  "Wood",
  "Steel",
  "Plastic",
  "Stone",
  "Glass",
  "Bricks"
];

List<String> materialItem = [
  "assets/cement.png",
  "assets/concrete.png",
  "assets/firewood.png",
  "assets/steel.png",
  "assets/plastic.png",
  "assets/stones.png",
  "assets/glass.png",
  "assets/bricks.png"
];

List<String> workers = [
  "Contractor",
  "Architecture",
  "Site Supervisors",
  "Labours"
];

List<String> tasks = [
  "Footing",
  "Masonary Work",
  "RCC Work",
  "Plaster",
  "Plumbing",
  "Light Fitting",
  "Flooring",
  "Painting",
  "Basic Furniture"
];

List<String> equipments = [
  "Manlift",
  "JCB",
  "Tower Crane",
  "Excavator",
  "Tractors",
  "Loaders",
  "Pile Boring Equipment"
];

List<String> months = [
  "Select Month",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "10",
  "11",
  "12"
];

List<String> years = [
  "Select Year",
  "2010",
  "2011",
  "2012",
  "2013",
  "2014",
  "2015",
  "2016",
  "2017",
  "2018",
  "2019",
  "2020",
  "2021",
  "2022",
  "2023",
  "2024",
  "2025",
  "2026",
  "2027",
  "2028",
  "2029",
  "2030"
];

class Utils {
  FirebaseAuth auth = FirebaseAuth.instance;
}
