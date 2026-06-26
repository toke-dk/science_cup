import 'package:flutter/material.dart';

class CardWithTitle extends StatelessWidget {
  const CardWithTitle({
    super.key,
    required this.title,
    required this.child,
    this.onAdd,
  });

  final String title;
  final Widget child;
  final Function()? onAdd;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title),
                if (onAdd != null)
                  IconButton(icon: const Icon(Icons.add), onPressed: onAdd),
              ],
            ),
            child,
          ],
        ),
      ),
    );
  }
}
