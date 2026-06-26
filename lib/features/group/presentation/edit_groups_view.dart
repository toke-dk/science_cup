import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/group/presentation/add_group_modal.dart';
import 'package:science_cup_app/features/group/presentation/admin_group_display.dart';
import 'package:science_cup_app/features/season/application/active_season/current_season_provider.dart';
import 'package:science_cup_app/shared/presentation/modals/show_create_entity_modal_bottom_sheet.dart';

import '../application/group_notifier.dart';

class EditGroupsView extends ConsumerWidget {
  const EditGroupsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsState = ref.watch(
      groupProvider(ref.watch(currentSeasonProvider)?.id),
    );

    return groupsState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stacktrace) =>
          Center(child: Text("Fejl ved indlæsning af grupper: $error")),
      data: (groups) => Column(
        children: [
          Row(
            children: [
              Text("${groups.length} grupper"),
              Spacer(),
              FilledButton.icon(
                onPressed: () {
                  showCreateEntityModalBottomSheet(
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
                .map((g) => AdminGroupDisplay(group: g, teams: []))
                .toList(),
          ),
        ],
      ),
    );
  }
}
