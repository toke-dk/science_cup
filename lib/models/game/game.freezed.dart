// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Game {

 int get id; Season? get season; Team? get homeTeam; Team? get awayTeam; int? get homeScore; int? get awayScore; Group? get group; bool? get refereeAbsent; String? get comment; DateTime? get createdAt; DateTime? get startDate; Team? get refereeTeam;
/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameCopyWith<Game> get copyWith => _$GameCopyWithImpl<Game>(this as Game, _$identity);

  /// Serializes this Game to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Game&&(identical(other.id, id) || other.id == id)&&(identical(other.season, season) || other.season == season)&&(identical(other.homeTeam, homeTeam) || other.homeTeam == homeTeam)&&(identical(other.awayTeam, awayTeam) || other.awayTeam == awayTeam)&&(identical(other.homeScore, homeScore) || other.homeScore == homeScore)&&(identical(other.awayScore, awayScore) || other.awayScore == awayScore)&&(identical(other.group, group) || other.group == group)&&(identical(other.refereeAbsent, refereeAbsent) || other.refereeAbsent == refereeAbsent)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.refereeTeam, refereeTeam) || other.refereeTeam == refereeTeam));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,season,homeTeam,awayTeam,homeScore,awayScore,group,refereeAbsent,comment,createdAt,startDate,refereeTeam);

@override
String toString() {
  return 'Game(id: $id, season: $season, homeTeam: $homeTeam, awayTeam: $awayTeam, homeScore: $homeScore, awayScore: $awayScore, group: $group, refereeAbsent: $refereeAbsent, comment: $comment, createdAt: $createdAt, startDate: $startDate, refereeTeam: $refereeTeam)';
}


}

/// @nodoc
abstract mixin class $GameCopyWith<$Res>  {
  factory $GameCopyWith(Game value, $Res Function(Game) _then) = _$GameCopyWithImpl;
@useResult
$Res call({
 int id, Season? season, Team? homeTeam, Team? awayTeam, int? homeScore, int? awayScore, Group? group, bool? refereeAbsent, String? comment, DateTime? createdAt, DateTime? startDate, Team? refereeTeam
});


$SeasonCopyWith<$Res>? get season;$TeamCopyWith<$Res>? get homeTeam;$TeamCopyWith<$Res>? get awayTeam;$GroupCopyWith<$Res>? get group;$TeamCopyWith<$Res>? get refereeTeam;

}
/// @nodoc
class _$GameCopyWithImpl<$Res>
    implements $GameCopyWith<$Res> {
  _$GameCopyWithImpl(this._self, this._then);

  final Game _self;
  final $Res Function(Game) _then;

/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? season = freezed,Object? homeTeam = freezed,Object? awayTeam = freezed,Object? homeScore = freezed,Object? awayScore = freezed,Object? group = freezed,Object? refereeAbsent = freezed,Object? comment = freezed,Object? createdAt = freezed,Object? startDate = freezed,Object? refereeTeam = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,season: freezed == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as Season?,homeTeam: freezed == homeTeam ? _self.homeTeam : homeTeam // ignore: cast_nullable_to_non_nullable
as Team?,awayTeam: freezed == awayTeam ? _self.awayTeam : awayTeam // ignore: cast_nullable_to_non_nullable
as Team?,homeScore: freezed == homeScore ? _self.homeScore : homeScore // ignore: cast_nullable_to_non_nullable
as int?,awayScore: freezed == awayScore ? _self.awayScore : awayScore // ignore: cast_nullable_to_non_nullable
as int?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as Group?,refereeAbsent: freezed == refereeAbsent ? _self.refereeAbsent : refereeAbsent // ignore: cast_nullable_to_non_nullable
as bool?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,refereeTeam: freezed == refereeTeam ? _self.refereeTeam : refereeTeam // ignore: cast_nullable_to_non_nullable
as Team?,
  ));
}
/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonCopyWith<$Res>? get season {
    if (_self.season == null) {
    return null;
  }

  return $SeasonCopyWith<$Res>(_self.season!, (value) {
    return _then(_self.copyWith(season: value));
  });
}/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamCopyWith<$Res>? get homeTeam {
    if (_self.homeTeam == null) {
    return null;
  }

  return $TeamCopyWith<$Res>(_self.homeTeam!, (value) {
    return _then(_self.copyWith(homeTeam: value));
  });
}/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamCopyWith<$Res>? get awayTeam {
    if (_self.awayTeam == null) {
    return null;
  }

  return $TeamCopyWith<$Res>(_self.awayTeam!, (value) {
    return _then(_self.copyWith(awayTeam: value));
  });
}/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupCopyWith<$Res>? get group {
    if (_self.group == null) {
    return null;
  }

  return $GroupCopyWith<$Res>(_self.group!, (value) {
    return _then(_self.copyWith(group: value));
  });
}/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamCopyWith<$Res>? get refereeTeam {
    if (_self.refereeTeam == null) {
    return null;
  }

  return $TeamCopyWith<$Res>(_self.refereeTeam!, (value) {
    return _then(_self.copyWith(refereeTeam: value));
  });
}
}


