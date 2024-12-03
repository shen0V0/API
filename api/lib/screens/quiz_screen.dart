import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/api_service.dart';
import 'summary_screen.dart';
import 'dart:async';

class QuizScreen extends StatefulWidget {
  final int numQuestions;
  final String category;
  final String difficulty;
  final String type;

  QuizScreen({
    required this.numQuestions,
    required this.category,
    required this.difficulty,
    required this.type,
  });

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _loading = true;
  bool _answered = false;
  String _selectedAnswer = "";
  String _feedbackText = "";
  Timer? _timer;
  int _timeLeft = 10;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      final questions = await ApiService.fetchQuestions(
        amount: widget.numQuestions,
        category: widget.category,
        difficulty: widget.difficulty,
        type: widget.type,
      );
      setState(() {
        _questions = questions;
        _loading = false;
      });
      _startTimer();
    } catch (e) {
      print(e);
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 10;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft == 0) {
        timer.cancel();
        _submitAnswer("");
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _submitAnswer(String selectedAnswer) {
    _timer?.cancel();
    setState(() {
      _answered = true;
      _selectedAnswer = selectedAnswer;
      final correctAnswer =
          _questions[_currentQuestionIndex].correctAnswer;
      if (selectedAnswer == correctAnswer) {
        _score++;
        _feedbackText = "Correct! The answer is $correctAnswer.";
      } else {
        _feedbackText = "Incorrect. The correct answer is $correctAnswer.";
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _answered = false;
        _selectedAnswer = "";
        _feedbackText = "";
        _currentQuestionIndex++;
      });
      _startTimer();
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SummaryScreen(
            score: _score,
            questions: _questions,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final question = _questions[_currentQuestionIndex];
    return Scaffold(
      appBar: AppBar(title: Text('Quiz App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Time Left: $_timeLeft'),
            Text('Score: $_score'),
            Text(
              question.question,
              style: TextStyle(fontSize: 18),
            ),
            ...question.options.map((option) => ElevatedButton(
                  onPressed: _answered ? null : () => _submitAnswer(option),
                  child: Text(option),
                )),
            if (_answered)
              Text(
                _feedbackText,
                style: TextStyle(
                  color: _selectedAnswer == question.correctAnswer
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            if (_answered)
              ElevatedButton(
                onPressed: _nextQuestion,
                child: Text('Next Question'),
              ),
          ],
        ),
      ),
    );
  }
}
