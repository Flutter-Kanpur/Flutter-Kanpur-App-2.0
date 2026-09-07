import 'package:flutter/material.dart';
import 'package:flutter_knp_mobile_app_v2/app/theme/app_colors.dart';
import 'package:flutter_knp_mobile_app_v2/modules/explore/domain/core_team_member.dart';

/// Team buckets used by the full core-team screen.
enum CoreTeamSection { organisors, appTeam, webTeam, designTeam }

/// Groups [CoreTeamMember] rows into the four team sections.
class CoreTeamGrouping {
  CoreTeamGrouping._();

  static CoreTeamSection sectionForRole(String? role) {
    final r = (role ?? '').trim().toLowerCase();
    if (r.contains('organizer') || r.contains('organisor')) {
      return CoreTeamSection.organisors;
    }
    if (r.contains('app') || r.contains('mobile')) {
      return CoreTeamSection.appTeam;
    }
    if (r.contains('web')) return CoreTeamSection.webTeam;
    if (r.contains('design') || r.contains('ui') || r.contains('ux')) {
      return CoreTeamSection.designTeam;
    }
    return CoreTeamSection.organisors;
  }

  static String titleFor(CoreTeamSection section) {
    return switch (section) {
      CoreTeamSection.organisors => 'Organisors',
      CoreTeamSection.appTeam => 'App Team',
      CoreTeamSection.webTeam => 'Web Team',
      CoreTeamSection.designTeam => 'Design Team',
    };
  }

  static Map<CoreTeamSection, List<CoreTeamMember>> groupBySection(
    List<CoreTeamMember> members,
  ) {
    final map = {
      for (final section in CoreTeamSection.values) section: <CoreTeamMember>[],
    };

    for (final member in members) {
      map[sectionForRole(member.role)]!.add(member);
    }

    return map;
  }

  static List<CoreTeamMember> sortLeadsFirst(List<CoreTeamMember> members) {
    final list = List<CoreTeamMember>.from(members);
    list.sort((a, b) {
      if (a.isLead && !b.isLead) return -1;
      if (!a.isLead && b.isLead) return 1;
      return a.name.compareTo(b.name);
    });
    return list;
  }
}

extension CoreTeamMemberX on CoreTeamMember {
  bool get isLead => role.toLowerCase().contains('lead');

  /// Short role label for cards. Organisors section uses organiser wording.
  String roleLabel({required bool isOrganisorsSection}) {
    final normalized = role.trim().toLowerCase();

    if (isOrganisorsSection) {
      if (normalized.contains('co') && normalized.contains('organi')) {
        return 'Co Organisor';
      }
      if (normalized.contains('organi')) return 'Organisor';
      return 'Organisor';
    }

    if (normalized.contains('mobile lead') ||
        normalized.contains('web lead') ||
        normalized.contains('design lead')) {
      return 'Lead';
    }
    if (normalized.contains('developer') || normalized.contains('member')) {
      return 'Member';
    }

    return role;
  }

  Color roleColor({required bool isOrganisorsSection}) {
    final label = roleLabel(isOrganisorsSection: isOrganisorsSection);
    if (label == 'Member') return AppColors.primary500;
    if (label == 'Organisor' || label == 'Co Organisor') {
      return AppColors.green;
    }
    return AppColors.green;
  }
}
