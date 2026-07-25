import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';

class DottedRoundedRect extends StatelessWidget {
  final Widget child;
  final double radius;
  final double strokeWidth;
  final Color color;
  final EdgeInsetsGeometry padding;

  const DottedRoundedRect({
    Key? key,
    required this.child,
    this.radius = 12.0,
    this.strokeWidth = 1.0,
    this.color = AppColors.neutral400,
    this.padding = const EdgeInsets.all(AppSpacing.raw16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedRRectPainter(
        color: color,
        strokeWidth: strokeWidth,
        radius: radius,
      ),
      child: Container(
        padding: padding,
        child: child,
      ),
    );
  }
}

class _DottedRRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;

  _DottedRRectPainter(
      {required this.color, required this.strokeWidth, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));

    final path = Path()..addRRect(rrect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // draw dashed path
    const dashWidth = 6.0;
    const dashSpace = 6.0;

    final pathMetrics = path.computeMetrics();
    for (final metric in pathMetrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        final extract =
        metric.extractPath(distance, next.clamp(0.0, metric.length));
        canvas.drawPath(extract, paint);
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}