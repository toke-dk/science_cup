import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:science_cup_app/features/group/data/models/group_with_teams.dart';
import 'package:science_cup_app/features/group/presentation/add_group_modal.dart';
import 'package:science_cup_app/features/team/data/models/team.dart';
import 'package:science_cup_app/shared/presentation/modals/show_create_entity_modal_bottom_sheet.dart';
import 'package:science_cup_app/shared/presentation/widgets/confirmation_dialog/confirmation_fields.dart';
import 'package:science_cup_app/shared/presentation/widgets/edit_delete_menu.dart';

class DisplayGroupWithTeam extends StatelessWidget {
  const DisplayGroupWithTeam({
    super.key,
    required this.groupWithTeam,
    required this.unassignedTeams,
    this.allowEditing = false,
    this.onTeamsChanged,
  });

  final GroupWithTeams groupWithTeam;
  final List<Team> unassignedTeams;
  final bool allowEditing;
  final Function(List<Team>)? onTeamsChanged;

  @override
  Widget build(BuildContext context) {
    return groupWithTeam.group == null
        ? const SizedBox.shrink()
        : Card(
            child: Column(
              children: [
                Row(
                  children: [
                    EditDeleteMenu(
                      onEdit: () {
                        showCreateEntityModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return AddGroupModal(group: groupWithTeam.group);
                          },
                        );
                      },
                      confirmationFields: ConfirmationFields(
                        title: "Slet gruppe",
                        content:
                            'Er du sikker på, at du vil slette gruppen ${groupWithTeam.group?.name}?',
                        confirmButtonText: 'Slet',
                      ),

                      onDelete: (isConfirmed) {},
                    ),
                    Text(groupWithTeam.group?.name ?? 'Uden navn'),
                    DropdownSearch<Team>.multiSelection(
                      mode: Mode.custom,
                      onSelected: onTeamsChanged,
                      selectedItems: groupWithTeam.teams,
                      itemAsString: (team) =>
                          team.name ?? 'Uden navn', // <-- den wrappede version
                      items: (filter, s) => [
                        ...groupWithTeam.teams,
                        ...unassignedTeams,
                      ], // <-- den wrappede version

                      compareFn: (a, b) => a.id == b.id,
                      dropdownBuilder: (context, selecteditem) =>
                          Icon(Icons.add),

                      popupProps: MultiSelectionPopupProps.menu(
                        constraints: BoxConstraints(
                          minWidth: 300,
                          maxWidth: 400,
                          maxHeight: 400,
                        ),
                        emptyBuilder: (context, searchEntry) => Container(
                          height: 70,
                          alignment: Alignment.center,
                          child: Text("Ingen elementer fundet"),
                        ),

                        showSelectedItems: true,
                        validationBuilder: (context, selectedItems) =>
                            Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    width: 1,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  if (onTeamsChanged != null) {
                                    onTeamsChanged!(selectedItems);
                                  }
                                  if (!context.mounted) return;
                                  Navigator.of(context).pop();
                                },
                                child: Text("GEM"),
                              ),
                            ),

                        containerBuilder: (ctx, popupWidget) {
                          return Padding(
                            padding: const EdgeInsets.all(
                              8.0,
                            ), // Padding hele vejen rundt
                            child: popupWidget,
                          );
                        },
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            labelText: 'Søg',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        showSearchBox: true,
                        itemBuilder: (context, item, isDisabled, isSelected) {
                          return ListTile(
                            title: Text(item.name ?? 'Uden navn'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                ...groupWithTeam.teams.map((team) {
                  return ListTile(title: Text(team.name ?? '?'));
                }),
              ],
            ),
          );
  }
}
