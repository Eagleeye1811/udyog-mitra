import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:udyogmitra/src/pages/features/chatbot/chatbot_screen.dart';

class ChatMessagesProvider extends StateNotifier<List<ChatMessage>> {
  ChatMessagesProvider()
    : super([
        ChatMessage(
          isUser: false,
          message:
              "Hello! I'm your UdyogMitra assistant. How can I help you with your career or business goals today?",
        ),
      ]);

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }

  void removeMessage() {
    if (state.isNotEmpty) {
      state = state.sublist(0, state.length - 1);
    }
  }

  void clearMessages() {
    state = [];
  }

  void markMessageAnimated(int index) {
    final updatedMessages = [...state];
    final message = updatedMessages[index];
    updatedMessages[index] = message.copyWith(hasAnimated: true);
    state = updatedMessages;
  }
}

final chatMessagesProvider =
    StateNotifierProvider<ChatMessagesProvider, List<ChatMessage>>((ref) {
      return ChatMessagesProvider();
    });
