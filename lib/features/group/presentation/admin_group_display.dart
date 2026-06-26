import 'package:flutter/material.dart';
import 'package:science_cup_app/features/group/data/models/group.dart';
import 'package:science_cup_app/features/team/data/models/team.dart';
import 'package:science_cup_app/shared/presentation/widgets/card_with_title.dart';

class AdminGroupDisplay extends StatelessWidget {
  const AdminGroupDisplay({
    super.key,
    required this.group,
    required this.teams,
  });

  final Group group;
  final List<Team> teams;

  @override
  Widget build(BuildContext context) {
    return CardWithTitle(
      title: group.name ?? "Intet navn",
      child: Text("${teams.length} hold"),
    );
  }
}
