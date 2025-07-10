import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isUser;
  final String message;
  const ChatBubble({super.key, required this.isUser, required this.message});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: screenWidth * 0.75),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: isUser
                ? const Color.fromARGB(255, 233, 233, 233)
                : const Color.fromARGB(255, 75, 207, 143),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: isUser ? Radius.circular(15) : Radius.circular(0),
              bottomRight: isUser ? Radius.circular(0) : Radius.circular(15),
            ),
            border: isUser
                ? Border.all(
                    color: const Color.fromARGB(255, 95, 95, 95),
                    width: 1,
                  )
                : Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: isUser
                    ? const Color.fromARGB(255, 230, 230, 230)
                    : Colors.black,
                spreadRadius: 0.5,
                blurRadius: 0.5,
              ),
            ],
          ),
          child: Text(
            message,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            textAlign: TextAlign.start,
          ),
        ),
      ),
    );
  }
}
