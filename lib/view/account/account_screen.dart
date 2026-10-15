import 'package:flutter/material.dart';

import '../../res/app_theme.dart';
import '../../view_model/app_scope.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final book = AppScope.of(context).appointments;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.primary,
              child: Text(
                'G',
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(child: Text('Giovanny', style: textTheme.headlineSmall)),
          const Center(
            child: Text(
              'Patient',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          const SizedBox(height: 24),
          ListenableBuilder(
            listenable: book,
            builder: (context, _) => Card(
              child: ListTile(
                leading: const Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.primary,
                ),
                title: const Text('Upcoming appointments'),
                trailing: Text(
                  '${book.upcoming.length}',
                  style: textTheme.titleLarge,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.info_outline_rounded,
                color: AppColors.primary,
              ),
              title: const Text('About this app'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'Doctor Appointment',
                applicationVersion: '1.1.0',
                children: const [
                  Text(
                    'A demo app: doctors, chats and bookings are sample data '
                    'kept on this device until the app closes.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
