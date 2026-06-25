import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:science_cup_app/shared/presentation/modals/show_create_entity_modal_bottom_sheet.dart';

sealed class FieldConfig {
  final String? group;
  // Til at tilføje studie/kontakt eller lignenden
  final Function()? createEntity;
  const FieldConfig({this.group, this.createEntity});
}

// Tekstfelt
class TextFieldConfig extends FieldConfig {
  final String key;
  final String label;
  final String? initialValue;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const TextFieldConfig({
    required this.key,
    required this.label,
    this.initialValue,
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
  final DateTime? initialValue;

  const DateFieldConfig({
    required this.key,
    required this.label,
    this.validator,
    this.initialValue,
    super.group,
  });
}

// Tidspunkt
class TimeFieldConfig extends FieldConfig {
  final String key;
  final String label;
  final String? Function(TimeOfDay?)? validator;
  final TimeOfDay? initialValue;

  const TimeFieldConfig({
    required this.key,
    required this.label,
    this.validator,
    this.initialValue,
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
  final dynamic initialValue;

  const SelectFieldConfig({
    required this.key,
    required this.label,
    required this.options,
    required this.optionLabel,
    this.validator,
    this.initialValue,
    super.group,
    super.createEntity,
  });
}

// Divider (rent visuel)
class DividerFieldConfig extends FieldConfig {
  final double height;
  final double thickness;
  const DividerFieldConfig({this.height = 16, this.thickness = 1, super.group});
}

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

// For inputting phone numbers
class PhoneFieldConfig extends FieldConfig {
  final String key;
  final String label;
  final bool? required;
  final PhoneController? controller;
  final PhoneNumber? initialValue;

  const PhoneFieldConfig({
    required this.key,
    required this.label,
    this.required = false,
    this.controller,
    this.initialValue,
    super.group,
  });
}

class MultiSelectFieldConfig<T> extends FieldConfig {
  final String key;
  final String label;

  /// Intern type‑sikker funktion.
  final List<T> Function(String filter) _items;

  /// Dynamisk wrapper til `DropdownSearch`.
  List<dynamic> Function(String filter, dynamic _) get items =>
      (filter, _) => _items(filter).cast<dynamic>();

  final String Function(T) _itemAsStringTyped;
  final String Function(T) _itemLabelStringTyped;
  final String Function(T)? _itemSubtitleStringTyped;

  /// Dynamisk wrappere der cast’er input til `T`.
  String Function(dynamic) get itemAsString =>
      (dynamic x) => _itemAsStringTyped(x as T);
  String Function(dynamic) get itemLabelString =>
      (dynamic x) => _itemLabelStringTyped(x as T);
  String Function(dynamic)? get itemSubtitleString =>
      _itemSubtitleStringTyped != null
      ? (dynamic x) => _itemSubtitleStringTyped(x as T)
      : null;

  final List<T>? initialValues;
  final String? Function(List<T>?)? validator;

  const MultiSelectFieldConfig({
    required this.key,
    required this.label,
    required List<T> Function(String filter) items,
    required String Function(T) itemAsString,
    required String Function(T) itemLabelString,
    String Function(T)? itemSubtitleString,
    this.initialValues,
    this.validator,
    super.group,
    super.createEntity,
  }) : _items = items,
       _itemAsStringTyped = itemAsString,
       _itemLabelStringTyped = itemLabelString,
       _itemSubtitleStringTyped = itemSubtitleString;
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
  final Map<String, PhoneController> _phoneControllers = {};
  final Map<String, DateTime?> _dateValues = {};
  final Map<String, TimeOfDay?> _timeValues = {};
  final Map<String, dynamic> _selectValues = {};
  final Map<String, List<dynamic>> _multiSelectValues = {};
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    for (final f in widget.fields) {
      // Initialiser state for hvert felt
      switch (f) {
        case TextFieldConfig(key: final key):
          _textControllers[key] =
              f.controller ?? TextEditingController(text: f.initialValue);
        case PhoneFieldConfig(key: final key):
          _phoneControllers[key] =
              f.controller ??
              PhoneController(
                initialValue:
                    f.initialValue ?? PhoneNumber(isoCode: IsoCode.DK, nsn: ''),
              );
        case DateFieldConfig(key: final key):
          _dateValues[key] = f.initialValue;
        case TimeFieldConfig(key: final key):
          _timeValues[key] = f.initialValue;
        case SelectFieldConfig(key: final key):
          _selectValues[key] = f.initialValue;
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
        case MultiSelectFieldConfig(key: final key):
          _multiSelectValues[key] = f.initialValues ?? [];
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
          child: Row(
            children: [
              Expanded(child: _buildSingleFieldWidget(f, dateFormatter)),
              f.createEntity == null
                  ? const SizedBox.shrink()
                  : IconButton(
                      onPressed: f.createEntity,
                      icon: Icon(Icons.add),
                    ),
            ],
          ),
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
            showCreateEntityModalBottomSheet(
              context: context,
              builder: builder,
            );
          },
          icon: icon,
          label: Text(label ?? ""),
        ),

      WidgetFieldConfig(:final child) => child,
      TextConfig(:final label) => Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      PhoneFieldConfig() => PhoneFormField(
        controller: _phoneControllers[f.key],
        decoration: InputDecoration(
          labelText: f.label,
          border: const OutlineInputBorder(),
        ),
        validator: PhoneValidator.compose([
          if (f.required == true)
            PhoneValidator.required(
              context,
              errorText: 'Indtast telefonnummer',
            ),
          PhoneValidator.valid(context, errorText: 'Ugyldigt telefonnummer'),
        ]),
      ),
      // I _buildSingleFieldWidget – ny case:
      MultiSelectFieldConfig f => DropdownSearch<dynamic>.multiSelection(
        onSelected: (selected) {
          setState(() => _multiSelectValues[f.key] = selected);
        },
        selectedItems: _multiSelectValues[f.key] ?? [],
        itemAsString: f.itemAsString, // <-- String Function(dynamic)
        items: f.items, // <-- den wrappede version

        compareFn: (a, b) => a == b,
        dropdownBuilder: (_multiSelectValues[f.key]?.isNotEmpty ?? false)
            ? null
            : (context, selecteditem) => Text("Vælg ${f.label}"),

        popupProps: MultiSelectionPopupProps.modalBottomSheet(
          emptyBuilder: (context, searchEntry) => Container(
            height: 70,
            alignment: Alignment.center,
            child: Text("Ingen elementer fundet"),
          ),

          showSelectedItems: true,
          validationBuilder: (context, selectedItems) => Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1, color: Colors.grey.shade300),
              ),
            ),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => _multiSelectValues[f.key] = selectedItems);
              },
              child: Text("GEM"),
            ),
          ),

          containerBuilder: (ctx, popupWidget) {
            return Padding(
              padding: const EdgeInsets.all(8.0), // Padding hele vejen rundt
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
              title: Text(f.itemLabelString(item)),
              subtitle: f.itemSubtitleString != null
                  ? Text(f.itemSubtitleString!(item))
                  : null,
            );
          },
        ),
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
        case PhoneFieldConfig():
          data[f.key] = _phoneControllers[f.key]?.value;
        case MultiSelectFieldConfig(:final key):
          data[key] = _multiSelectValues[key];
      }
    }

    try {
      await widget.onSubmit(data);
      if (mounted) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Oprettet succesfuldt!')));
      }
    } catch (e) {
      setState(() => _isLoading = false);
      debugPrint('Error in onSubmit: $e');
      setState(() {
        _errorMessage = 'Fejl ved oprettelse: $e';
      });
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
        : AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                        ),
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 20),
                      ..._buildFieldWidgets(dateFormatter),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Spacer(),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Annuller'),
                          ),
                          const SizedBox(width: 10),
                          FilledButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text(
                              'Gem',
                              style: TextStyle(fontSize: 16),
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
