import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

class FkScreen extends StatelessWidget {
  const FkScreen({
    super.key,
    required this.children,
    this.padding,
    this.scrollPhysics,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? scrollPhysics;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        physics: scrollPhysics,
        padding:
            padding ??
            EdgeInsets.fromLTRB(
              AppSpacing.h20,
              AppSpacing.h18,
              AppSpacing.h20,
              24,
            ),
        children: children,
      ),
    );
  }
}
