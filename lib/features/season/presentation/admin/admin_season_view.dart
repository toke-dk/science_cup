import 'package:flutter/material.dart';
import 'package:science_cup_app/features/contact/presentation/edit_contacts_page.dart';
import 'package:science_cup_app/features/game/presentation/edit_games_view.dart';
import 'package:science_cup_app/features/group/presentation/edit_groups_view.dart';
import 'package:science_cup_app/features/program/presentation/edit_programs_view.dart';
import 'package:science_cup_app/features/team/presentation/edit_teams_view.dart';

class AdminSeasonView extends StatefulWidget {
  const AdminSeasonView({super.key});

  @override
  State<AdminSeasonView> createState() => _AdminSeasonViewState();
}

class _AdminSeasonViewState extends State<AdminSeasonView> {
  final List<ButtonSegment> _adminSegments = [
    ButtonSegment(
      value: "games",
      label: Text("Kampe"),
      icon: Icon(Icons.calendar_today_outlined),
    ),
    ButtonSegment(
      value: "groups",
      label: Text("Grupper"),
      icon: Icon(Icons.grid_view_rounded),
    ),
    ButtonSegment(
      value: "teams",
      label: Text("Hold"),
      icon: Icon(Icons.groups),
    ),
    ButtonSegment(
      value: "programs",
      label: Text("Studier"),
      icon: Icon(Icons.school),
    ),
    ButtonSegment(
      value: "contacts",
      label: Text("Kontakter"),
      icon: Icon(Icons.contact_page_rounded),
    ),
  ];

  late ButtonSegment _selectedAdminSegment = _adminSegments.first;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
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
          "games" => EditGamesView(),
          "groups" => EditGroupsView(),
          "teams" => EditTeamsView(),
          "programs" => ProgramsView(),
          "contacts" => EditContactsView(),
          _ => SizedBox.shrink(),
        },
      ],
    );
  }
}
