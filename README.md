# SCIENCEcup - software
Software for the official UCPH football league

## Starting the backend
To start the backend, navigate to the `backend` directory and run the following command while having a docker daemon running:

```bash
supabase start
```

## Migrating the database
After making changes to the database schema, you can run the following command in the `backend` directory to apply the migrations:

```bash
supabase db diff -f name_your_change
```
and a migration file will be created in the `backend/supabase/migrations` directory.


## Building models with freezed
To build the models with freezed, run the following command in the root directory of the project:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
make sure to have a file with the structure of the model you want to build in the `lib/models` directory and to annotate it with `@freezed` and to have a factory constructor that returns a private class that extends the model class. For example:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
  }) = _User;
}
```