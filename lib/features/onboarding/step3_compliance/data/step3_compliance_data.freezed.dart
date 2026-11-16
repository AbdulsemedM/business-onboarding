// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'step3_compliance_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionProcessor {

/// Local id used to tell entries apart on the device. Not sent.
 String get id;/// Personal data: never log it.
 String? get firstName; String? get lastName;
/// Create a copy of TransactionProcessor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionProcessorCopyWith<TransactionProcessor> get copyWith => _$TransactionProcessorCopyWithImpl<TransactionProcessor>(this as TransactionProcessor, _$identity);

  /// Serializes this TransactionProcessor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionProcessor&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName);

@override
String toString() {
  return 'TransactionProcessor(id: $id, firstName: $firstName, lastName: $lastName)';
}


}

/// @nodoc
abstract mixin class $TransactionProcessorCopyWith<$Res>  {
  factory $TransactionProcessorCopyWith(TransactionProcessor value, $Res Function(TransactionProcessor) _then) = _$TransactionProcessorCopyWithImpl;
@useResult
$Res call({
 String id, String? firstName, String? lastName
});




}
/// @nodoc
class _$TransactionProcessorCopyWithImpl<$Res>
    implements $TransactionProcessorCopyWith<$Res> {
  _$TransactionProcessorCopyWithImpl(this._self, this._then);

  final TransactionProcessor _self;
  final $Res Function(TransactionProcessor) _then;

/// Create a copy of TransactionProcessor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = freezed,Object? lastName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionProcessor].
extension TransactionProcessorPatterns on TransactionProcessor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionProcessor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionProcessor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionProcessor value)  $default,){
final _that = this;
switch (_that) {
case _TransactionProcessor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionProcessor value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionProcessor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? firstName,  String? lastName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionProcessor() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? firstName,  String? lastName)  $default,) {final _that = this;
switch (_that) {
case _TransactionProcessor():
return $default(_that.id,_that.firstName,_that.lastName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? firstName,  String? lastName)?  $default,) {final _that = this;
switch (_that) {
case _TransactionProcessor() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionProcessor implements TransactionProcessor {
  const _TransactionProcessor({required this.id, this.firstName, this.lastName});
  factory _TransactionProcessor.fromJson(Map<String, dynamic> json) => _$TransactionProcessorFromJson(json);

/// Local id used to tell entries apart on the device. Not sent.
@override final  String id;
/// Personal data: never log it.
@override final  String? firstName;
@override final  String? lastName;

/// Create a copy of TransactionProcessor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionProcessorCopyWith<_TransactionProcessor> get copyWith => __$TransactionProcessorCopyWithImpl<_TransactionProcessor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionProcessorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionProcessor&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName);

@override
String toString() {
  return 'TransactionProcessor(id: $id, firstName: $firstName, lastName: $lastName)';
}


}

/// @nodoc
abstract mixin class _$TransactionProcessorCopyWith<$Res> implements $TransactionProcessorCopyWith<$Res> {
  factory _$TransactionProcessorCopyWith(_TransactionProcessor value, $Res Function(_TransactionProcessor) _then) = __$TransactionProcessorCopyWithImpl;
@override @useResult
$Res call({
 String id, String? firstName, String? lastName
});




}
/// @nodoc
class __$TransactionProcessorCopyWithImpl<$Res>
    implements _$TransactionProcessorCopyWith<$Res> {
  __$TransactionProcessorCopyWithImpl(this._self, this._then);

  final _TransactionProcessor _self;
  final $Res Function(_TransactionProcessor) _then;

/// Create a copy of TransactionProcessor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = freezed,Object? lastName = freezed,}) {
  return _then(_TransactionProcessor(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Step3ComplianceData {

/// At least one.
 List<TransactionProcessor> get processors;/// The Step 1 owner is the Compliance Officer (sent with their
/// `businessOwnerId`).
 bool get complianceOfficerIsOwner;// Kept (but hidden) if the toggle is turned back on.
// TODO(review): leave them out of the submission when the owner is the
// officer, and send the owner instead.
 String? get complianceOfficerFirstName; String? get complianceOfficerLastName;
/// Create a copy of Step3ComplianceData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Step3ComplianceDataCopyWith<Step3ComplianceData> get copyWith => _$Step3ComplianceDataCopyWithImpl<Step3ComplianceData>(this as Step3ComplianceData, _$identity);

  /// Serializes this Step3ComplianceData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Step3ComplianceData&&const DeepCollectionEquality().equals(other.processors, processors)&&(identical(other.complianceOfficerIsOwner, complianceOfficerIsOwner) || other.complianceOfficerIsOwner == complianceOfficerIsOwner)&&(identical(other.complianceOfficerFirstName, complianceOfficerFirstName) || other.complianceOfficerFirstName == complianceOfficerFirstName)&&(identical(other.complianceOfficerLastName, complianceOfficerLastName) || other.complianceOfficerLastName == complianceOfficerLastName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(processors),complianceOfficerIsOwner,complianceOfficerFirstName,complianceOfficerLastName);

@override
String toString() {
  return 'Step3ComplianceData(processors: $processors, complianceOfficerIsOwner: $complianceOfficerIsOwner, complianceOfficerFirstName: $complianceOfficerFirstName, complianceOfficerLastName: $complianceOfficerLastName)';
}


}

/// @nodoc
abstract mixin class $Step3ComplianceDataCopyWith<$Res>  {
  factory $Step3ComplianceDataCopyWith(Step3ComplianceData value, $Res Function(Step3ComplianceData) _then) = _$Step3ComplianceDataCopyWithImpl;
@useResult
$Res call({
 List<TransactionProcessor> processors, bool complianceOfficerIsOwner, String? complianceOfficerFirstName, String? complianceOfficerLastName
});




}
/// @nodoc
class _$Step3ComplianceDataCopyWithImpl<$Res>
    implements $Step3ComplianceDataCopyWith<$Res> {
  _$Step3ComplianceDataCopyWithImpl(this._self, this._then);

  final Step3ComplianceData _self;
  final $Res Function(Step3ComplianceData) _then;

/// Create a copy of Step3ComplianceData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? processors = null,Object? complianceOfficerIsOwner = null,Object? complianceOfficerFirstName = freezed,Object? complianceOfficerLastName = freezed,}) {
  return _then(_self.copyWith(
processors: null == processors ? _self.processors : processors // ignore: cast_nullable_to_non_nullable
as List<TransactionProcessor>,complianceOfficerIsOwner: null == complianceOfficerIsOwner ? _self.complianceOfficerIsOwner : complianceOfficerIsOwner // ignore: cast_nullable_to_non_nullable
as bool,complianceOfficerFirstName: freezed == complianceOfficerFirstName ? _self.complianceOfficerFirstName : complianceOfficerFirstName // ignore: cast_nullable_to_non_nullable
as String?,complianceOfficerLastName: freezed == complianceOfficerLastName ? _self.complianceOfficerLastName : complianceOfficerLastName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Step3ComplianceData].
extension Step3ComplianceDataPatterns on Step3ComplianceData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Step3ComplianceData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Step3ComplianceData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Step3ComplianceData value)  $default,){
final _that = this;
switch (_that) {
case _Step3ComplianceData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Step3ComplianceData value)?  $default,){
final _that = this;
switch (_that) {
case _Step3ComplianceData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TransactionProcessor> processors,  bool complianceOfficerIsOwner,  String? complianceOfficerFirstName,  String? complianceOfficerLastName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Step3ComplianceData() when $default != null:
return $default(_that.processors,_that.complianceOfficerIsOwner,_that.complianceOfficerFirstName,_that.complianceOfficerLastName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TransactionProcessor> processors,  bool complianceOfficerIsOwner,  String? complianceOfficerFirstName,  String? complianceOfficerLastName)  $default,) {final _that = this;
switch (_that) {
case _Step3ComplianceData():
return $default(_that.processors,_that.complianceOfficerIsOwner,_that.complianceOfficerFirstName,_that.complianceOfficerLastName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TransactionProcessor> processors,  bool complianceOfficerIsOwner,  String? complianceOfficerFirstName,  String? complianceOfficerLastName)?  $default,) {final _that = this;
switch (_that) {
case _Step3ComplianceData() when $default != null:
return $default(_that.processors,_that.complianceOfficerIsOwner,_that.complianceOfficerFirstName,_that.complianceOfficerLastName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Step3ComplianceData extends Step3ComplianceData {
  const _Step3ComplianceData({final  List<TransactionProcessor> processors = const [TransactionProcessor(id: Step3ComplianceData.firstProcessorId)], this.complianceOfficerIsOwner = true, this.complianceOfficerFirstName, this.complianceOfficerLastName}): _processors = processors,super._();
  factory _Step3ComplianceData.fromJson(Map<String, dynamic> json) => _$Step3ComplianceDataFromJson(json);

/// At least one.
 final  List<TransactionProcessor> _processors;
/// At least one.
@override@JsonKey() List<TransactionProcessor> get processors {
  if (_processors is EqualUnmodifiableListView) return _processors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_processors);
}

/// The Step 1 owner is the Compliance Officer (sent with their
/// `businessOwnerId`).
@override@JsonKey() final  bool complianceOfficerIsOwner;
// Kept (but hidden) if the toggle is turned back on.
// TODO(review): leave them out of the submission when the owner is the
// officer, and send the owner instead.
@override final  String? complianceOfficerFirstName;
@override final  String? complianceOfficerLastName;

/// Create a copy of Step3ComplianceData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$Step3ComplianceDataCopyWith<_Step3ComplianceData> get copyWith => __$Step3ComplianceDataCopyWithImpl<_Step3ComplianceData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$Step3ComplianceDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Step3ComplianceData&&const DeepCollectionEquality().equals(other._processors, _processors)&&(identical(other.complianceOfficerIsOwner, complianceOfficerIsOwner) || other.complianceOfficerIsOwner == complianceOfficerIsOwner)&&(identical(other.complianceOfficerFirstName, complianceOfficerFirstName) || other.complianceOfficerFirstName == complianceOfficerFirstName)&&(identical(other.complianceOfficerLastName, complianceOfficerLastName) || other.complianceOfficerLastName == complianceOfficerLastName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_processors),complianceOfficerIsOwner,complianceOfficerFirstName,complianceOfficerLastName);

@override
String toString() {
  return 'Step3ComplianceData(processors: $processors, complianceOfficerIsOwner: $complianceOfficerIsOwner, complianceOfficerFirstName: $complianceOfficerFirstName, complianceOfficerLastName: $complianceOfficerLastName)';
}


}

/// @nodoc
abstract mixin class _$Step3ComplianceDataCopyWith<$Res> implements $Step3ComplianceDataCopyWith<$Res> {
  factory _$Step3ComplianceDataCopyWith(_Step3ComplianceData value, $Res Function(_Step3ComplianceData) _then) = __$Step3ComplianceDataCopyWithImpl;
@override @useResult
$Res call({
 List<TransactionProcessor> processors, bool complianceOfficerIsOwner, String? complianceOfficerFirstName, String? complianceOfficerLastName
});




}
/// @nodoc
class __$Step3ComplianceDataCopyWithImpl<$Res>
    implements _$Step3ComplianceDataCopyWith<$Res> {
  __$Step3ComplianceDataCopyWithImpl(this._self, this._then);

  final _Step3ComplianceData _self;
  final $Res Function(_Step3ComplianceData) _then;

/// Create a copy of Step3ComplianceData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? processors = null,Object? complianceOfficerIsOwner = null,Object? complianceOfficerFirstName = freezed,Object? complianceOfficerLastName = freezed,}) {
  return _then(_Step3ComplianceData(
processors: null == processors ? _self._processors : processors // ignore: cast_nullable_to_non_nullable
as List<TransactionProcessor>,complianceOfficerIsOwner: null == complianceOfficerIsOwner ? _self.complianceOfficerIsOwner : complianceOfficerIsOwner // ignore: cast_nullable_to_non_nullable
as bool,complianceOfficerFirstName: freezed == complianceOfficerFirstName ? _self.complianceOfficerFirstName : complianceOfficerFirstName // ignore: cast_nullable_to_non_nullable
as String?,complianceOfficerLastName: freezed == complianceOfficerLastName ? _self.complianceOfficerLastName : complianceOfficerLastName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
