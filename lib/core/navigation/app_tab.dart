// lib/core/navigation/app_tab.dart
import 'package:flutter/material.dart';

class AppTab {
  final String title;
  final IconData icon;
  final String path;

  const AppTab({
    required this.title,
    required this.icon,
    required this.path,
  });

  String getFullPath(int parentId) => '/seasons/$parentId/$path';
}