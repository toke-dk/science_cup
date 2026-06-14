import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:science_cup_app/features/group/data/group.dart';
import 'package:science_cup_app/providers/data_state.dart';

import '../../../../group/state/group_notifier.dart';

class GroupsSegment extends StatelessWidget {
  const GroupsSegment({super.key});

  @override
  Widget build(BuildContext context) {
    final groupsState = context.watch<GroupNotifier>().state;

    return groupsState.when(
      initial: () => const Center(child: Text("Vælg en sæson for at se grupper")),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (message) =>
          Center(child: Text("Fejl ved indlæsning af grupper: $message")),
      loaded: (groups) => const Column(children: [Row(children: [])]),
    );
  }
}
