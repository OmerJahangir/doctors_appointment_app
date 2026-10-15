import 'package:flutter/material.dart';

import '../../../res/app_theme.dart';

/// The blue "live stream" promo card. Can be dismissed for the session.
class LiveBanner extends StatelessWidget {
  const LiveBanner({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    const white = TextStyle(color: Colors.white, letterSpacing: 0.8);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 8, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.primaryLight, AppColors.primary],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage('assets/images/live_host.png'),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Text.rich(
                    TextSpan(
                      text: "You're invited to a live stream with ",
                      children: [
                        TextSpan(
                          text: 'Dr. Navida',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    style: white,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Dismiss',
                onPressed: onClose,
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 12, right: 12),
            child: Divider(
              height: 1,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  '120K people joined the stream',
                  style: white.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const _AvatarStack(),
              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack();

  @override
  Widget build(BuildContext context) {
    const colors = [Color(0xFF42A5F5), Color(0xFFEF5350), Colors.white];
    return SizedBox(
      width: 66,
      height: 28,
      child: Stack(
        children: [
          for (final (i, color) in colors.indexed)
            Positioned(
              left: i * 19.0,
              child: CircleAvatar(radius: 14, backgroundColor: color),
            ),
        ],
      ),
    );
  }
}
