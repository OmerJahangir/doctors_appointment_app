import 'package:flutter/material.dart';

/// Fades and slides [child] up into place once, after [delay]. Shows the
/// child immediately when the system asks for reduced motion.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 0.25),
  });

  final Widget child;
  final Duration delay;
  final Offset offset;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  static const _duration = Duration(milliseconds: 450);

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: _duration + widget.delay,
  )..forward();

  // The delay is folded into the curve instead of a Timer, so nothing is left
  // pending if the widget goes away early.
  late final Animation<double> _progress = CurvedAnimation(
    parent: _controller,
    curve: Interval(
      widget.delay.inMicroseconds / _controller.duration!.inMicroseconds,
      1,
      curve: Curves.easeOutCubic,
    ),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;
    return FadeTransition(
      opacity: _progress,
      child: SlideTransition(
        position: Tween(
          begin: widget.offset,
          end: Offset.zero,
        ).animate(_progress),
        child: widget.child,
      ),
    );
  }
}

/// Stagger delay for the [index]th item in a list.
Duration staggered(int index) => Duration(milliseconds: 60 * index.clamp(0, 8));
