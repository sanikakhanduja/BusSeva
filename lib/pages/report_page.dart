import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.report, size: 100, color: Colors.orange),
            SizedBox(height: 20),
            Text(
              "Report Issues",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Report harassment or malfunctions here",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
