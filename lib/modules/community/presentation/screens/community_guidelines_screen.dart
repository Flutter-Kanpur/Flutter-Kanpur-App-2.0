import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/gradiant_background.dart';

class CommunityGuidelinesScreen extends StatelessWidget {
  const CommunityGuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GradientBackground(
      child: FkScreen(
        children: [
          const FkHeader(
            title: 'Communitiy Guidelines',
            subtitle: '',
            leading: FkBackButton(),
          ),
          const SizedBox(height: 18),
          Text(
            "Flutter Kanpur is a collaborative space for developers, designers, learners, and contributors to connect, learn, and grow together. Our goal is to create an environment where everyone feels safe, respected, and encouraged to participate. These guidelines exist to maintain a healthy and welcoming community experience for all members.",
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 28),
          SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ContainerBackground(
                  title: 'Respect and conduct',
                  description:
                      'We expect all members to interact with each other respectfully and professionally. Differences in opinions, experience levels, and perspectives are natural and welcome, but disrespectful behavior, harassment, or offensive language is not acceptable. Every member deserves to be treated with dignity.',
                ),
                SizedBox(height: 18),
                _ContainerBackground(
                  title: 'Inclusivity',
                  description:
                      'Flutter Kanpur is an inclusive community. We encourage patience, empathy, and support—especially toward beginners and new members. Avoid language or behavior that may discourage participation or make others feel unwelcome. Inclusivity helps the community grow stronger.',
                ),
                SizedBox(height: 18),
                _ContainerBackground(
                  title: 'Meaningful Participation',
                  description:
                      'Conversations, feedback, and contributions should be constructive and relevant. Healthy discussions are encouraged, but personal attacks, unnecessary negativity, or disruptive behavior reduce the value of the community. When offering feedback, focus on being helpful and respectful.',
                ),
                SizedBox(height: 18),
                _ContainerBackground(
                  title: 'Responsible Sharing',
                  description:
                      'Members are encouraged to share resources, projects, and opportunities that add value to the community. Excessive self-promotion, spam, or irrelevant advertising is discouraged. Sharing should always prioritize community benefit over personal promotion.',
                ),
                SizedBox(height: 18),
                _ContainerBackground(
                  title: 'Privacy & Trust',
                  description:
                      'Respecting privacy is essential. Do not share personal information, private conversations, or sensitive details without consent. Trust allows members and contributors to collaborate openly and confidently.',
                ),
                SizedBox(height: 18),
                Text(
                  "Last updated: April 2026",
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContainerBackground extends StatelessWidget {
  final String title;
  final String description;
  const _ContainerBackground({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.communityGuidelinesContainerBackground,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleLarge),
          const SizedBox(height: 10),
          Text(description, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}
