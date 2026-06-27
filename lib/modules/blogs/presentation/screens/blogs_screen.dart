import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_card.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_status_chip.dart';

class BlogsScreen extends StatelessWidget {
  const BlogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FkScreen(
      children: const [
        FkHeader(
          title: 'Blogs',
          subtitle:
              'Dedicated blog product integrated into Flutter Kanpur ecosystem.',
        ),
        SizedBox(height: 18),
        FkCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FkStatusChip(label: 'Modular'),
              SizedBox(height: 12),
              Text('Shared auth/profile identity'),
              SizedBox(height: 8),
              Text(
                'Blog feed, editor, drafts, tags, notifications, and analytics should stay independent from community feed logic.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
