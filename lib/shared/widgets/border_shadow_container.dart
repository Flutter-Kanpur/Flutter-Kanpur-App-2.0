import 'package:flutter/material.dart';
import '../../utils/colors.dart';

/// A customizable container widget that applies beautiful inner shadows
/// from any side (top-left, top-right, bottom-right, bottom-left).
///
/// Perfect for neumorphic, soft UI, and modern elevated surfaces.
///
///
/// ⚡ **Key Features:**
/// ✅ Inner shadow on any side: top-left, top-right, bottom-right, bottom-left
/// ✅ Fully customizable blur, offset, radius, and shadow color
/// ✅ Lightweight, dependency-free and pure Flutter implementation
/// ✅ Supports circular, rounded, or rectangular containers
/// ✅ Perfect for neumorphic and soft UI designs
class InnerShadowContainer extends StatelessWidget {
  /// The height of the container.
  final double? height;

  /// The width of the container.
  final double? width;

  /// The border radius of the container.
  final double borderRadius;

  /// The background color of the container.
  final Color backgroundColor;

  /// Whether to apply inner shadow from the top-left direction.
  final bool isShadowTopLeft;

  /// Whether to apply inner shadow from the top-right direction.
  final bool isShadowTopRight;

  /// Whether to apply inner shadow from the bottom-right direction.
  final bool isShadowBottomRight;

  /// Whether to apply inner shadow from the bottom-left direction.
  final bool isShadowBottomLeft;

  /// The blur radius for the shadow.
  final double blur;

  /// The offset of the shadow.
  final Offset offset;

  /// The shadow color.
  final Color shadowColor;

  /// The border color.
  final Color borderColor;

  /// The child widget inside the container.
  final Widget? child;

  /// Alignment of the child widget.
  final AlignmentGeometry alignment;

  /// Creates an [InnerShadowContainer].
  const InnerShadowContainer({
    super.key,
    this.height,
    this.width,
    this.borderRadius = 24.0,
    this.backgroundColor = Colors.white,
    this.isShadowTopLeft = false,
    this.isShadowTopRight = false,
    this.isShadowBottomRight = false,
    this.isShadowBottomLeft = false,
    this.blur = 15.0,
    this.offset = const Offset(-10, -1),
    this.shadowColor = Colors.black26,
    this.borderColor = AppColors.communityBorderColorV2,
    this.child,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final hasShadow = isShadowTopLeft ||
        isShadowTopRight ||
        isShadowBottomRight ||
        isShadowBottomLeft;

    return Stack(
      children: [
        Container(
          height: height,
          width: width,
          alignment: alignment,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor,width: 2),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: child,
        ),
        if (hasShadow)
          Positioned.fill(
            child: IgnorePointer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: CustomPaint(
                  painter: InnerShadowPainter(
                    shadowColor: shadowColor,
                    blur: blur,
                    offset: offset,
                    borderRadius: borderRadius,
                    isShadowTopLeft: isShadowTopLeft,
                    isShadowTopRight: isShadowTopRight,
                    isShadowBottomRight: isShadowBottomRight,
                    isShadowBottomLeft: isShadowBottomLeft,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// A custom painter to draw the inner shadow effect from selected directions.
class InnerShadowPainter extends CustomPainter {
  final Color shadowColor;
  final double blur;
  final Offset offset;
  final double borderRadius;
  final bool isShadowTopLeft;
  final bool isShadowTopRight;
  final bool isShadowBottomRight;
  final bool isShadowBottomLeft;

  InnerShadowPainter({
    required this.shadowColor,
    required this.blur,
    required this.offset,
    required this.borderRadius,
    this.isShadowTopLeft = false,
    this.isShadowTopRight = false,
    this.isShadowBottomRight = false,
    this.isShadowBottomLeft = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = shadowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);

    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final outer = Path()
      ..addRect(Rect.fromLTRB(
          -size.width, -size.height, size.width * 2, size.height * 2));

    final inner = Path()
      ..addRRect(rrect)
      ..fillType = PathFillType.evenOdd;

    canvas.saveLayer(rect, Paint());

    void drawShadow(double dx, double dy) {
      canvas.save();
      canvas.translate(dx, dy);
      canvas.drawPath(
        Path.combine(PathOperation.difference, outer, inner),
        paint,
      );
      canvas.restore();
    }

    if (isShadowBottomRight) drawShadow(-offset.dx.abs(), -offset.dy.abs());
    if (isShadowBottomLeft) drawShadow(offset.dx.abs(), -offset.dy.abs());
    if (isShadowTopLeft) drawShadow(offset.dx.abs(), offset.dy.abs());
    if (isShadowTopRight) drawShadow(-offset.dx.abs(), offset.dy.abs());

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}