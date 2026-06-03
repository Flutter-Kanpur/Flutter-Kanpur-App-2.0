import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_back_button.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_card.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';

class CommunityGuidelinesScreen extends StatelessWidget {
  const CommunityGuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      'Use guest mode only while auth is pending.',
      'Keep UI state inside feature providers.',
      'Connect write actions through Supabase repositories, not directly from widgets.',
      'Use pagination and cached feed sections before adding realtime streams.',
    ];

    return FkScreen(
      children: [
        const FkHeader(
          title: 'Guidelines',
          subtitle: 'Temporary development rules for the community module.',
          leading: FkBackButton(),
        ),
        const SizedBox(height: 18),
        for (final item in items)
          FkCard(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_rounded),
                const SizedBox(width: 12),
                Expanded(child: Text(item)),
              ],
            ),
          ),
      ],
    );
  }
}
