import 'package:flutter/material.dart';
import '../models/question.dart';

class SummaryScreen extends StatelessWidget {
  final int score;
  final List<Question> questions;
  final List<Map<String, dynamic>> incorrectAnswers;

  SummaryScreen({
    required this.score,
    required this.questions,
    required this.incorrectAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Summary')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Score: $score/${questions.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final userAnswer = incorrectAnswers.firstWhere(
                    (item) => item['question'] == question.question,
                    orElse: () => {'yourAnswer': question.correctAnswer},
                  )['yourAnswer'];

                  final isCorrect = userAnswer == question.correctAnswer;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1}. ${question.question}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Your Answer: $userAnswer',
                          style: TextStyle(
                            color: isCorrect ? Colors.green : Colors.red,
                          ),
                        ),
                        if (!isCorrect)
                          Text(
                            'Correct Answer: ${question.correctAnswer}',
                            style: TextStyle(color: Colors.blue),
                          ),
                        Divider(),
                      ],
                    ),
                  );
                },
              ),
            ),
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
