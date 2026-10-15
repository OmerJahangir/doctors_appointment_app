import 'package:flutter/material.dart';

import '../../res/app_theme.dart';

/// Five stars filled to [rating], followed by the number itself so the score
/// is readable without relying on the star colours.
class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating, this.size = 18});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    // Rounded to the nearest half star, so 4.9 shows five full stars.
    final stars = (rating * 2).round() / 2;
    return Semantics(
      label: 'Rated ${rating.toStringAsFixed(1)} out of 5',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 1; i <= 5; i++)
            Icon(
              stars >= i
                  ? Icons.star_rounded
                  : stars >= i - 0.5
                  ? Icons.star_half_rounded
                  : Icons.star_outline_rounded,
              color: AppColors.star,
              size: size,
            ),
          const SizedBox(width: 6),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: size * 0.8,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
