import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  final _about1 =
      "Flutter Kanpur is a community-driven initiative focused on bringing together Flutter developers, designers, and technology enthusiasts from Kanpur and beyond. Our goal is to create a supportive environment where members can learn, build, and grow together through shared knowledge and collaboration.";
  final _about2 =
      "We organize meetups, workshops, coding challenges, and discussions that help members stay up to date with Flutter, UI/UX, and modern app development practices. Whether you are a beginner exploring Flutter or an experienced professional contributing to open-source or community projects, Flutter Kanpur is a place for you.";
  final _about3 =
      "Beyond events, we aim to build meaningful community products and learning experiences that encourage consistency, participation, and contribution. We believe strong communities are built on inclusivity, curiosity, and mutual respect.";
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final usedTextTheme = theme.textTheme.bodyLarge;
    return GradientBackground(
      child: FkScreen(
        children: [
          FkHeader(
            title: 'About Flutter Kanpur',
            subtitle: '',
            leading: FkBackButton(),
          ),
          SizedBox(height: 28),
          Text(_about1, style: usedTextTheme),
          SizedBox(height: 16),
          Text(_about2, style: usedTextTheme),
          SizedBox(height: 16),
          Text(_about3, style: usedTextTheme),
        ],
      ),
    );
  }
}
