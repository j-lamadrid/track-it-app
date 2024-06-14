import 'dart:math';
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
  // Dummy data for demonstration purposes
  final List<Map<String, dynamic>> data = [
    {'date': '2024-06-01', 'turnsTaken': 8, 'timeSpent': 20},
    {'date': '2024-06-02', 'turnsTaken': 6, 'timeSpent': 15},
    {'date': '2024-06-03', 'turnsTaken': 10, 'timeSpent': 30},
    {'date': '2024-06-04', 'turnsTaken': 12, 'timeSpent': 45},
    {'date': '2024-06-05', 'turnsTaken': 14, 'timeSpent': 30},
  ];

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
                yValueMapper: (datum, _) => datum['timeSpent'] as num,
                name: 'Time Spent (mins)',
                dataLabelSettings: const DataLabelSettings(isVisible: true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
