import 'package:flutter/material.dart';
import 'package:track_it/pages/home.dart';

class MyDayPage extends StatefulWidget {
  const MyDayPage({super.key, required this.title});

  final String title;

  @override
  State<MyDayPage> createState() => _MyDayPage();
}

class _MyDayPage extends State<MyDayPage> {
  final List<TextEditingController> _timeControllers = List<TextEditingController>.generate(11, (index) => TextEditingController());
  final List<TextEditingController> _turnsControllers = List<TextEditingController>.generate(11, (index) => TextEditingController());
  final List<bool> _checked = List<bool>.generate(11, (index) => false);
  final List<String> _options = [
    'Breakfast',
    'Playtime',
    'Bath Time',
    'Snack Time',
    'At the park',
    'Lunch Time',
    'At the store',
    'Dinner time',
    'Bed Time',
    'Story time',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Times of Day'),
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
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent[100]!, Colors.yellow[100]!], // Adjust color shades as desired
              begin: Alignment.topLeft, // Change for different gradient directions
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      'What times of day did you engage in ASE intervention?',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(4),
                        2: FlexColumnWidth(4),
                        3: FlexColumnWidth(4),
                      },
                      border: TableBorder.all(color: Colors.white10, width: 1,),
                      children: [
                        const TableRow(
                          decoration: BoxDecoration(
                            color: Colors.white30,
                          ),
                          children: [
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Activity',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Time Spent (mins)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  '# of Turns Taken',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (int index = 0; index < _options.length; index++)
                          TableRow(
                            children: [
                              Center(
                                child: Checkbox(
                                  value: _checked[index],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      _checked[index] = value ?? false;
                                    });
                                  },
                                  activeColor: Colors.white30,
                                  checkColor: Colors.black,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(_options[index]),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: _checked[index]
                                    ? TextField(
                                  controller: _timeControllers[index],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(borderSide:
                                        BorderSide(color: Colors.black)
                                    ),
                                    enabledBorder: OutlineInputBorder(borderSide:
                                    BorderSide(color: Colors.black)
                                    ),
                                    focusedBorder: OutlineInputBorder(borderSide:
                                    BorderSide(color: Colors.black26)
                                    ),
                                    disabledBorder: OutlineInputBorder(borderSide:
                                    BorderSide(color: Colors.black)
                                    ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 3.0),
                                    fillColor: Colors.white10,
                                    hoverColor: Colors.black12,
                                  ),
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                )
                                    : Container(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: _checked[index]
                                    ? TextField(
                                  controller: _turnsControllers[index],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(borderSide:
                                    BorderSide(color: Colors.black)
                                    ),
                                    enabledBorder: OutlineInputBorder(borderSide:
                                    BorderSide(color: Colors.black)
                                    ),
                                    focusedBorder: OutlineInputBorder(borderSide:
                                    BorderSide(color: Colors.black26)
                                    ),
                                    disabledBorder: OutlineInputBorder(borderSide:
                                    BorderSide(color: Colors.black)
                                    ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 3.0),
                                    fillColor: Colors.white10,
                                    hoverColor: Colors.black12,
                                  ),
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                )
                                    : Container(),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(Colors.white70),
                          foregroundColor: WidgetStateProperty.all<Color>(Colors.white70),
                      ),
                      onPressed: () {
                        // Handle submit action
                        for (int i = 0; i < _options.length; i++) {
                          if (_checked[i]) {
                            print('Activity: ${_options[i]}, Time Spent: ${_timeControllers[i].text}, Turns Taken: ${_turnsControllers[i].text}');
                          }
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
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