/// Adds pattern-matching-related methods to [Game].
extension GamePatterns on Game {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Game value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Game() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Game value)  $default,){
final _that = this;
switch (_that) {
case _Game():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Game value)?  $default,){
final _that = this;
switch (_that) {
case _Game() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  Season? season,  Team? homeTeam,  Team? awayTeam,  int? homeScore,  int? awayScore,  Group? group,  bool? refereeAbsent,  String? comment,  DateTime? createdAt,  DateTime? startDate,  Team? refereeTeam)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Game() when $default != null:
return $default(_that.id,_that.season,_that.homeTeam,_that.awayTeam,_that.homeScore,_that.awayScore,_that.group,_that.refereeAbsent,_that.comment,_that.createdAt,_that.startDate,_that.refereeTeam);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  Season? season,  Team? homeTeam,  Team? awayTeam,  int? homeScore,  int? awayScore,  Group? group,  bool? refereeAbsent,  String? comment,  DateTime? createdAt,  DateTime? startDate,  Team? refereeTeam)  $default,) {final _that = this;
switch (_that) {
case _Game():
return $default(_that.id,_that.season,_that.homeTeam,_that.awayTeam,_that.homeScore,_that.awayScore,_that.group,_that.refereeAbsent,_that.comment,_that.createdAt,_that.startDate,_that.refereeTeam);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  Season? season,  Team? homeTeam,  Team? awayTeam,  int? homeScore,  int? awayScore,  Group? group,  bool? refereeAbsent,  String? comment,  DateTime? createdAt,  DateTime? startDate,  Team? refereeTeam)?  $default,) {final _that = this;
switch (_that) {
case _Game() when $default != null:
return $default(_that.id,_that.season,_that.homeTeam,_that.awayTeam,_that.homeScore,_that.awayScore,_that.group,_that.refereeAbsent,_that.comment,_that.createdAt,_that.startDate,_that.refereeTeam);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _Game implements Game {
  const _Game({required this.id, this.season, this.homeTeam, this.awayTeam, this.homeScore, this.awayScore, this.group, this.refereeAbsent, this.comment, this.createdAt, this.startDate, this.refereeTeam});
  factory _Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

@override final  int id;
@override final  Season? season;
@override final  Team? homeTeam;
@override final  Team? awayTeam;
@override final  int? homeScore;
@override final  int? awayScore;
@override final  Group? group;
@override final  bool? refereeAbsent;
@override final  String? comment;
@override final  DateTime? createdAt;
@override final  DateTime? startDate;
@override final  Team? refereeTeam;

/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameCopyWith<_Game> get copyWith => __$GameCopyWithImpl<_Game>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Game&&(identical(other.id, id) || other.id == id)&&(identical(other.season, season) || other.season == season)&&(identical(other.homeTeam, homeTeam) || other.homeTeam == homeTeam)&&(identical(other.awayTeam, awayTeam) || other.awayTeam == awayTeam)&&(identical(other.homeScore, homeScore) || other.homeScore == homeScore)&&(identical(other.awayScore, awayScore) || other.awayScore == awayScore)&&(identical(other.group, group) || other.group == group)&&(identical(other.refereeAbsent, refereeAbsent) || other.refereeAbsent == refereeAbsent)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.refereeTeam, refereeTeam) || other.refereeTeam == refereeTeam));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,season,homeTeam,awayTeam,homeScore,awayScore,group,refereeAbsent,comment,createdAt,startDate,refereeTeam);

