import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/model.dart';

class ChatNotifier extends StateNotifier<List<DataModel>> {
  ChatNotifier() : super([]);

  void addUserMessage(String msg) {
    state = [...state, DataModel(msg, false)];
  }

  void addTypingIndicator() {
    state = [...state, DataModel("Bot is typing...", true)];
  }

  void replaceTypingWithBotMessage(String newMessage) {
    final withoutTyping = List<DataModel>.from(state);
    if (withoutTyping.isNotEmpty &&
        withoutTyping.last.data == "Bot is typing...") {
      withoutTyping.removeLast();
    }
    state = [...withoutTyping, DataModel(newMessage, true)];
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, List<DataModel>>(
  (ref) => ChatNotifier(),
);
