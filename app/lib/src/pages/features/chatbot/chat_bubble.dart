import 'package:flutter/material.dart';
import 'package:udyogmitra/src/config/themes/app_theme.dart';
import 'dart:async';

class ChatBubble extends StatefulWidget {
  final bool isUser;
  final String message;
  final bool animate;
  final ScrollController scrollController;
  final Function(bool) setLoading;

  const ChatBubble({
    super.key,
    required this.isUser,
    required this.message,
    this.animate = false,
    required this.scrollController,
    required this.setLoading,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  String _visibleText = "";
  Timer? _timer;
  int _wordIndex = 0;

  bool hasAnimated = false;

  void _startTyping() {
    final words = widget.message.split(' ');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.setLoading(true);
    });
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_wordIndex < words.length) {
        setState(() {
          _visibleText += (_wordIndex == 0 ? '' : ' ') + words[_wordIndex];
          _wordIndex++;
        });
        scrollToBottom();
      } else {
        if (widget.message != ". . .") {
          widget.setLoading(false);
        }
        _timer?.cancel();
      }
    });
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.scrollController.animateTo(
        widget.scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 100),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.animate && !widget.isUser) {
      hasAnimated = true;
      _startTyping();
    } else {
      _visibleText = widget.message;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: widget.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: screenWidth * 0.75),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: widget.isUser
                ? context.cardStyles.primaryCard.color
                : context.cardStyles.greenTransparentCard.color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: widget.isUser
                  ? Radius.circular(20)
                  : Radius.circular(0),
              bottomRight: widget.isUser
                  ? Radius.circular(0)
                  : Radius.circular(20),
            ),
            border: widget.isUser
                ? Border.all(color: Colors.grey.shade800, width: 1)
                : Border.all(color: Colors.black87, width: 1),
            boxShadow: [
              BoxShadow(
                color: widget.isUser
                    ? const Color.fromARGB(255, 230, 230, 230)
                    : Colors.black,
                spreadRadius: 0.5,
                blurRadius: 0.5,
              ),
            ],
          ),
          child: Text(
            _visibleText,
            style: context.textStyles.bodySmall,
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}
