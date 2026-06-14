import 'package:flutter/material.dart';
import 'package:science_cup_app/core/navigation/app_tab.dart';

enum SeasonTabs implements AppTab {
  games(
    title: 'Kampe',
    icon: Icons.calendar_today_outlined,
    path: 'games',
  );

  @override
  final String title;
  @override
  final IconData icon;
  @override
  final String path;
  @override
  String getFullPath(int parentId) {
    return '/seasons/$parentId/$path';
  }

  const SeasonTabs({
    required this.title,
    required this.icon,
    required this.path,
  });

  static SeasonTabs get defaultTab => SeasonTabs.values.first;

  static SeasonTabs fromPath(String? path) {
    return SeasonTabs.values.firstWhere(
          (tab) => tab.path == path,
      orElse: () => defaultTab,
    );
  }
}