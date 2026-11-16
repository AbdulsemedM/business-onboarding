// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CorrectionItem {

/// Backend `correctionItemId`, sent back on resubmit.
 String get id;/// What needs fixing, e.g. "Exterior photo". From the server.
 String get label;/// Why, e.g. "Business name is not visible". From the server.
 String get reason;/// Set when a document must be uploaded again: the backend document
/// type code to upload it as.
 String? get documentType;/// Set when a form field must be changed: the step that has it.
 OnboardingStep? get step;
/// Create a copy of CorrectionItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CorrectionItemCopyWith<CorrectionItem> get copyWith => _$CorrectionItemCopyWithImpl<CorrectionItem>(this as CorrectionItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CorrectionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.step, step) || other.step == step));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,reason,documentType,step);

@override
String toString() {
  return 'CorrectionItem(id: $id, label: $label, reason: $reason, documentType: $documentType, step: $step)';
}


}

/// @nodoc
abstract mixin class $CorrectionItemCopyWith<$Res>  {
  factory $CorrectionItemCopyWith(CorrectionItem value, $Res Function(CorrectionItem) _then) = _$CorrectionItemCopyWithImpl;
@useResult
$Res call({
 String id, String label, String reason, String? documentType, OnboardingStep? step
});




}
/// @nodoc
class _$CorrectionItemCopyWithImpl<$Res>
    implements $CorrectionItemCopyWith<$Res> {
  _$CorrectionItemCopyWithImpl(this._self, this._then);

  final CorrectionItem _self;
  final $Res Function(CorrectionItem) _then;

/// Create a copy of CorrectionItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? label = null,Object? reason = null,Object? documentType = freezed,Object? step = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,documentType: freezed == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as String?,step: freezed == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as OnboardingStep?,
  ));
}

}


/// Adds pattern-matching-related methods to [CorrectionItem].
extension CorrectionItemPatterns on CorrectionItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CorrectionItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CorrectionItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CorrectionItem value)  $default,){
final _that = this;
switch (_that) {
case _CorrectionItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CorrectionItem value)?  $default,){
final _that = this;
switch (_that) {
case _CorrectionItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String label,  String reason,  String? documentType,  OnboardingStep? step)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CorrectionItem() when $default != null:
return $default(_that.id,_that.label,_that.reason,_that.documentType,_that.step);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String label,  String reason,  String? documentType,  OnboardingStep? step)  $default,) {final _that = this;
switch (_that) {
case _CorrectionItem():
return $default(_that.id,_that.label,_that.reason,_that.documentType,_that.step);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String label,  String reason,  String? documentType,  OnboardingStep? step)?  $default,) {final _that = this;
switch (_that) {
case _CorrectionItem() when $default != null:
return $default(_that.id,_that.label,_that.reason,_that.documentType,_that.step);case _:
  return null;

}
}

}

/// @nodoc


class _CorrectionItem extends CorrectionItem {
  const _CorrectionItem({required this.id, required this.label, required this.reason, this.documentType, this.step}): super._();
  

/// Backend `correctionItemId`, sent back on resubmit.
@override final  String id;
/// What needs fixing, e.g. "Exterior photo". From the server.
@override final  String label;
/// Why, e.g. "Business name is not visible". From the server.
@override final  String reason;
/// Set when a document must be uploaded again: the backend document
/// type code to upload it as.
@override final  String? documentType;
/// Set when a form field must be changed: the step that has it.
@override final  OnboardingStep? step;

/// Create a copy of CorrectionItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CorrectionItemCopyWith<_CorrectionItem> get copyWith => __$CorrectionItemCopyWithImpl<_CorrectionItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CorrectionItem&&(identical(other.id, id) || other.id == id)&&(identical(other.label, label) || other.label == label)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.documentType, documentType) || other.documentType == documentType)&&(identical(other.step, step) || other.step == step));
}


@override
int get hashCode => Object.hash(runtimeType,id,label,reason,documentType,step);

@override
String toString() {
  return 'CorrectionItem(id: $id, label: $label, reason: $reason, documentType: $documentType, step: $step)';
}


}

/// @nodoc
abstract mixin class _$CorrectionItemCopyWith<$Res> implements $CorrectionItemCopyWith<$Res> {
  factory _$CorrectionItemCopyWith(_CorrectionItem value, $Res Function(_CorrectionItem) _then) = __$CorrectionItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String label, String reason, String? documentType, OnboardingStep? step
});




}
/// @nodoc
class __$CorrectionItemCopyWithImpl<$Res>
    implements _$CorrectionItemCopyWith<$Res> {
  __$CorrectionItemCopyWithImpl(this._self, this._then);

  final _CorrectionItem _self;
  final $Res Function(_CorrectionItem) _then;

/// Create a copy of CorrectionItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? label = null,Object? reason = null,Object? documentType = freezed,Object? step = freezed,}) {
  return _then(_CorrectionItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,documentType: freezed == documentType ? _self.documentType : documentType // ignore: cast_nullable_to_non_nullable
as String?,step: freezed == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as OnboardingStep?,
  ));
}


}

/// @nodoc
mixin _$ApplicationSnapshot {

 ApplicationStatus get status; String? get applicationNumber; DateTime? get submittedAt; List<CorrectionItem> get corrections;
/// Create a copy of ApplicationSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplicationSnapshotCopyWith<ApplicationSnapshot> get copyWith => _$ApplicationSnapshotCopyWithImpl<ApplicationSnapshot>(this as ApplicationSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplicationSnapshot&&(identical(other.status, status) || other.status == status)&&(identical(other.applicationNumber, applicationNumber) || other.applicationNumber == applicationNumber)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&const DeepCollectionEquality().equals(other.corrections, corrections));
}


