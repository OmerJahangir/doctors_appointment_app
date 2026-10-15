import 'package:flutter/material.dart';

import '../../model/doctor.dart';
import '../../res/app_theme.dart';
import '../../utils/date_format.dart';
import '../../utils/schedule.dart';
import '../../view_model/app_scope.dart';
import '../booking/booking_screen.dart';
import '../chat/chat_screen.dart';
import '../common_widget/fade_slide_in.dart';
import '../common_widget/primary_button.dart';

class DoctorDetailScreen extends StatefulWidget {
  const DoctorDetailScreen({super.key, required this.doctor});

  final Doctor doctor;

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  bool _bioExpanded = false;

  void _book([DateTime? day]) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BookingScreen(doctor: widget.doctor, initialDay: day),
      ),
    );
  }

  void _chat() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChatScreen(doctor: widget.doctor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.sizeOf(context);
    final days = upcomingWorkingDays(
      AppScope.of(context).appointments.now(),
      4,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'Message ${doctor.name}',
            onPressed: _chat,
            icon: const Icon(Icons.chat_bubble_outline_rounded),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: 0,
            right: -size.width * 0.18,
            height: size.height * 0.48,
            width: size.width * 0.75,
            child: FadeSlideIn(
              offset: const Offset(0.15, 0),
              child: ShaderMask(
                // Fades the photo into the page at the bottom.
                shaderCallback: (rect) => const LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white, Colors.transparent],
                ).createShader(rect),
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  doctor.image,
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                  excludeFromSemantics: true,
                ),
              ),
            ),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 100),
              children: [
                FadeSlideIn(
                  offset: const Offset(-0.15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: size.width * 0.55,
                        ),
                        child: Text(
                          doctor.name,
                          style: textTheme.headlineSmall,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: size.width * 0.5),
                        child: Text(
                          doctor.title,
                          style: textTheme.titleMedium?.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      _Stat(
                        icon: Icons.star_rounded,
                        iconColor: AppColors.star,
                        label: 'Rating',
                        value: '${doctor.rating.toStringAsFixed(1)} of 5',
                      ),
                      const SizedBox(height: 14),
                      _Stat(
                        icon: Icons.people_rounded,
                        iconColor: AppColors.primaryLight,
                        label: 'Patients',
                        value: '${doctor.patients}+',
                      ),
                      const SizedBox(height: 14),
                      _Stat(
                        icon: Icons.workspace_premium_rounded,
                        iconColor: AppColors.online,
                        label: 'Experience',
                        value: '${doctor.experienceYears} years',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                FadeSlideIn(
                  delay: staggered(2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Biography', style: textTheme.titleLarge),
                      const SizedBox(height: 8),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        alignment: Alignment.topCenter,
                        child: Text(
                          doctor.bio,
                          maxLines: _bioExpanded ? null : 3,
                          overflow: _bioExpanded ? null : TextOverflow.fade,
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        onPressed: () =>
                            setState(() => _bioExpanded = !_bioExpanded),
                        child: Text(_bioExpanded ? 'Show less' : 'Read more'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                FadeSlideIn(
                  delay: staggered(3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Schedule', style: textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          for (final (i, day) in days.indexed) ...[
                            if (i > 0) const SizedBox(width: 12),
                            Expanded(
                              child: _DayChip(
                                day: day,
                                onTap: () => _book(day),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: MediaQuery.paddingOf(context).bottom + 16,
            child: FadeSlideIn(
              delay: staggered(4),
              offset: const Offset(0, 1),
              child: PrimaryButton(
                label: 'Make an appointment',
                onPressed: _book,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Card(
            child: SizedBox(
              height: 54,
              width: 54,
              child: Icon(icon, color: iconColor, size: 28),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({required this.day, required this.onTap});

  final DateTime day;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Book on ${formatDay(day)}',
      excludeSemantics: true,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Text(
                  '${day.day}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  weekdayShort(day),
                  style: const TextStyle(color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
