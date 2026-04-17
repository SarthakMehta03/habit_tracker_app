import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String habit;

  DetailScreen({required this.habit});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  bool isCompleted = false;

  void toggleStatus() {
    setState(() {
      isCompleted = !isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Habit Detail"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            Text(
              widget.habit,
              style: TextStyle(fontSize: 24),
            ),

            SizedBox(height: 20),

            Text(
              isCompleted ? "Status: Completed" : "Status: Not Completed",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: toggleStatus,
              child: Text("Mark Complete"),
            )

          ],
        ),
      ),
    );
  }
}