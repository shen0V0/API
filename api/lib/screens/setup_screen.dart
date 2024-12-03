import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'quiz_screen.dart';

class SetupScreen extends StatefulWidget {
  @override
  _SetupScreenState createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int _numQuestions = 10;
  String? _selectedCategory;
  String _selectedDifficulty = "easy";
  String _selectedType = "multiple";
  List<Map<String, String>> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final url = Uri.parse("https://opentdb.com/api_category.php");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List categories = data['trivia_categories'];
        setState(() {
_categories = categories
    .map((category) => {
          'id': category['id'].toString(),
          'name': category['name'].toString(),
        })
    .toList();
        });
      }
    } catch (e) {
      print("Failed to fetch categories: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Setup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<int>(
                value: _numQuestions,
                items: [5, 10, 15].map((num) {
                  return DropdownMenuItem<int>(
                    value: num,
                    child: Text('$num Questions'),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _numQuestions = value!),
                decoration: InputDecoration(labelText: 'Number of Questions'),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category['id'],
                    child: Text(category['name']!),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value),
                decoration: InputDecoration(
                  labelText: 'Select Category',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedDifficulty,
                items: ["easy", "medium", "hard"].map((difficulty) {
                  return DropdownMenuItem<String>(
                    value: difficulty,
                    child: Text(difficulty.capitalize()),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedDifficulty = value!),
                decoration: InputDecoration(
                  labelText: 'Select Difficulty',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: ["multiple", "boolean"].map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type == "multiple"
                        ? "Multiple Choice"
                        : "True/False"),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
                decoration: InputDecoration(
                  labelText: 'Select Type',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_selectedCategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please select a category'),
                    ));
                    return;
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizScreen(
                        numQuestions: _numQuestions,
                        category: _selectedCategory!,
                        difficulty: _selectedDifficulty,
                        type: _selectedType,
                      ),
                    ),
                  );
                },
                child: Text('Start Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtensions on String {
  String capitalize() =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
}
