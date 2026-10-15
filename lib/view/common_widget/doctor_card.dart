import 'package:flutter/material.dart';

import '../../model/doctor.dart';
import '../../res/app_theme.dart';
import '../doctor_detail/doctor_detail_screen.dart';
import 'rating_stars.dart';

class DoctorAvatar extends StatelessWidget {
  const DoctorAvatar({super.key, required this.doctor, this.radius = 30});

  final Doctor doctor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryLight.withValues(alpha: 0.85),
      backgroundImage: ResizeImage(
        AssetImage(doctor.image),
        width: (radius * 2 * MediaQuery.devicePixelRatioOf(context)).round(),
        policy: ResizeImagePolicy.fit,
      ),
    );
  }
}

/// A row in the doctor lists. Opens the doctor's profile unless [onTap] is
/// given.
class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key, required this.doctor, this.onTap});

  final Doctor doctor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap ?? () => openDoctor(context, doctor),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              DoctorAvatar(doctor: doctor),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doctor.name, style: textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      doctor.title,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 6),
                    RatingStars(rating: doctor.rating, size: 16),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  const Icon(
                    Icons.navigation_rounded,
                    color: AppColors.primaryLight,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${doctor.distanceKm.toStringAsFixed(1)} km',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void openDoctor(BuildContext context, Doctor doctor) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => DoctorDetailScreen(doctor: doctor)),
  );
}
