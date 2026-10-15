import 'package:flutter/material.dart';

import '../../model/appointment.dart';
import '../../res/app_theme.dart';
import '../../utils/date_format.dart';
import '../../view_model/app_scope.dart';
import '../common_widget/doctor_card.dart';

/// The user's upcoming appointments, with cancel and undo.
class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key, required this.onFindDoctor});

  final VoidCallback onFindDoctor;

  void _cancel(BuildContext context, Appointment appointment) {
    final book = AppScope.of(context).appointments;
    book.cancel(appointment);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Cancelled your visit with ${appointment.doctor.name}'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => book.restore(appointment),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final book = AppScope.of(context).appointments;
    return Scaffold(
      appBar: AppBar(title: const Text('Appointments')),
      body: ListenableBuilder(
        listenable: book,
        builder: (context, _) {
          final upcoming = book.upcoming;
          if (upcoming.isEmpty) return _Empty(onFindDoctor: onFindDoctor);
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            itemCount: upcoming.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) => _AppointmentCard(
              appointment: upcoming[i],
              onCancel: () => _cancel(context, upcoming[i]),
            ),
          );
        },
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.appointment, required this.onCancel});

  final Appointment appointment;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final doctor = appointment.doctor;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                DoctorAvatar(doctor: doctor, radius: 26),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        doctor.title,
                        style: const TextStyle(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.event_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    formatDay(appointment.start),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.schedule_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    formatTime(appointment.start),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.close_rounded),
                label: const Text('Cancel'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.onFindDoctor});

  final VoidCallback onFindDoctor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.event_available_rounded,
              size: 64,
              color: AppColors.primaryLight,
            ),
            const SizedBox(height: 16),
            Text(
              'No upcoming appointments',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Open a doctor\'s profile and tap "Make an appointment" to '
              'book a visit.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMuted),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onFindDoctor,
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Find a doctor'),
            ),
          ],
        ),
      ),
    );
  }
}
