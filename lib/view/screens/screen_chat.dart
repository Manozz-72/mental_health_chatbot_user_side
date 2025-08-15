import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:async'; // For simulating a delay
import '../../chatgpt_services.dart';

class MentalCheckScreen extends StatefulWidget {
  const MentalCheckScreen({super.key});

  @override
  State<MentalCheckScreen> createState() => _MentalCheckScreenState();
}

class _MentalCheckScreenState extends State<MentalCheckScreen> {
  final List<Map<String, String>> _messages = [];
  final List<String> _questions = [
    "How did you sleep last night?",
    "Is there something you're overthinking lately?",
    "What disturbed you the most today?",
    "What made you happy, even a little bit, today?",
    "Do you feel like talking to someone right now?",
    "How are your energy levels today?",
    "Does life feel meaningful to you today?",
    "Have you recently felt regret or guilt about something?",
    "How do you talk to yourself—positively, negatively, or neutrally?",
    "What are you currently looking forward to?",
    "Are you able to control your emotions lately?",
    "What takes up most of your time during the day?",
    "What’s one thing you did today that gave you peace?",
    "What do you feel you need the most right now?"
  ];

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _currentIndex = 0;
  bool _inMentalCheck = false;
  bool _isUserSad = false;
  final ChatGPTService _chatGPTService = ChatGPTService();
  bool _isTyping = false;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  bool _isFeelingLow(String text) {
    final lower = text.toLowerCase();
    return lower.contains("not feeling well") ||
        lower.contains("sad") ||
        lower.contains("feel not good") ||
        lower.contains("depressed") ||
        lower.contains("mood off") ||
        lower.contains("stressed");
  }

  void _handleMessage(String message) async {
    final userMessage = message.trim();
    if (userMessage.isEmpty) return;

    setState(() {
      _messages.add({"role": "user", "content": userMessage});
      _controller.clear();
    });

    _scrollToBottom();

    if (!_inMentalCheck && _isFeelingLow(userMessage)) {
      setState(() {
        _isUserSad = true;
        _inMentalCheck = true;
        _currentIndex = 0;
      });
      _askNextMentalQuestion();
      return;
    }

    if (_inMentalCheck) {
      _currentIndex++;
      if (_currentIndex < _questions.length) {
        _askNextMentalQuestion();
      } else {
        await _analyzeMentalHealth();
      }
      return;
    }

    setState(() {
      _isTyping = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    final botResponse = await _chatGPTService.sendMessage(userMessage, _messages);

    setState(() {
      _messages.add({"role": "assistant", "content": botResponse});
      _isTyping = false;
    });

    _scrollToBottom();
  }

  void _askNextMentalQuestion() {
    final question = _questions[_currentIndex];
    setState(() {
      _messages.add({"role": "assistant", "content": question});
    });
    _scrollToBottom();
  }

  Future<void> _analyzeMentalHealth() async {
    setState(() => _isTyping = true);

    final userAnswers = _messages.where((m) => m['role'] == 'user').toList().skip(1).toList(); // skip the trigger message

    int sadCount = 0;
    for (var answer in userAnswers) {
      final content = answer['content']!.toLowerCase();
      if (content.contains("sad") ||
          content.contains("nothing") ||
          content.contains("tired") ||
          content.contains("no one") ||
          content.contains("alone") ||
          content.contains("regret") ||
          content.contains("guilt") ||
          content.contains("hopeless")) {
        sadCount++;
      }
    }

    final summaryPrompt = """
You are a compassionate mental health assistant. Based on the user's answers below, please:
1. Briefly summarize their mental/emotional state.
2. Suggest a practical coping strategy, self-care activity, or mental exercise.
3. Recommend one helpful book or podcast to support them.

User's answers:
${List.generate(_questions.length, (i) => "${i + 1}. ${_questions[i]}\nAnswer: ${userAnswers[i]['content']}").join("\n\n")}

The user showed ${sadCount >= 5 ? "multiple signs of sadness and distress" : "mixed emotional responses"}.
Provide an empathetic and supportive response.
""";

    await Future.delayed(const Duration(seconds: 2));

    final analysis = await _chatGPTService.sendMessage(summaryPrompt, _messages);

    setState(() {
      _messages.add({"role": "assistant", "content": analysis});
      _messages.add({
        "role": "assistant",
        "content": "I'm here for you anytime. Let me know how else I can help 😊"
      });
      _isTyping = false;
      _inMentalCheck = false;
      _currentIndex = 0;
    });

    _scrollToBottom();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildMessage(String role, String content) {
    final isBot = role == 'assistant';
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isBot ? Colors.white : Color(0xff21AF85),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(content, style: const TextStyle(fontSize: 15)),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
      child: TextField(
      controller: _controller,
          decoration: InputDecoration(
            hintText: 'Type a message...',
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 2), // Black border
              borderRadius: BorderRadius.circular(50.0), // Full rounded shape
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 2), // Black when focused
              borderRadius: BorderRadius.circular(50.0),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
          )
              ),
            ),

          IconButton(
            onPressed: () => _handleMessage(_controller.text),
            icon: const Icon(Icons.send),
            color: Color(0xff21AF85),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff21AF85),
          centerTitle: true,
        leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
    onPressed: () {
      Get.back();
    }
        ),
          title: const Text("Mental Health Check")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessage(msg['role']!, msg['content']!);
              },
            ),
          ),
          if (_isTyping)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: const [
                  SizedBox(width: 24, height: 24),
                  SizedBox(width: 12),
                  Text(
                    "Typing...",
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: _buildMessageInput(),
          ),
        ],
      ),
    );
  }
}
