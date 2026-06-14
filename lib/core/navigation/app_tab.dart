// lib/core/navigation/app_tab.dart
import 'package:flutter/material.dart';
import 'package:science_cup_app/features/auth/data/profile_role.dart';

class AppTab {
  final String title;
  final IconData icon;
  final String path;
  final ProfileRole? requiredRole;

  const AppTab({
    required this.title,
    required this.icon,
    required this.path,
    this.requiredRole,
  });

  String getFullPath(int parentId) => '/seasons/$parentId/$path';
}
