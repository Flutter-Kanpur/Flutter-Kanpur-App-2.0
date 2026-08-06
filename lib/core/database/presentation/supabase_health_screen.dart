import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/core/database/models/app_table_schema.dart';
import 'package:flutter_knp_mobile_app_v2/core/database/models/database_health_status.dart';
import 'package:flutter_knp_mobile_app_v2/core/database/services/supabase_database_service.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_spacing.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';

class SupabaseHealthScreen extends StatefulWidget {
  const SupabaseHealthScreen({super.key});

  @override
  State<SupabaseHealthScreen> createState() => _SupabaseHealthScreenState();
}

class _SupabaseHealthScreenState extends State<SupabaseHealthScreen> {
  late final Future<DatabaseHealthStatus> _statusFuture;

  @override
  void initState() {
    super.initState();
    _statusFuture = SupabaseDatabaseService().checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Kanpur Setup')),
      body: FutureBuilder<DatabaseHealthStatus>(
        future: _statusFuture,
        builder: (context, snapshot) {
          final status = snapshot.data;

          return ListView(
            padding: AppSpacing.all(AppSpacing.h16),
            children: [
              _StatusPanel(
                loading: snapshot.connectionState != ConnectionState.done,
                status: status,
              ),
              SizedBox(height: AppSpacing.v16),
              Text(
                'Supabase Tables',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: AppSpacing.v8),
              for (final table in appTableSchemas)
                Card(
                  child: ListTile(
                    title: Text(table.name),
                    subtitle: Text('${table.module}\n${table.purpose}'),
                    trailing: Text('${table.fields.length} fields'),
                    isThreeLine: true,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _StatusPanel extends StatelessWidget {
  const _StatusPanel({required this.loading, required this.status});

  final bool loading;
  final DatabaseHealthStatus? status;

  @override
  Widget build(BuildContext context) {
    final ready = status?.isReady ?? false;

    return Card(
      color: loading
          ? null
          : ready
          ? AppColors.success50
          : AppColors.pending50,
      child: Padding(
        padding: AppSpacing.all(AppSpacing.h16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loading
                  ? 'Checking Supabase connection...'
                  : ready
                  ? 'Supabase ready'
                  : 'Supabase needs attention',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: AppSpacing.v8),
            Text(status?.message ?? 'Please wait.'),
          ],
        ),
      ),
    );
  }
}
