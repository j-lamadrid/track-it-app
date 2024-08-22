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
  String _selectedRange = 'Past 7 Days';
  String _selectedScale = 'Turns Taken';

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
        CollectionReference ref =
            FirebaseFirestore.instance.collection('times_of_day');
        DocumentSnapshot<Map<String, dynamic>> userRef = await ref
            .doc(userId)
            .get() as DocumentSnapshot<Map<String, dynamic>>;
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
    Map<String, Map<String, int>> monthlyData = {};

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

      if (_selectedRange == 'All Time') {
        String month = date.substring(0, 7);
        if (!monthlyData.containsKey(month)) {
          monthlyData[month] = {'turnsTaken': 0, 'timeSpent': 0};
        }
        monthlyData[month]!['turnsTaken'] =
            monthlyData[month]!['turnsTaken']! + turnsTaken;
        monthlyData[month]!['timeSpent'] =
            monthlyData[month]!['timeSpent']! + timeSpent;
      } else {
        result.add({
          'date': date,
          'turnsTaken': turnsTaken,
          'timeSpent': timeSpent,
        });
      }
    });

    if (_selectedRange == 'All Time') {
      monthlyData.forEach((month, values) {
        result.add({
          'date': month,
          'turnsTaken': values['turnsTaken']!,
          'timeSpent': values['timeSpent']!,
        });
      });
    }

    result.sort((a, b) => a['date'].compareTo(b['date']));
    int start;
    if (_selectedRange == 'Past 7 Days') {
      start = result.length - 7;
    } else if (_selectedRange == 'Past 30 Days') {
      start = result.length - 30;
    } else if (_selectedRange == 'All Time') {
      start = 0;
    } else {
      start = 0;
    }

    if (start < 0) {
      start = 0;
    }

    result = result.sublist(start, result.length);
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
    List<num> turnResult = List<int>.filled(options.length, 0, growable: false);
    List<num> timeResult = List<int>.filled(options.length, 0, growable: false);
    List<Map<String, dynamic>> output = [];
    Map<String, dynamic> data = {};
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      CollectionReference ref =
          FirebaseFirestore.instance.collection('times_of_day');
      DocumentSnapshot<Map<String, dynamic>> userRef =
          await ref.doc(userId).get() as DocumentSnapshot<Map<String, dynamic>>;
      data = userRef.data() as Map<String, dynamic>;
    }

    List<Map<String, dynamic>> filteredData = _filterDataByDateRange(data);

    for (var entry in filteredData) {
      (entry['activities'] as Map).forEach((activityKey, activityValue) {
        if (activityValue["TurnsTaken"] != null) {
          turnResult[options.indexOf(activityKey)] +=
              activityValue["TurnsTaken"] as int;
        }
        if (activityValue["TimeSpent"] != null) {
          timeResult[options.indexOf(activityKey)] +=
              activityValue["TimeSpent"] as int;
        }
      });
    }

    for (var i = 0; i < options.length; i++) {
      output.add({
        'option': options[i],
        'turnsTaken': turnResult[i] ?? 0,
        'timeSpent': timeResult[i] ?? 0
      });
    }

    setState(() {
      _pieData = output;
      _loading = false;
    });
  }

  List<Map<String, dynamic>> _filterDataByDateRange(Map<String, dynamic> data) {
    List<Map<String, dynamic>> result = [];

    data.forEach((date, activities) {
      result.add({
        'date': date,
        'activities': activities,
      });
    });

    result.sort((a, b) => a['date'].compareTo(b['date']));
    int start;
    if (_selectedRange == 'Past 7 Days') {
      start = result.length - 7;
    } else if (_selectedRange == 'Past 30 Days') {
      start = result.length - 30;
    } else if (_selectedRange == 'All Time') {
      start = 0;
    } else {
      start = 0;
    }

    if (start < 0) {
      start = 0;
    }

    return result.sublist(start, result.length);
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
              MaterialPageRoute(
                  builder: (context) => const MyHomePage(title: 'Home Page')),
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
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent[100]!, Colors.yellow[100]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.transparent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  DropdownButton<String>(
                    value: _selectedRange,
                    dropdownColor: Colors.white70,
                    alignment: AlignmentDirectional.center,
                    items: <String>['Past 7 Days', 'Past 30 Days', 'All Time']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        setState(() {
                          _selectedRange = newValue!;
                          _loading = false;
                        });
                        _fetchAndProcessData().then((_) => _loadPieData());
                      });
                    },
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    height: 500,
                    child: SfCartesianChart(
                      backgroundColor: Colors.transparent,
                      legend: const Legend(
                          isVisible: true,
                          position: LegendPosition.top
                      ),
                      enableAxisAnimation: true,
                      plotAreaBackgroundColor: Colors.transparent,
                      tooltipBehavior: TooltipBehavior(
                          enable: true,
                          animationDuration: 100,
                          duration: 2000,
                          shouldAlwaysShow: false,
                          activationMode: ActivationMode.singleTap),
                      primaryXAxis: const CategoryAxis(
                        //title: AxisTitle(text: 'Date'),
                        labelRotation: 45,
                          autoScrollingMode: AutoScrollingMode.end,
                        labelIntersectAction: AxisLabelIntersectAction.rotate45,
                      ),
                      primaryYAxis: const NumericAxis(
                        //title: AxisTitle(text: 'Count'),
                          autoScrollingMode: AutoScrollingMode.end,
                        labelIntersectAction: AxisLabelIntersectAction.rotate45,
                      ),
                      title: const ChartTitle(
                          text: 'Trends in Turn Taking',
                          textStyle: TextStyle(fontWeight: FontWeight.bold)),
                      series: <LineSeries<Map<String, dynamic>, String>>[
                        LineSeries<Map<String, dynamic>, String>(
                          dataSource: _data,
                          markerSettings: const MarkerSettings(
                              isVisible: true,
                              color: Colors.black,
                              shape: DataMarkerType.circle,
                              height: 4.0,
                              width: 4.0),
                          color: Colors.black,
                          xValueMapper: (datum, _) => datum['date'] as String,
                          yValueMapper: (datum, _) =>
                              datum['turnsTaken'] as num,
                          name: 'Turns Taken',
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: false),
                        ),
                        LineSeries<Map<String, dynamic>, String>(
                          dataSource: _data,
                          markerSettings: const MarkerSettings(
                              isVisible: true,
                              color: Colors.grey,
                              shape: DataMarkerType.circle,
                              height: 4.0,
                              width: 4.0),
                          color: Colors.grey,
                          xValueMapper: (datum, _) => datum['date'] as String,
                          yValueMapper: (datum, _) =>
                              dp((datum['timeSpent'] / 60), 2),
                          name: 'Time Spent (hours)',
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: false),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  DropdownButton<String>(
                    value: _selectedScale,
                    alignment: AlignmentDirectional.center,
                    dropdownColor: Colors.white70,
                    items: <String>['Turns Taken', 'Time Spent (mins)']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        setState(() {
                          _selectedScale = newValue!;
                          _loading = false;
                        });
                      });
                    },
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    height: 350,
                    child: SfCircularChart(
                      backgroundColor: Colors.transparent,
                      tooltipBehavior: TooltipBehavior(
                          enable: true,
                          animationDuration: 100,
                          duration: 2000,
                          shouldAlwaysShow: false,
                          activationMode: ActivationMode.singleTap),
                      title: const ChartTitle(
                          text: 'Turn Taking By Time of Day',
                          textStyle: TextStyle(fontWeight: FontWeight.bold)),
                      legend: const Legend(
                        isVisible: true,
                        position: LegendPosition.top
                      ),
                      palette: <Color>[
                        Colors.white,
                        Colors.grey.shade300,
                        Colors.grey.shade500,
                        Colors.grey.shade800,
                        Colors.black,
                        Colors.yellow.shade200,
                        Colors.yellow.shade600,
                        Colors.yellow.shade800,
                        Colors.blue.shade200,
                        Colors.blue.shade400,
                        Colors.blue.shade800,
                      ],
                      series: <PieSeries<Map<String, dynamic>, String>>[
                        PieSeries<Map<String, dynamic>, String>(
                          dataSource: _pieData,
                          xValueMapper: (datum, _) => datum['option'] as String,
                          yValueMapper: (datum, _) =>
                              _selectedScale == 'Turns Taken'
                                  ? datum['turnsTaken'] as int
                                  : datum['timeSpent'] as int,
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
      ),
    );
  }
}
