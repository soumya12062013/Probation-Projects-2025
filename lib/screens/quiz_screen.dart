import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;

  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;

  Future<void> _fetchQuestions() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse(
      "https://opentdb.com/api.php?amount=20&category=17&difficulty=medium&type=multiple",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];

      _questions = results.map((q) {
        final options = List<String>.from(q['incorrect_answers']);
        options.add(q['correct_answer']);
        options.shuffle();

        return {
          "question": q['question'],
          "options": options,
          "correct": q['correct_answer'],
        };
      }).toList();
    } else {
      throw Exception("Failed to load questions");
    }

    setState(() {
      _isLoading = false;
    });
  }

  Timer? _timer;
  int _timeLeft = 15;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  Future<void> _loadQuiz() async {
    await _fetchQuestions();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _timeLeft = 30);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeLeft--;
        if (_timeLeft <= 0) {
          _nextQuestion();
        }
      });
    });
  }

  void _nextQuestion([String? selectedAnswer]) {
    if (selectedAnswer != null &&
        selectedAnswer == _questions[_currentQuestionIndex]['correct']) {
      _score++;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
      _startTimer();
    } else {
      _showResult();
    }
  }

  void _showResult() {
    _timer?.cancel();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Quiz Finished 🎉"),
        content: Text("Your Score: $_score / ${_questions.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentQuestionIndex = 0;
                _score = 0;
              });
              _startTimer();
            },
            child: const Text("Play Again"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color.fromARGB(255, 126, 217, 229),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final currentQ = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Question ${_currentQuestionIndex + 1}/${_questions.length}",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("$_timeLeft sec"),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 27, 187, 209),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentQ['question'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Options
            ...currentQ['options'].map<Widget>((option) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => _nextQuestion(option),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(option, style: const TextStyle(fontSize: 18)),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
