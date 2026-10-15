import 'package:flutter/material.dart';

import '../../res/app_theme.dart';

/// The wide dark-blue call-to-action with the fading chevrons.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.showChevrons = true,
  });

  final String label;

  /// Null disables the button.
  final VoidCallback? onPressed;
  final bool showChevrons;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.divider,
          disabledForegroundColor: AppColors.textMuted,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: Text(label, overflow: TextOverflow.fade)),
            if (showChevrons && enabled) ...[
              const SizedBox(width: 6),
              for (final alpha in const [1.0, 0.5, 0.2])
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.white.withValues(alpha: alpha),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