@override
String toString() {
  return 'Game(id: $id, season: $season, homeTeam: $homeTeam, awayTeam: $awayTeam, homeScore: $homeScore, awayScore: $awayScore, group: $group, refereeAbsent: $refereeAbsent, comment: $comment, createdAt: $createdAt, startDate: $startDate, refereeTeam: $refereeTeam)';
}


}

/// @nodoc
abstract mixin class _$GameCopyWith<$Res> implements $GameCopyWith<$Res> {
  factory _$GameCopyWith(_Game value, $Res Function(_Game) _then) = __$GameCopyWithImpl;
@override @useResult
$Res call({
 int id, Season? season, Team? homeTeam, Team? awayTeam, int? homeScore, int? awayScore, Group? group, bool? refereeAbsent, String? comment, DateTime? createdAt, DateTime? startDate, Team? refereeTeam
});


@override $SeasonCopyWith<$Res>? get season;@override $TeamCopyWith<$Res>? get homeTeam;@override $TeamCopyWith<$Res>? get awayTeam;@override $GroupCopyWith<$Res>? get group;@override $TeamCopyWith<$Res>? get refereeTeam;

}
/// @nodoc
class __$GameCopyWithImpl<$Res>
    implements _$GameCopyWith<$Res> {
  __$GameCopyWithImpl(this._self, this._then);

  final _Game _self;
  final $Res Function(_Game) _then;

/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? season = freezed,Object? homeTeam = freezed,Object? awayTeam = freezed,Object? homeScore = freezed,Object? awayScore = freezed,Object? group = freezed,Object? refereeAbsent = freezed,Object? comment = freezed,Object? createdAt = freezed,Object? startDate = freezed,Object? refereeTeam = freezed,}) {
  return _then(_Game(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,season: freezed == season ? _self.season : season // ignore: cast_nullable_to_non_nullable
as Season?,homeTeam: freezed == homeTeam ? _self.homeTeam : homeTeam // ignore: cast_nullable_to_non_nullable
as Team?,awayTeam: freezed == awayTeam ? _self.awayTeam : awayTeam // ignore: cast_nullable_to_non_nullable
as Team?,homeScore: freezed == homeScore ? _self.homeScore : homeScore // ignore: cast_nullable_to_non_nullable
as int?,awayScore: freezed == awayScore ? _self.awayScore : awayScore // ignore: cast_nullable_to_non_nullable
as int?,group: freezed == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as Group?,refereeAbsent: freezed == refereeAbsent ? _self.refereeAbsent : refereeAbsent // ignore: cast_nullable_to_non_nullable
as bool?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,refereeTeam: freezed == refereeTeam ? _self.refereeTeam : refereeTeam // ignore: cast_nullable_to_non_nullable
as Team?,
  ));
}

/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SeasonCopyWith<$Res>? get season {
    if (_self.season == null) {
    return null;
  }

  return $SeasonCopyWith<$Res>(_self.season!, (value) {
    return _then(_self.copyWith(season: value));
  });
}/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamCopyWith<$Res>? get homeTeam {
    if (_self.homeTeam == null) {
    return null;
  }

  return $TeamCopyWith<$Res>(_self.homeTeam!, (value) {
    return _then(_self.copyWith(homeTeam: value));
  });
}/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamCopyWith<$Res>? get awayTeam {
    if (_self.awayTeam == null) {
    return null;
  }

  return $TeamCopyWith<$Res>(_self.awayTeam!, (value) {
    return _then(_self.copyWith(awayTeam: value));
  });
}/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GroupCopyWith<$Res>? get group {
    if (_self.group == null) {
    return null;
  }

  return $GroupCopyWith<$Res>(_self.group!, (value) {
    return _then(_self.copyWith(group: value));
  });
}/// Create a copy of Game
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TeamCopyWith<$Res>? get refereeTeam {
    if (_self.refereeTeam == null) {
    return null;
  }

  return $TeamCopyWith<$Res>(_self.refereeTeam!, (value) {
    return _then(_self.copyWith(refereeTeam: value));
  });
}
}

// dart format on
