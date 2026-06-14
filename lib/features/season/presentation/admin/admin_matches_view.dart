import 'package:flutter/material.dart';
import 'package:science_cup_app/features/game/data/game.dart';

import '../../../team/team.dart';

class AdminGamesView extends StatelessWidget {
  const AdminGamesView({super.key});

  Widget _buildGameCell(Game game) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${game.homeTeam?.name ?? "?"} vs ${game.awayTeam?.name ?? "?"}',
          style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
        ),
        const SizedBox(height: 2),
        Text(
          '${game.homeScore ?? ""} - ${game.awayScore ?? ""}',
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        dataRowMinHeight: 64, // Giver god luft til holdnavne og score
        dataRowMaxHeight: 64,
        horizontalMargin: 24,
        columns: [
          DataColumn(label: Text('')),

          DataColumn(label: Text('FASE')),
          DataColumn(label: Text('KAMP')),
          DataColumn(label: Text('DATO')),
          DataColumn(label: Text('TID')),
          DataColumn(label: Text('DOMMER')),
          DataColumn(label: Text('STATUS')),
        ],
        rows: List.generate(2, (index) =>
          DataRow(cells: [
            DataCell(IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {}),),
            DataCell(Text('Gruppe A')),
            DataCell(_buildGameCell(Game(
              homeTeam: Team(name: 'Holdfasdfasdfafasdfasd fasdfasdf 1'),
              awayTeam: Team(name: 'Hold 2'),
              homeScore: 3,
              awayScore: 1,
            ))),
            DataCell(Text('2024-07-01')),
            DataCell(Text('15:00')),
            DataCell(Text('Dommer 1')),
            DataCell(Text('Afsluttet')),

          ]))

      ),
    );
  }
}
