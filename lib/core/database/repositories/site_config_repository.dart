import 'dart:convert';

import 'package:flutter_knp_mobile_app_v2/core/database/database_tables.dart';
import 'package:flutter_knp_mobile_app_v2/core/database/repositories/supabase_repository.dart';

class SiteConfigRepository extends SupabaseRepository {
  SiteConfigRepository({super.client})
    : super(tableName: DatabaseTables.siteConfig);

  static const onboardingRolesKey = 'onboarding_roles';
  static const onboardingSkillsKey = 'onboarding_skills';

  Future<Map<String, dynamic>?> fetchSchemaVersion() {
    return table
        .select('config_key, config_type, json_payload, updated_at')
        .eq('config_key', 'app_schema_version')
        .maybeSingle();
  }

  /// Reads a JSON array of strings from [configKey].
  Future<List<String>> fetchStringList(String configKey) async {
    final row = await table
        .select('json_payload')
        .eq('config_key', configKey)
        .maybeSingle();
    if (row == null) return const [];
    return _parseStringList(row['json_payload']);
  }

  /// Appends [value] to the list at [configKey] (case-insensitive dedupe).
  /// Returns the updated list from the server.
  Future<List<String>> appendToStringList(String configKey, String value) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return fetchStringList(configKey);

    final current = await fetchStringList(configKey);
    final exists = current.any(
      (item) => item.toLowerCase() == trimmed.toLowerCase(),
    );
    if (exists) return current;

    final updated = [...current, trimmed];
    await table.update({'json_payload': updated}).eq('config_key', configKey);
    return updated;
  }

  List<String> _parseStringList(dynamic payload) {
    if (payload == null) return const [];

    if (payload is List) {
      return payload
          .map((e) => e.toString().trim())
          .where((s) => s.isNotEmpty)
          .toList();
    }

    if (payload is String) {
      try {
        final decoded = jsonDecode(payload);
        return _parseStringList(decoded);
      } catch (_) {
        return const [];
      }
    }

    return const [];
  }
}
