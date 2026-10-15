class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.fromMe,
    required this.sentAt,
  });

  final String text;
  final bool fromMe;
  final DateTime sentAt;
}
