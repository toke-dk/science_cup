import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:science_cup_app/core/providers/data_state.dart';
import 'package:science_cup_app/features/group/presentation/add_group_modal.dart';

import '../application/group_notifier.dart';

class EditGroupsView extends StatelessWidget {
  const EditGroupsView({super.key});

  @override
  Widget build(BuildContext context) {
    final groupsState = context.watch<GroupNotifier>().state;

    return groupsState.when(
      initial: () =>
          const Center(child: Text("Vælg en sæson for at se grupper")),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (message) =>
          Center(child: Text("Fejl ved indlæsning af grupper: $message")),
      loaded: (groups) => Column(
        children: [
          Row(
            children: [
              Text("${groups.length} grupper"),
              Spacer(),
              FilledButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return AddGroupModal();
                    },
                  );
                },
                label: Text("Ny Gruppe"),
                icon: Icon(Icons.add),
              ),
            ],
          ),
          ListView(
            shrinkWrap: true,
            children: groups
                .map((g) => ListTile(title: Text(g.name ?? "Ingen navn")))
                .toList(),
          ),
        ],
      ),
    );
  }
}
