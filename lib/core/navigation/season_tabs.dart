import 'package:flutter/material.dart';
import 'package:science_cup_app/core/navigation/app_tab.dart';

import '../../features/auth/data/profile_role.dart';

enum SeasonTabs implements AppTab {
  games(title: 'Kampe', icon: Icons.calendar_today_outlined, path: 'games'),
  admin(
    title: 'Admin',
    icon: Icons.admin_panel_settings_outlined,
    path: 'admin',
    requiredRole: ProfileRole.admin,
  );

  @override
  final String title;
  @override
  final IconData icon;
  @override
  final String path;
  @override
  final ProfileRole? requiredRole;

  @override
  String getFullPath(int parentId) {
    return '/seasons/$parentId/$path';
  }

  const SeasonTabs({
    required this.title,
    required this.icon,
    required this.path,
    this.requiredRole,
  });

  static SeasonTabs get defaultTab => SeasonTabs.values.first;

  static SeasonTabs fromPath(String? path) {
    return SeasonTabs.values.firstWhere(
      (tab) => tab.path == path,
      orElse: () => defaultTab,
    );
  }

  static List<SeasonTabs> availableTabsForRole(ProfileRole? role) {
    return SeasonTabs.values
        .where((tab) => canAccessTab(tab, role) == true)
        .toList();
  }

  static bool canAccessTab(SeasonTabs tab, ProfileRole? role) {
    return tab.requiredRole == null || tab.requiredRole == role;
  }
}
