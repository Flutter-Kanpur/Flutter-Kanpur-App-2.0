import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_knp_mobile_app_v2/app/router/route_names.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_radius.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/application/notifications_provider.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/domain/app_notification.dart';
import 'package:flutter_knp_mobile_app_v2/modules/community/presentation/widgets/community_async_views.dart';
import 'package:flutter_knp_mobile_app_v2/shared/widgets/fk_screen_top_bar.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);
    final unread = ref.watch(unreadNotificationCountProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.h16,
              AppSpacing.v12,
              AppSpacing.h16,
              0,
            ),
            child: FkScreenTopBar(
              title: 'Notifications',
              fallbackPath: RouteNames.community,
              trailing: TextButton(
                onPressed: unread == 0
                    ? null
                    : () => ref
                          .read(notificationsProvider.notifier)
                          .markAllRead(),
                child: const Text('Mark all read'),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(notificationsProvider.notifier).refresh(),
              child: notificationsAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (e, _) => CommunityErrorView(
                  error: e,
                  message: 'Could not load notifications.',
                  onRetry: () =>
                      ref.read(notificationsProvider.notifier).refresh(),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return const CommunityEmptyView(
                      icon: Icons.notifications_none_rounded,
                      message: "You're all caught up.\nNothing new right now.",
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.h16,
                      AppSpacing.v16,
                      AppSpacing.h16,
                      96,
                    ),
                    itemCount: items.length,
                    separatorBuilder: (_, _) =>
                        SizedBox(height: AppSpacing.v12),
                    itemBuilder: (_, i) => _NotificationTile(items[i]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile(this.notification);

  final AppNotification notification;

  @override
  Widget build(BuildContext context) {
    final unread = !notification.isRead;
    return Container(
      padding: AppSpacing.all(AppSpacing.h16),
      decoration: BoxDecoration(
        color: unread ? AppColors.primary50 : AppColors.whiteBase,
        borderRadius: AppRadius.all03,
        border: Border.all(
          color: unread ? AppColors.primary100 : AppColors.communityBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: EdgeInsets.only(top: AppSpacing.v6, right: AppSpacing.h10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: unread ? AppColors.primary500 : Colors.transparent,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: unread ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
                if (notification.body.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.v4),
                  Text(
                    notification.body,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.neutral500,
                    ),
                  ),
                ],
                SizedBox(height: AppSpacing.v6),
                Text(
                  notification.createdLabel,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.neutral400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
