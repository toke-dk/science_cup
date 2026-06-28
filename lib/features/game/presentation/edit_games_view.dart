import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/game/presentation/add_game_modal.dart';
import 'package:science_cup_app/shared/presentation/modals/show_create_entity_modal_bottom_sheet.dart';

class EditGamesView extends ConsumerWidget {
  const EditGamesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        FilledButton.icon(
          onPressed: () {
            showCreateEntityModalBottomSheet(
              context: context,
              builder: (context) {
                return AddGameModal();
              },
            );
          },
          icon: const Icon(Icons.add),
          label: const Text("Opret kamp"),
        ),
      ],
    );
  }
}
