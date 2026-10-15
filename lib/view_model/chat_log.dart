import 'package:flutter/foundation.dart';

import '../model/chat_message.dart';
import '../model/doctor.dart';

/// Conversations with each doctor, kept in memory for the app session.
class ChatLog extends ChangeNotifier {
  ChatLog({DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  final _threads = <String, List<ChatMessage>>{};

  /// Messages with [doctor], oldest first. A new thread opens with a greeting.
  List<ChatMessage> messagesWith(Doctor doctor) =>
      List.unmodifiable(_thread(doctor));

  ChatMessage lastMessageWith(Doctor doctor) => _thread(doctor).last;

  /// Adds [text] from the user. Blank messages are ignored.
  bool send(Doctor doctor, String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return false;
    _thread(
      doctor,
    ).add(ChatMessage(text: trimmed, fromMe: true, sentAt: _clock()));
    notifyListeners();
    return true;
  }

  List<ChatMessage> _thread(Doctor doctor) => _threads.putIfAbsent(
    doctor.id,
    () => [
      ChatMessage(
        text:
            'Hello! This is ${doctor.name}. How can I help you today? '
            'You can also book a visit from my profile.',
        fromMe: false,
        sentAt: _clock(),
      ),
    ],
  );
}
