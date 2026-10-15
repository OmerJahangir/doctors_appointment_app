import 'package:flutter/material.dart';

import '../../model/chat_message.dart';
import '../../model/doctor.dart';
import '../../res/app_theme.dart';
import '../../utils/date_format.dart';
import '../../view_model/app_scope.dart';
import '../common_widget/doctor_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.doctor});

  final Doctor doctor;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _input = TextEditingController();

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _send() {
    if (AppScope.of(context).chats.send(widget.doctor, _input.text)) {
      _input.clear();
    }
  }

  void _callUnavailable() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Calls are not available in this demo.')),
      );
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;
    final chats = AppScope.of(context).chats;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        titleSpacing: 0,
        title: InkWell(
          onTap: () => openDoctor(context, doctor),
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              DoctorAvatar(doctor: doctor, radius: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Row(
                      children: [
                        Icon(Icons.circle, size: 9, color: AppColors.online),
                        SizedBox(width: 4),
                        Text(
                          'Online',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          _RoundAction(
            icon: Icons.videocam_rounded,
            tooltip: 'Video call',
            onPressed: _callUnavailable,
          ),
          _RoundAction(
            icon: Icons.call_rounded,
            tooltip: 'Voice call',
            onPressed: _callUnavailable,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListenableBuilder(
              listenable: chats,
              builder: (context, _) {
                final messages = chats.messagesWith(doctor);
                // Reversed so the newest message sits at the bottom and the
                // list stays pinned there as messages arrive.
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  itemCount: messages.length,
                  itemBuilder: (context, i) =>
                      _Bubble(message: messages[messages.length - 1 - i]),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: TextField(
                controller: _input,
                textInputAction: TextInputAction.send,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  fillColor: AppColors.background,
                  suffixIcon: IconButton(
                    tooltip: 'Send',
                    onPressed: _send,
                    icon: const Icon(
                      Icons.send_rounded,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundAction extends StatelessWidget {
  const _RoundAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: IconButton.filled(
        tooltip: tooltip,
        onPressed: onPressed,
        style: IconButton.styleFrom(backgroundColor: AppColors.primary),
        icon: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final mine = message.fromMe;
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.72,
        ),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
        decoration: BoxDecoration(
          color: mine
              ? AppColors.primary
              : AppColors.primaryLight.withValues(alpha: 0.08),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(mine ? 20 : 4),
            topRight: Radius.circular(mine ? 4 : 20),
            bottomLeft: const Radius.circular(20),
            bottomRight: const Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: mine ? Colors.white : AppColors.text,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formatTime(message.sentAt),
              style: TextStyle(
                fontSize: 11,
                color: mine ? Colors.white70 : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
