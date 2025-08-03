import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udyogmitra/src/config/themes/app_theme.dart';
import 'package:udyogmitra/src/config/themes/app_theme_provider.dart';
import 'package:udyogmitra/src/pages/features/chatbot/chat_bubble.dart';
import 'package:udyogmitra/src/providers/user_profile_provider.dart';
import 'package:udyogmitra/src/services/api_service.dart';

class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  Map<String, dynamic>? _chatbotResponse;
  bool _isLoading = false;
  String? _errorMessage;
  CancelToken? _cancelToken;

  bool hasAnimated = false;

  final List<ChatMessage> messages = [];

  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    messages.add(
      ChatMessage(
        isUser: false,
        message:
            "Hello! I'm your UdyogMitra assistant. How can I help you with your career or business goals today?",
      ),
    );
  }

  void sendPrompt(String userId) async {
    _isLoading = true;
    hasAnimated = false;
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    setState(() {
      messages.add(ChatMessage(isUser: true, message: prompt));
    });

    _promptController.clear();

    setState(() {
      messages.add(ChatMessage(isUser: false, message: ". . ."));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });

    try {
      final response = await ApiService.chat(userId: userId, message: prompt);
      final chatbotResponse = response["message"];

      hasAnimated = false;

      setState(() {
        messages[messages.length - 1] = ChatMessage(
          isUser: false,
          message: chatbotResponse,
        );
      });
    } catch (e) {
      if (_cancelToken?.isCancelled == false) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to evaluate idea: ${e.toString()}';
        });
      }
    }
  }

  void setLoading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
      if (!isLoading) {
        hasAnimated = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "UdyogMitra Chatbot",
          style: context.textStyles.appBarTitle,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              ref.watch(themeModeProvider) == ThemeMode.dark
                  ? Icons.dark_mode
                  : Icons.light_mode,
              color: Colors.green,
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 0),
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isLast = index == messages.length - 1;
                return ChatBubble(
                  key: ValueKey('${msg.isUser}-${msg.message}'),
                  isUser: msg.isUser,
                  message: msg.message,
                  animate: !msg.isUser && isLast && !hasAnimated,
                  scrollController: _scrollController,
                  setLoading: setLoading,
                );
              },
            ),
          ),

          const SizedBox(height: 10),
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
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    hintText: "Ask Something ...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onSubmitted: (_) {
                    sendPrompt(userProfile!.id);
                  },
                ),
              ),
              const SizedBox(width: 10),
              IconButton(icon: const Icon(Icons.mic), onPressed: () {}),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  sendPrompt(userProfile!.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final bool isUser;
  final String message;

  ChatMessage({required this.isUser, required this.message});
}
