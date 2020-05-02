import 'package:flutter/material.dart';
import 'package:horizontalplanning/horizontalplanning.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SafeArea(
        top: true,
        child: Scaffold(
          appBar: AppBar(
            title: Text("HorizontalPlanning Sample"),
          ),
          body: HorizontalPlanning(
            title: "Semaine du 27/04 au 03/05",
            employees: [
              "Vianney",
              "Stéphane",
            ],
            nbHours: 24,
            startHour: 12,
            hourStep: 2,
            weekDays: ["Lun.", "Mar.", "Mer.", "Jeu.", "Ven.", "Sam.", "Dim."],
          ),
        ),
      ),
    );
  }
}
