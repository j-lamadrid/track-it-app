import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:track_it/pages/home.dart';

class TrendsPage extends StatefulWidget {
  const TrendsPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _TrendsPageState createState() => _TrendsPageState();
}

class _TrendsPageState extends State<TrendsPage> {

  @override
  void initState() {
    super.initState();
    _fetchAndProcessData();
  }

  List<Map<String, dynamic>> _fetchAndProcessData() {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String userId = user!.uid;
      DatabaseReference dayData = FirebaseDatabase.instance.ref('times_of_day');
      Query userData = dayData.child(userId).orderByKey().limitToLast(10);

      DatabaseEvent snapshot = userData.once() as DatabaseEvent;
      Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.snapshot as Map);

      List<Map<String, dynamic>> processedData = _processData(data);

      return processedData;

    } catch (e) {
      print("Error fetching data: $e");
      List<Map<String, dynamic>> result = [];
      return result;
    }
  }

  List<Map<String, dynamic>> _processData(Map<String, dynamic> data) {
    List<Map<String, dynamic>> result = [];

    data.forEach((date, activities) {
      int turnsTaken = 0;
      int timeSpent = 0;

      activities.forEach((activityKey, activityValue) {
        if (activityValue["TurnsTaken"] != null) {
          turnsTaken += activityValue["TurnsTaken"] as int;
        }
        if (activityValue["TimeSpent"] != null) {
          timeSpent += activityValue["TimeSpent"] as int;
        }
      });

      result.add({
        'date': date,
        'turnsTaken': turnsTaken,
        'timeSpent': timeSpent,
      });
    });

    result.sort((a, b) => b['date'].compareTo(a['date']));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> data = _fetchAndProcessData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trends'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Home Page')),
            );
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent[100]!, Colors.blueAccent[100]!], // Adjust color shades as desired
              begin: Alignment.topLeft, // Change for different gradient directions
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent[100]!, Colors.yellow[100]!], // Adjust color shades as desired
              begin: Alignment.topLeft, // Change for different gradient directions
              end: Alignment.bottomRight,
            ),
          ),
          child: SfCartesianChart(
            legend: const Legend(isVisible: true),
            plotAreaBackgroundColor: Colors.transparent,
            primaryXAxis: const CategoryAxis(
              labelRotation: 45, // Rotate x-axis labels by 45 degrees
            ),
            primaryYAxis: const NumericAxis(
              title: AxisTitle(text: 'Count'), // Add y-axis label
            ),
            title: const ChartTitle(text: 'Trends in Turn Taking'),
            series: <LineSeries<Map<String, dynamic>, String>>[
              LineSeries<Map<String, dynamic>, String>(
                dataSource: data,
                color: Colors.black,
                xValueMapper: (datum, _) => datum['date'] as String,
                yValueMapper: (datum, _) => datum['turnsTaken'] as num,
                name: 'Turns Taken',
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
              LineSeries<Map<String, dynamic>, String>(
                dataSource: data,
                color: Colors.grey,
                xValueMapper: (datum, _) => datum['date'] as String,
                yValueMapper: (datum, _) => (datum['timeSpent'] / 60).round(2) as num,
                name: 'Time Spent (hours)',
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
