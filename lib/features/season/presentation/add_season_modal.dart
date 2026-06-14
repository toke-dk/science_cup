import 'package:flutter/material.dart';

class AddSeasonModal extends StatelessWidget {
  const AddSeasonModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Tilføj Sæson", style: Theme.of(context).textTheme.headlineSmall),
        TextField(
          decoration: InputDecoration(labelText: 'Sæsonnavn'),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Startdato'),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Slutdato'),
        ),
        Row(
          children: [
            Spacer(),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuller'),
            ),
            FilledButton(
                child: Text("Gem"),
                onPressed: () {}),
          ],
        )
      ],
    );
  }
}