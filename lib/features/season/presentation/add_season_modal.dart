import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:science_cup_app/features/season/application/season/season_notifier.dart';

import '../../shared/presentation/create_entity_modal.dart';

class AddSeasonModal extends ConsumerWidget {
  const AddSeasonModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CreateEntityModal(
      title: 'Opret sæson',
      fields: [
        FieldConfig.text(
          key: 'name',
          label: 'Sæsonnavn (f.eks. SCIENCEcup - Forår yyyy)',
          validator: (v) => v == null || v.isEmpty ? 'Indtast navn' : null,
        ),
        FieldConfig.date(
          key: 'start',
          label: 'Startdato',
          validator: (v) => null,
        ),
        FieldConfig.date(key: 'end', label: 'Slutdato', validator: (v) => null),
      ],
      onSubmit: (data) async {
        // data['start'] and data['end'] are DateTime? (stored as UTC)
        await ref
            .read(seasonsProvider.notifier)
            .createSeason(
              name: data['name'],
              start: data['start'],
              end: data['end'],
            );
      },
    );
  }
}
