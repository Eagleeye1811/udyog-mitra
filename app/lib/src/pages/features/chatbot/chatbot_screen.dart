import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udyogmitra/src/config/themes/app_theme.dart';
import 'package:udyogmitra/src/config/themes/app_theme_provider.dart';
import 'package:udyogmitra/src/pages/features/chatbot/chat_bubble.dart';
import 'package:udyogmitra/src/pages/features/chatbot/chat_messages_provider.dart';
import 'package:udyogmitra/src/providers/user_profile_provider.dart';
import 'package:udyogmitra/src/services/api_service.dart';

class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  bool _isLoading = false;
  String? _errorMessage;
  CancelToken? _cancelToken;

  bool shouldAnimate = false;

  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void sendPrompt(WidgetRef ref, String userId) async {
    _isLoading = true;

    final messages = ref.read(chatMessagesProvider.notifier);
    final prompt = _promptController.text.trim();
    if (prompt.isEmpty) return;

    messages.addMessage(ChatMessage(isUser: true, message: prompt));

    _promptController.clear();

    messages.addMessage(ChatMessage(isUser: false, message: ". . ."));

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

      messages.removeMessage();
      messages.addMessage(ChatMessage(isUser: false, message: chatbotResponse));
    } catch (e) {
      if (_cancelToken?.isCancelled == false) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to evaluate idea: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider);
    final messages = ref.watch(chatMessagesProvider);

    return SafeArea(
      top: false,
      child: Scaffold(
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
        resizeToAvoidBottomInset: true,
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
                  return ChatBubble(
                    key: ValueKey('${msg.isUser}-${msg.message}'),
                    isUser: msg.isUser,
                    message: msg.message,
                    animate: !msg.isUser && !msg.hasAnimated,
                    scrollController: _scrollController,
                    setLoading: (bool isLoading) {
                      setState(() {
                        _isLoading = isLoading;
                      });
                    },
                    onAnimationComplete: () {
                      ref
                          .read(chatMessagesProvider.notifier)
                          .markMessageAnimated(index);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),

        bottomSheet: Container(
          color: Colors.white,
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
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                    ),
                    onSubmitted: (_) {
                      sendPrompt(ref, userProfile!.id);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(icon: const Icon(Icons.mic), onPressed: () {}),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    sendPrompt(ref, userProfile!.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final bool isUser;
  final String message;
  final bool hasAnimated;

  ChatMessage({
    required this.isUser,
    required this.message,
    this.hasAnimated = false,
  });

  ChatMessage copyWith({bool? isUser, String? message, bool? hasAnimated}) {
    return ChatMessage(
      isUser: isUser ?? this.isUser,
      message: message ?? this.message,
      hasAnimated: hasAnimated ?? this.hasAnimated,
    );
  }
}
