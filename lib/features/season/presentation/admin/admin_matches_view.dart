import 'package:flutter/material.dart';
import 'package:science_cup_app/features/group/presentation/edit_groups_view.dart';

class AdminGamesView extends StatefulWidget {
  const AdminGamesView({super.key});

  @override
  State<AdminGamesView> createState() => _AdminGamesViewState();
}

class _AdminGamesViewState extends State<AdminGamesView> {
  final List<ButtonSegment> _adminSegments = [
    ButtonSegment(
      value: "games",
      label: Text("Kampe"),
      icon: Icon(Icons.calendar_today_outlined),
    ),
    ButtonSegment(
      value: "groups",
      label: Text("Grupper"),
      icon: Icon(Icons.people),
    ),
    ButtonSegment(
      value: "teams",
      label: Text("Hold"),
      icon: Icon(Icons.person),
    ),
  ];

  late ButtonSegment _selectedAdminSegment = _adminSegments.first;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: SegmentedButton(
            showSelectedIcon: false,
            segments: _adminSegments,
            selected: {_selectedAdminSegment.value},
            onSelectionChanged: (newValue) {
              setState(() {
                _selectedAdminSegment = _adminSegments.firstWhere(
                  (segment) => segment.value == newValue.first,
                );
              });
            },
          ),
        ),
        switch (_selectedAdminSegment.value) {
          "games" => Text("KampSegment"),
          "groups" => EditGroupsView(),
          "teams" => Text("HoldSegment"),
          _ => SizedBox.shrink(),
        },
      ],
    );
  }
}
