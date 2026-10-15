import 'package:flutter/material.dart';

import '../../data/doctors.dart';
import '../../res/app_theme.dart';
import '../../utils/date_format.dart';
import '../../view_model/app_scope.dart';
import '../chat/chat_screen.dart';
import '../common_widget/doctor_card.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = AppScope.of(context).chats;
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListenableBuilder(
        listenable: chats,
        builder: (context, _) => ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          itemCount: doctors.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final doctor = doctors[i];
            final last = chats.lastMessageWith(doctor);
            return Card(
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                leading: DoctorAvatar(doctor: doctor, radius: 24),
                title: Text(
                  doctor.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${last.fromMe ? 'You: ' : ''}${last.text}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  formatTime(last.sentAt),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ChatScreen(doctor: doctor),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
