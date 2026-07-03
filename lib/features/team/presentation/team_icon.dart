import 'package:flutter/material.dart';

class TeamIcon extends StatelessWidget {
  const TeamIcon({super.key, required this.teamName});

  final String teamName;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Text(
        teamName.split(' ').map((s) => s[0]).join().toUpperCase(),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
