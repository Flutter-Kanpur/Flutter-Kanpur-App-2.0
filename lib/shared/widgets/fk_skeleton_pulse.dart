import 'package:flutter/material.dart';

/// Wraps [child] in a gentle, repeating opacity pulse - the shared loading
/// feel for all skeleton screens (e.g. [FkSkeletonBlock]-based layouts).
class FkSkeletonPulse extends StatefulWidget {
  const FkSkeletonPulse({super.key, required this.child});

  final Widget child;

  @override
  State<FkSkeletonPulse> createState() => _FkSkeletonPulseState();
}

class _FkSkeletonPulseState extends State<FkSkeletonPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  late final Animation<double> _opacity = Tween<double>(
    begin: 0.5,
    end: 1,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _opacity, child: widget.child);
  }
}
