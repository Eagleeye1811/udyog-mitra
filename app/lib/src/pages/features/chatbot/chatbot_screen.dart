import 'package:flutter/material.dart';
import 'package:udyogmitra/src/pages/features/chatbot/chat_bubble.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final messages = [
    {
      "isUser": false,
      "message":
          "Hello! I'm your UdyogMitra assistant. How can I help you with your career or business goals today?",
    },
    {"isUser": true, "message": "What business can I start with HTML skills?"},
    {
      "isUser": false,
      "message":
          "You can start:\nA freelance web development service\nA portfolio-building agency\nA static site generator tool",
    },
    {"isUser": true, "message": "Prompt3"},
    {"isUser": false, "message": "Response3"},
  ];
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void sendPrompt() {
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      messages.add({"isUser": true, "message": prompt});
    });

    _promptController.clear();

    setState(() {
      messages.add({"isUser": false, "message": ". . ."});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(seconds: 2),
        curve: Curves.easeOut,
      );
    });

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        messages.removeLast();
        messages.add({"isUser": false, "message": "Response"});
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 600),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UdyogMitra Chatbot"),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: true,
              itemCount: messages.length,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
              itemBuilder: (context, index) {
                final msg = messages[messages.length - index - 1];
                return ChatBubble(
                  isUser: msg["isUser"] as bool,
                  message: msg["message"] as String,
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _promptController,
                  decoration: InputDecoration(
                    hintText: "Ask Something ...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(icon: const Icon(Icons.mic), onPressed: () {}),
              IconButton(icon: const Icon(Icons.send), onPressed: sendPrompt),
            ],
          ),
        ),
      ),
    );
  }
}
