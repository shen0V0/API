import 'package:flutter/material.dart';
import '../models/question.dart';

class SummaryScreen extends StatelessWidget {
  final int score;
  final List<Question> questions;

  SummaryScreen({required this.score, required this.questions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Your Score: $score/${questions.length}'),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Retake Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
