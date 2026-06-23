import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

sealed class FieldConfig {
  final String? group;
  const FieldConfig({this.group});
}

// Tekstfelt
class TextFieldConfig extends FieldConfig {
  final String key;
  final String label;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const TextFieldConfig({
    required this.key,
    required this.label,
    this.validator,
    this.controller,
    super.group,
  });
}

// Dato
class DateFieldConfig extends FieldConfig {
  final String key;
  final String label;
  final String? Function(DateTime?)? validator;

  const DateFieldConfig({
    required this.key,
    required this.label,
    this.validator,
    super.group,
  });
}

// Tidspunkt
class TimeFieldConfig extends FieldConfig {
  final String key;
  final String label;
  final String? Function(TimeOfDay?)? validator;

  const TimeFieldConfig({
    required this.key,
    required this.label,
    this.validator,
    super.group,
  });
}

// Select / dropdown
class SelectFieldConfig extends FieldConfig {
  final String key;
  final String label;
  final List<dynamic> options;
  final String Function(dynamic) optionLabel;
  final String? Function(dynamic)? validator;

  const SelectFieldConfig({
    required this.key,
    required this.label,
    required this.options,
    required this.optionLabel,
    this.validator,
    super.group,
  });
}

// Divider (rent visuel)
class DividerFieldConfig extends FieldConfig {
  final double height;
  final double thickness;
  const DividerFieldConfig({this.height = 16, this.thickness = 1, super.group});
}

// OpenBottomSheetFieldConfig (for at åbne en anden modal)
class OpenBottomSheetFieldConfig extends FieldConfig {
  final Widget Function(BuildContext context) builder;
  final Widget? icon;
  final String? label;
  const OpenBottomSheetFieldConfig({
    required this.builder,
    this.icon,
    this.label,
    super.group,
  });
}

// Custom Widget
class WidgetFieldConfig extends FieldConfig {
  final Widget child;
  const WidgetFieldConfig({required this.child, super.group});
}

// Text widget (as a subtitle for example)
class TextConfig extends FieldConfig {
  final String label;
  const TextConfig({required this.label, super.group});
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
      // Initialiser state for hvert felt
      switch (f) {
        case TextFieldConfig(key: final key):
          _textControllers[key] = f.controller ?? TextEditingController();
        case DateFieldConfig(key: final key):
          _dateValues[key] = null;
        case TimeFieldConfig(key: final key):
          _timeValues[key] = null;
        case SelectFieldConfig(key: final key):
          _selectValues[key] = null;
        case DividerFieldConfig():
          // ingen state
          break;
        case OpenBottomSheetFieldConfig():
          // ingen state
          break;
        case WidgetFieldConfig():
          // ingen state
          break;
        case TextConfig():
          // ingen state
          break;
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
        // saml sammenhængende felter med samme gruppe
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

      // enkelt fuld-bredde felt
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
    // Byg widget baseret på typen af FieldConfig
    return switch (f) {
      TextFieldConfig(:final key, :final label, :final validator) =>
        TextFormField(
          controller: _textControllers[key],
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          validator: validator,
        ),
      DateFieldConfig(:final key, :final label) => ListTile(
        title: Text(label),
        subtitle: Text(
          _dateValues[key] == null
              ? 'Vælg dato'
              : dateFormatter.format(_dateValues[key]!.toLocal()),
        ),
        trailing: const Icon(Icons.calendar_today),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        onTap: () => _selectDate(context, key),
      ),
      TimeFieldConfig(:final key, :final label) => ListTile(
        title: Text(label),
        subtitle: Text(
          _timeValues[key] == null
              ? 'Vælg tid'
              : _timeValues[key]!.format(context),
        ),
        trailing: const Icon(Icons.access_time),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        onTap: () => _selectTime(context, key),
      ),
      SelectFieldConfig(
        :final key,
        :final label,
        :final options,
        :final optionLabel,
        :final validator,
      ) =>
        DropdownButtonFormField<dynamic>(
          initialValue: _selectValues[key],
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          items: options
              .map(
                (o) => DropdownMenuItem<dynamic>(
                  value: o,
                  child: Text(optionLabel(o)),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => _selectValues[key] = v),
          validator: validator,
        ),
      DividerFieldConfig(:final height, :final thickness) => Divider(
        height: height,
        thickness: thickness,
      ),
      OpenBottomSheetFieldConfig(:final builder, :final icon, :final label) =>
        FilledButton.tonalIcon(
          onPressed: () {
            showModalBottomSheet(context: context, builder: builder);
          },
          icon: icon,
          label: Text(label ?? ""),
        ),

      WidgetFieldConfig(:final child) => child,
      // TODO: Handle this case.
      TextConfig(:final label) => Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    };
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

    // Saml data fra alle felter
    for (final f in widget.fields) {
      switch (f) {
        case TextFieldConfig(:final key):
          data[key] = _textControllers[key]!.text.trim();
        case DateFieldConfig(:final key):
          data[key] = _dateValues[key];
        case TimeFieldConfig(:final key):
          data[key] = _timeValues[key];
        case SelectFieldConfig(:final key):
          data[key] = _selectValues[key];
        case DividerFieldConfig():
          // ingen værdi
          break;
        case OpenBottomSheetFieldConfig():
          // ingen værdi
          break;
        case WidgetFieldConfig():
          // ingen værdi
          break;
        case TextConfig():
          // ingen værdi
          break;
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
        ? const Padding(
            padding: EdgeInsets.all(32.0),
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
                              onPressed: () => Navigator.of(context).pop(),
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
