import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:science_cup_app/features/season/state/season_notifier.dart';

class AddSeasonModal extends StatefulWidget {
  const AddSeasonModal({super.key});

  @override
  State<AddSeasonModal> createState() => _AddSeasonModalState();
}

class _AddSeasonModalState extends State<AddSeasonModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  // Hjælpefunktion til at åbne kalenderen
  Future<void> _selectDate(
    BuildContext context, {
    required bool isStartDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      locale: Locale("da"),
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          // Vi tager datoen og tvinger den til UTC
          _startDate = DateTime.utc(picked.year, picked.month, picked.day);
          // Hvis slutdatoen er før den nye startdato, nulstiller vi den
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = DateTime.utc(
            picked.year,
            picked.month,
            picked.day,
            23,
            59,
            59,
          ); // Sætter til slutningen af dagen
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Udfyld venligst alle felter og datoer')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await context.read<SeasonsNotifier>().createSeason(
        name: _nameController.text.trim(),
        start: _startDate,
        end: _endDate,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sæson oprettet succesfuldt!')),
        );
        Navigator.pop(context); // Gå tilbage efter succes
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Fejl: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Bruges til at vise datoen pænt for brugeren (f.eks. "14. jun. 2026")
    final dateFormatter = DateFormat.yMMMd('da_DK');

    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Sæsonnavn
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Sæsonnavn (f.eks. SCIENCEcup - Forår yyyy)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Indtast navn' : null,
                  ),
                  const SizedBox(height: 20),

                  // START DATO FELT
                  ListTile(
                    title: const Text('Startdato'),
                    subtitle: Text(
                      _startDate == null
                          ? 'Vælg startdato'
                          : dateFormatter.format(_startDate!.toLocal()),
                    ),
                    // Viser i lokal tid i UI
                    trailing: const Icon(Icons.calendar_today),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    onTap: () => _selectDate(context, isStartDate: true),
                  ),
                  const SizedBox(height: 20),

                  // SLUT DATO FELT
                  ListTile(
                    title: const Text('Slutdato'),
                    subtitle: Text(
                      _endDate == null
                          ? 'Vælg slutdato'
                          : dateFormatter.format(_endDate!.toLocal()),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    // Deaktiver slutdato indtil startdato er valgt
                    onTap: _startDate == null
                        ? null
                        : () => _selectDate(context, isStartDate: false),
                    enabled: _startDate != null,
                  ),
                  const SizedBox(height: 30),

                  // GEM KNAP
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text("Annuler"),
                        ),
                      ),
                      Gap(10),
                      Expanded(
                        flex: 3,
                        child: FilledButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Gem',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