@override
int get hashCode => Object.hash(runtimeType,status,applicationNumber,submittedAt,const DeepCollectionEquality().hash(corrections));

@override
String toString() {
  return 'ApplicationSnapshot(status: $status, applicationNumber: $applicationNumber, submittedAt: $submittedAt, corrections: $corrections)';
}


}

/// @nodoc
abstract mixin class $ApplicationSnapshotCopyWith<$Res>  {
  factory $ApplicationSnapshotCopyWith(ApplicationSnapshot value, $Res Function(ApplicationSnapshot) _then) = _$ApplicationSnapshotCopyWithImpl;
@useResult
$Res call({
 ApplicationStatus status, String? applicationNumber, DateTime? submittedAt, List<CorrectionItem> corrections
});




}
/// @nodoc
class _$ApplicationSnapshotCopyWithImpl<$Res>
    implements $ApplicationSnapshotCopyWith<$Res> {
  _$ApplicationSnapshotCopyWithImpl(this._self, this._then);

  final ApplicationSnapshot _self;
  final $Res Function(ApplicationSnapshot) _then;

/// Create a copy of ApplicationSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? applicationNumber = freezed,Object? submittedAt = freezed,Object? corrections = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ApplicationStatus,applicationNumber: freezed == applicationNumber ? _self.applicationNumber : applicationNumber // ignore: cast_nullable_to_non_nullable
as String?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,corrections: null == corrections ? _self.corrections : corrections // ignore: cast_nullable_to_non_nullable
as List<CorrectionItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [ApplicationSnapshot].
extension ApplicationSnapshotPatterns on ApplicationSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApplicationSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApplicationSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApplicationSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _ApplicationSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApplicationSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _ApplicationSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ApplicationStatus status,  String? applicationNumber,  DateTime? submittedAt,  List<CorrectionItem> corrections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApplicationSnapshot() when $default != null:
return $default(_that.status,_that.applicationNumber,_that.submittedAt,_that.corrections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ApplicationStatus status,  String? applicationNumber,  DateTime? submittedAt,  List<CorrectionItem> corrections)  $default,) {final _that = this;
switch (_that) {
case _ApplicationSnapshot():
return $default(_that.status,_that.applicationNumber,_that.submittedAt,_that.corrections);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ApplicationStatus status,  String? applicationNumber,  DateTime? submittedAt,  List<CorrectionItem> corrections)?  $default,) {final _that = this;
switch (_that) {
case _ApplicationSnapshot() when $default != null:
return $default(_that.status,_that.applicationNumber,_that.submittedAt,_that.corrections);case _:
  return null;

}
}

}

/// @nodoc


class _ApplicationSnapshot implements ApplicationSnapshot {
  const _ApplicationSnapshot({required this.status, this.applicationNumber, this.submittedAt, final  List<CorrectionItem> corrections = const <CorrectionItem>[]}): _corrections = corrections;
  

@override final  ApplicationStatus status;
@override final  String? applicationNumber;
@override final  DateTime? submittedAt;
 final  List<CorrectionItem> _corrections;
@override@JsonKey() List<CorrectionItem> get corrections {
  if (_corrections is EqualUnmodifiableListView) return _corrections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_corrections);
}


/// Create a copy of ApplicationSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApplicationSnapshotCopyWith<_ApplicationSnapshot> get copyWith => __$ApplicationSnapshotCopyWithImpl<_ApplicationSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApplicationSnapshot&&(identical(other.status, status) || other.status == status)&&(identical(other.applicationNumber, applicationNumber) || other.applicationNumber == applicationNumber)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&const DeepCollectionEquality().equals(other._corrections, _corrections));
}


@override
int get hashCode => Object.hash(runtimeType,status,applicationNumber,submittedAt,const DeepCollectionEquality().hash(_corrections));

@override
String toString() {
  return 'ApplicationSnapshot(status: $status, applicationNumber: $applicationNumber, submittedAt: $submittedAt, corrections: $corrections)';
}


}

/// @nodoc
abstract mixin class _$ApplicationSnapshotCopyWith<$Res> implements $ApplicationSnapshotCopyWith<$Res> {
  factory _$ApplicationSnapshotCopyWith(_ApplicationSnapshot value, $Res Function(_ApplicationSnapshot) _then) = __$ApplicationSnapshotCopyWithImpl;
@override @useResult
$Res call({
 ApplicationStatus status, String? applicationNumber, DateTime? submittedAt, List<CorrectionItem> corrections
});




}
/// @nodoc
class __$ApplicationSnapshotCopyWithImpl<$Res>
    implements _$ApplicationSnapshotCopyWith<$Res> {
  __$ApplicationSnapshotCopyWithImpl(this._self, this._then);

  final _ApplicationSnapshot _self;
  final $Res Function(_ApplicationSnapshot) _then;

/// Create a copy of ApplicationSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? applicationNumber = freezed,Object? submittedAt = freezed,Object? corrections = null,}) {
  return _then(_ApplicationSnapshot(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ApplicationStatus,applicationNumber: freezed == applicationNumber ? _self.applicationNumber : applicationNumber // ignore: cast_nullable_to_non_nullable
as String?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,corrections: null == corrections ? _self._corrections : corrections // ignore: cast_nullable_to_non_nullable
as List<CorrectionItem>,
  ));
}


}

// dart format on
