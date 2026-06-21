import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// TODO fieldvalue types to add: divider, text, email, phone number
enum FieldType { text, date, select, time }

class FieldConfig {
  final String key;
  final String label;
  final FieldType type;
  final String? Function(dynamic)? validator;

  // Optional controller for text fields (if you want to reuse externally)
  final TextEditingController? controller;

  // For select fields
  final List<dynamic>? options;
  // Builder to convert an option to display text
  final String Function(dynamic)? optionLabel;

  // Group id: if multiple fields share same non-null group, they'll be
  // rendered inline in a single Row (useful for date+time).
  final String? group;

  FieldConfig.text({
    required this.key,
    required this.label,
    this.validator,
    this.controller,
    this.group,
  }) : type = FieldType.text,
       options = null,
       optionLabel = null;

  FieldConfig.date({
    required this.key,
    required this.label,
    this.validator,
    this.group,
  }) : type = FieldType.date,
       controller = null,
       options = null,
       optionLabel = null;

  FieldConfig.select({
    required this.key,
    required this.label,
    required this.options,
    required this.optionLabel,
    this.validator,
    this.group,
  }) : type = FieldType.select,
       controller = null;

  FieldConfig.time({
    required this.key,
    required this.label,
    this.validator,
    this.group,
  }) : type = FieldType.time,
       controller = null,
       options = null,
       optionLabel = null;
}

typedef SubmitCallback = Future<void> Function(Map<String, dynamic> data);

class CreateEntityModal extends StatefulWidget {
  final String title;
  final List<FieldConfig> fields;
  final SubmitCallback onSubmit;

  const CreateEntityModal({
    super.key,
    required this.title,
    required this.fields,
    required this.onSubmit,
  });

  @override
  State<CreateEntityModal> createState() => _CreateEntityModalState();
}

class _CreateEntityModalState extends State<CreateEntityModal> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, DateTime?> _dateValues = {};
  final Map<String, TimeOfDay?> _timeValues = {};
  final Map<String, dynamic> _selectValues = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    for (final f in widget.fields) {
      if (f.type == FieldType.text) {
        _textControllers[f.key] = f.controller ?? TextEditingController();
      } else if (f.type == FieldType.date) {
        _dateValues[f.key] = null;
      } else if (f.type == FieldType.time) {
        _timeValues[f.key] = null;
      } else if (f.type == FieldType.select) {
        _selectValues[f.key] = null;
      }
    }
  }

  List<Widget> _buildFieldWidgets(DateFormat dateFormatter) {
    final widgets = <Widget>[];
    final fields = widget.fields;
    int i = 0;
    while (i < fields.length) {
      final f = fields[i];
      final group = f.group;
      if (group != null) {
        // collect consecutive fields with same group
        final groupItems = <FieldConfig>[];
        int j = i;
        while (j < fields.length && fields[j].group == group) {
          groupItems.add(fields[j]);
          j++;
        }

        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              children: groupItems.map((gf) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: _buildSingleFieldWidget(gf, dateFormatter),
                  ),
                );
              }).toList(),
            ),
          ),
        );
        i = j;
        continue;
      }

      // single full-width field
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildSingleFieldWidget(f, dateFormatter),
        ),
      );
      i += 1;
    }

    return widgets;
  }

  Widget _buildSingleFieldWidget(FieldConfig f, DateFormat dateFormatter) {
    switch (f.type) {
      case FieldType.text:
        return TextFormField(
          controller: _textControllers[f.key],
          decoration: InputDecoration(
            labelText: f.label,
            border: const OutlineInputBorder(),
          ),
          validator: f.validator,
        );
      case FieldType.date:
        final date = _dateValues[f.key];
        return ListTile(
          title: Text(f.label),
          subtitle: Text(
            date == null ? 'Vælg dato' : dateFormatter.format(date.toLocal()),
          ),
          trailing: const Icon(Icons.calendar_today),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          onTap: () => _selectDate(context, f.key),
        );
      case FieldType.time:
        final tod = _timeValues[f.key];
        return ListTile(
          title: Text(f.label),
          subtitle: Text(tod == null ? 'Vælg tid' : tod.format(context)),
          trailing: const Icon(Icons.access_time),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          onTap: () => _selectTime(context, f.key),
        );
      case FieldType.select:
        final options = f.options ?? <dynamic>[];
        final labeler = f.optionLabel ?? (o) => o?.toString() ?? '';
        return DropdownButtonFormField<dynamic>(
          initialValue: _selectValues[f.key],
          decoration: InputDecoration(
            labelText: f.label,
            border: const OutlineInputBorder(),
          ),
          items: options
              .map(
                (o) => DropdownMenuItem<dynamic>(
                  value: o,
                  child: Text(labeler(o)),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => _selectValues[f.key] = v),
          validator: f.validator,
        );
    }
  }

  @override
  void dispose() {
    for (final c in _textControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, String key) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('da'),
    );

    if (picked != null) {
      setState(() {
        _dateValues[key] = DateTime.utc(picked.year, picked.month, picked.day);
      });
    }
  }

  Future<void> _selectTime(BuildContext context, String key) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _timeValues[key] = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Udfyld venligst alle felter')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final data = <String, dynamic>{};
    for (final f in widget.fields) {
      if (f.type == FieldType.text) {
        data[f.key] = _textControllers[f.key]!.text.trim();
      } else if (f.type == FieldType.date) {
        data[f.key] = _dateValues[f.key];
      } else if (f.type == FieldType.time) {
        data[f.key] = _timeValues[f.key];
      } else if (f.type == FieldType.select) {
        data[f.key] = _selectValues[f.key];
      }
    }

    try {
      await widget.onSubmit(data);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Oprettet succesfuldt!')));
        Navigator.of(context).pop();
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
    final dateFormatter = DateFormat.yMMMd('da_DK');

    return _isLoading
        ? Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Center(child: CircularProgressIndicator())],
            ),
          )
        : Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 20),
                      ..._buildFieldWidgets(dateFormatter),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: const Text('Annuler'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: FilledButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
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
              ),
            ),
          );
  }
}
