import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatbot/server/chatweb_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BotMessage extends ConsumerStatefulWidget {
  const BotMessage({super.key, required this.message});
  final String message;

  @override
  ConsumerState<BotMessage> createState() => _BotMessageState();
}

class _BotMessageState extends ConsumerState<BotMessage> {
  bool hasAnimated = false;
  @override
  Widget build(BuildContext context) {
    final errorMessage = ref.watch(connectionErrorProvider);
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(21, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                widget.message == "Bot is typing..."
                    ? AnimatedTextKit(
                      animatedTexts: [
                        FadeAnimatedText('Searching...'),
                        FadeAnimatedText('Please wait...'),
                      ],
                    )
                    : widget.message.isNotEmpty && errorMessage != null
                    ? AnimatedTextKit(
                      totalRepeatCount: 1,
                      isRepeatingAnimation: false,
                      repeatForever: false,

                      animatedTexts: [TyperAnimatedText(errorMessage)],
                    )
                    : Text(widget.message),
          ),
        ],
      ),
    );
  }
}
