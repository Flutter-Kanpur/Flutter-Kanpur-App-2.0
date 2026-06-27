import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_card.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_header.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_section_title.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_status_chip.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FkScreen(
      children: [
        const FkHeader(
          title: 'Events',
          subtitle:
              'Meetups, workshops, registrations, QR tickets, and check-in flow.',
        ),
        const SizedBox(height: 18),
        const FkSectionTitle(title: 'Event Flow'),
        const _EventFlowStep(
          title: 'Discover events',
          body: 'List published events from Supabase with pagination.',
          status: 'Next',
        ),
        const _EventFlowStep(
          title: 'Register',
          body: 'Optimistic registration UI with backend validation.',
          status: 'Planned',
        ),
        const _EventFlowStep(
          title: 'Ticket',
          body: 'Show secure QR ticket after payment or free registration.',
          status: 'Planned',
        ),
      ],
    );
  }
}

class _EventFlowStep extends StatelessWidget {
  const _EventFlowStep({
    required this.title,
    required this.body,
    required this.status,
  });

  final String title;
  final String body;
  final String status;

  @override
  Widget build(BuildContext context) {
    return FkCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.event_available_rounded),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(body),
              ],
            ),
          ),
          FkStatusChip(label: status),
        ],
      ),
    );
  }
}
