import 'package:flutter/material.dart';

import '../../model/appointment.dart';
import '../../res/app_theme.dart';
import '../../utils/date_format.dart';
import '../common_widget/doctor_card.dart';
import '../common_widget/primary_button.dart';

/// Confirmation shown after a successful booking. Completes when closed.
Future<void> showBookedSheet(BuildContext context, Appointment appointment) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.6),
    builder: (_) => _BookedSheet(appointment: appointment),
  );
}

class _BookedSheet extends StatelessWidget {
  const _BookedSheet({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 48),
          padding: EdgeInsets.fromLTRB(
            24,
            68,
            24,
            24 + MediaQuery.paddingOf(context).bottom,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(
                  color: AppColors.online.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.online,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text('Appointment booked', style: textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                '${appointment.doctor.name}\n'
                '${formatDay(appointment.start)} at '
                '${formatTime(appointment.start)}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textMuted, height: 1.5),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Done',
                showChevrons: false,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: DoctorAvatar(doctor: appointment.doctor, radius: 44),
        ),
      ],
    );
  }
}
