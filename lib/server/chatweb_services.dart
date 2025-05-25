import 'dart:convert';
import 'package:chatbot/server/server.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final chatServiceProvider = Provider((ref) => ChatWebService());
final connectionErrorProvider = StateProvider<String?>((ref) => null);

class ChatWebService {
  late WebSocketChannel channel;

  void connect(WidgetRef ref) {
    channel = WebSocketChannel.connect(
      Uri.parse("v1/chatbot/"),
    );
    ref.read(connectionErrorProvider.notifier).state = null;
    channel.stream.listen(
      (message) {
        final response = jsonDecode(message);
        if (response["chatbot"] == true) {
          print("ture ==========> ");
          final reply = response["data"];
          ref.read(chatProvider.notifier).replaceTypingWithBotMessage(reply);
        }
      },

      onError: (e) {
        print("==============> ${e}");
        _showErrorMessage(ref);
      },
    );
  }

  void send(String query, WidgetRef ref) {
    ref.read(chatProvider.notifier).addUserMessage(query);
    ref.read(chatProvider.notifier).addTypingIndicator();
    channel.sink.add(jsonEncode({"query": query}));
  }

  void _showErrorMessage(WidgetRef ref) {
    ref.read(connectionErrorProvider.notifier).state =
        "Server is busy at this time. Please try again later.";

    // Ensure "Bot is typing..." is removed
    ref
        .read(chatProvider.notifier)
        .replaceTypingWithBotMessage(
          "Server is busy at this time. Please try again later.",
        );
  }
}
