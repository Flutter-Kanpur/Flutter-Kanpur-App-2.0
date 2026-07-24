import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_card.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/common_widgets/fk_status_chip.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FkScreen(
      children: [
        FkHeader(
          title: 'Guest Profile',
          subtitle:
              'Default profile state while auth/session restore is pending.',
        ),
        SizedBox(height: AppSpacing.s08),
        FkCard(
          child: Row(
            children: [
              CircleAvatar(radius: 28, child: Icon(Icons.person_rounded)),
              SizedBox(width: AppSpacing.s07),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Flutter Kanpur Developer'),
                    SizedBox(height: AppSpacing.s03),
                    FkStatusChip(label: 'Guest mode'),
                  ],
                ),
              ),
            ],
          ),
        ),
        FkCard(
          child: Text(
            'When auth is implemented, this page should read from the users, user_skills, community_memberships, and notifications tables.',
          ),
        ),
      ],
    );
  }
}
