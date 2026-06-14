import 'package:flutter/material.dart';
import 'package:science_cup_app/features/season/presentation/admin/admin_matches_view.dart';

class AdminSeasonView extends StatelessWidget {
  const AdminSeasonView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AdminGamesView()
      ],
    );
  }
}
