import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:track_it/pages/home.dart';

class TrendsPage extends StatefulWidget {
  const TrendsPage({super.key, required this.title});

  final String title;

  @override
  _TrendsPageState createState() => _TrendsPageState();
}

class _TrendsPageState extends State<TrendsPage> {
  List<Map<String, dynamic>> _data = [];
  List<Map<String, dynamic>> _pieData = [];
  bool _loading = true;


  @override
  void initState() {
    super.initState();
    _fetchAndProcessData();
    _loadPieData();
  }

  double dp(double val, int places) {
    num mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  Future<void> _fetchAndProcessData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userId = user.uid;
        CollectionReference ref = FirebaseFirestore.instance.collection('times_of_day');
        DocumentSnapshot<Map<String, dynamic>> userRef = await ref.doc(userId).get() as DocumentSnapshot<Map<String, dynamic>>;
        Map<String, dynamic> data = userRef.data() as Map<String, dynamic>;
        List<Map<String, dynamic>> processedData = _processData(data);

        setState(() {
          _data = processedData;
        });
      } else {
        setState(() {
          _loading = true;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  List<Map<String, dynamic>> _processData(Map<String, dynamic> data) {
    List<Map<String, dynamic>> result = [];

    data.forEach((date, activities) {
      int turnsTaken = 0;
      int timeSpent = 0;

      (activities as Map).forEach((activityKey, activityValue) {
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
    result.sort((a, b) => a['date'].compareTo(b['date']));
    int start = result.length - 7;
    if (start < 0) {
      start = 0;
    }
    result = result.sublist(start, result.length);
    return result;
  }

  List<num> _aggregateData() {
    List<num> result = [0, 0];

    for (var i = 0; i < _data.length; i++) {
      result[0] += _data[i]['turnsTaken'] / _data.length;
      result[1] += _data[i]['timeSpent'] / _data.length;
    }

    return result;
  }

  Future<void> _loadPieData() async {
    List<String> options = [
      'Breakfast',
      'Playtime',
      'Bath Time',
      'Snack Time',
      'At the park',
      'Lunch Time',
      'At the store',
      'Dinner Time',
      'Bed Time',
      'Story time',
      'Other',
    ];
    List<num> result = List<int>.filled(options.length, 0, growable: false);
    List<Map<String, dynamic>> output = [];
    Map<String, dynamic> data = {};
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      CollectionReference ref = FirebaseFirestore.instance.collection(
          'times_of_day');
      DocumentSnapshot<Map<String, dynamic>> userRef = await ref.doc(userId)
          .get() as DocumentSnapshot<Map<String, dynamic>>;
      data = userRef.data() as Map<String, dynamic>;
    }

    data.forEach((date, activities) {
      (activities as Map).forEach((activityKey, activityValue) {
        if (activityValue["TurnsTaken"] != null) {
          result[options.indexOf(activityKey)] += activityValue["TurnsTaken"] as int;
        }
      });
    });

    for (var i = 0; i < options.length; i++) {
      if (result[i] > 0) {
        output.add({
        'option': options[i],
        'turnsTaken': result[i]
        });
      }
    }

    setState(() {
      _pieData = output;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              colors: [Colors.blueAccent[100]!, Colors.blueAccent[100]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent[100]!, Colors.yellow[100]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 500,
                  child: SfCartesianChart(
                    legend: const Legend(isVisible: true),
                    enableAxisAnimation: true,
                    plotAreaBackgroundColor: Colors.transparent,
                    primaryXAxis: const CategoryAxis(
                      labelRotation: 45,
                    ),
                    primaryYAxis: const NumericAxis(
                      title: AxisTitle(text: 'Count'),
                    ),
                    title: const ChartTitle(text: 'Trends in Turn Taking'),
                    series: <LineSeries<Map<String, dynamic>, String>>[
                      LineSeries<Map<String, dynamic>, String>(
                        dataSource: _data,
                        color: Colors.black,
                        xValueMapper: (datum, _) => datum['date'] as String,
                        yValueMapper: (datum, _) => datum['turnsTaken'] as num,
                        name: 'Turns Taken',
                        dataLabelSettings: const DataLabelSettings(isVisible: true),
                      ),
                      LineSeries<Map<String, dynamic>, String>(
                        dataSource: _data,
                        color: Colors.grey,
                        xValueMapper: (datum, _) => datum['date'] as String,
                        yValueMapper: (datum, _) => dp((datum['timeSpent'] / 60), 2),
                        name: 'Time Spent (hours)',
                        dataLabelSettings: const DataLabelSettings(isVisible: true),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 75),
                SizedBox(
                  height: 350,
                  child: SfCircularChart(
                    title: const ChartTitle(text: '# of Turns Taken By Time of Day'),
                    legend: const Legend(isVisible: true),
                    palette: <Color>[
                      Colors.white,
                      Colors.brown.shade200,
                      Colors.brown.shade400,
                      Colors.brown.shade800,
                      Colors.blue.shade200,
                      Colors.blue.shade400,
                      Colors.blue.shade800,
                      Colors.grey.shade300,
                      Colors.grey.shade500,
                      Colors.grey.shade800,
                      Colors.black
                    ],
                    series: <PieSeries<Map<String, dynamic>, String>>[
                      PieSeries<Map<String, dynamic>, String>(
                        dataSource: _pieData,
                        xValueMapper: (datum, _) => datum['option'] as String,
                        yValueMapper: (datum, _) => datum['turnsTaken'] as int,
                        dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
