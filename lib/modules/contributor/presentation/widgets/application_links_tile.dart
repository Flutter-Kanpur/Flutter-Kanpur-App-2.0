import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ApplicationLinksTile extends StatelessWidget {
  const ApplicationLinksTile({
    super.key,
    required this.icon,
    required this.text,
  });

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(icon, width: 18, height: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }
}
