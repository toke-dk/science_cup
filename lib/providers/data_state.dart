import 'package:freezed_annotation/freezed_annotation.dart';
part 'data_state.freezed.dart';

@freezed
class DataState<T> with _$DataState<T> {
  const factory DataState.initial() = _Initial;
  const factory DataState.loading() = _Loading;
  const factory DataState.loaded(T data) = _Loaded<T>;
  const factory DataState.error(String message) = _Error;
}