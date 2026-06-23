import 'package:flutter/material.dart';

Future<T?> showCreateEntityModalBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext context) builder,
}) {
  return showModalBottomSheet<T>(
    context: context,
    // For at sikre, at modal kan scrolle, når tastaturet er åbent
    isScrollControlled: true,
    builder: builder,
  );
}
