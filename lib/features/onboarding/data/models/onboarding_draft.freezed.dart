// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnboardingDraft {

 int get schemaVersion; OnboardingStep get currentStep; Step1BusinessData get business; Step2DocumentsData get documents; Step3ComplianceData get compliance;/// Sent for review at least once. The app then opens on the status
/// screen. The server's status is the source of truth; this only routes.
 bool get submitted;
/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingDraftCopyWith<OnboardingDraft> get copyWith => _$OnboardingDraftCopyWithImpl<OnboardingDraft>(this as OnboardingDraft, _$identity);

  /// Serializes this OnboardingDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingDraft&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.business, business) || other.business == business)&&(identical(other.documents, documents) || other.documents == documents)&&(identical(other.compliance, compliance) || other.compliance == compliance)&&(identical(other.submitted, submitted) || other.submitted == submitted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,currentStep,business,documents,compliance,submitted);

@override
String toString() {
  return 'OnboardingDraft(schemaVersion: $schemaVersion, currentStep: $currentStep, business: $business, documents: $documents, compliance: $compliance, submitted: $submitted)';
}


}

/// @nodoc
abstract mixin class $OnboardingDraftCopyWith<$Res>  {
  factory $OnboardingDraftCopyWith(OnboardingDraft value, $Res Function(OnboardingDraft) _then) = _$OnboardingDraftCopyWithImpl;
@useResult
$Res call({
 int schemaVersion, OnboardingStep currentStep, Step1BusinessData business, Step2DocumentsData documents, Step3ComplianceData compliance, bool submitted
});


$Step1BusinessDataCopyWith<$Res> get business;$Step2DocumentsDataCopyWith<$Res> get documents;$Step3ComplianceDataCopyWith<$Res> get compliance;

}
/// @nodoc
class _$OnboardingDraftCopyWithImpl<$Res>
    implements $OnboardingDraftCopyWith<$Res> {
  _$OnboardingDraftCopyWithImpl(this._self, this._then);

  final OnboardingDraft _self;
  final $Res Function(OnboardingDraft) _then;

/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schemaVersion = null,Object? currentStep = null,Object? business = null,Object? documents = null,Object? compliance = null,Object? submitted = null,}) {
  return _then(_self.copyWith(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as OnboardingStep,business: null == business ? _self.business : business // ignore: cast_nullable_to_non_nullable
as Step1BusinessData,documents: null == documents ? _self.documents : documents // ignore: cast_nullable_to_non_nullable
as Step2DocumentsData,compliance: null == compliance ? _self.compliance : compliance // ignore: cast_nullable_to_non_nullable
as Step3ComplianceData,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$Step1BusinessDataCopyWith<$Res> get business {
  
  return $Step1BusinessDataCopyWith<$Res>(_self.business, (value) {
    return _then(_self.copyWith(business: value));
  });
}/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$Step2DocumentsDataCopyWith<$Res> get documents {
  
  return $Step2DocumentsDataCopyWith<$Res>(_self.documents, (value) {
    return _then(_self.copyWith(documents: value));
  });
}/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$Step3ComplianceDataCopyWith<$Res> get compliance {
  
  return $Step3ComplianceDataCopyWith<$Res>(_self.compliance, (value) {
    return _then(_self.copyWith(compliance: value));
  });
}
}


/// Adds pattern-matching-related methods to [OnboardingDraft].
extension OnboardingDraftPatterns on OnboardingDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingDraft value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingDraft value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int schemaVersion,  OnboardingStep currentStep,  Step1BusinessData business,  Step2DocumentsData documents,  Step3ComplianceData compliance,  bool submitted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingDraft() when $default != null:
return $default(_that.schemaVersion,_that.currentStep,_that.business,_that.documents,_that.compliance,_that.submitted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int schemaVersion,  OnboardingStep currentStep,  Step1BusinessData business,  Step2DocumentsData documents,  Step3ComplianceData compliance,  bool submitted)  $default,) {final _that = this;
switch (_that) {
case _OnboardingDraft():
return $default(_that.schemaVersion,_that.currentStep,_that.business,_that.documents,_that.compliance,_that.submitted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int schemaVersion,  OnboardingStep currentStep,  Step1BusinessData business,  Step2DocumentsData documents,  Step3ComplianceData compliance,  bool submitted)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingDraft() when $default != null:
return $default(_that.schemaVersion,_that.currentStep,_that.business,_that.documents,_that.compliance,_that.submitted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingDraft implements OnboardingDraft {
  const _OnboardingDraft({this.schemaVersion = OnboardingDraft.currentSchemaVersion, this.currentStep = OnboardingStep.business, this.business = const Step1BusinessData(), this.documents = const Step2DocumentsData(), this.compliance = const Step3ComplianceData(), this.submitted = false});
  factory _OnboardingDraft.fromJson(Map<String, dynamic> json) => _$OnboardingDraftFromJson(json);

@override@JsonKey() final  int schemaVersion;
@override@JsonKey() final  OnboardingStep currentStep;
@override@JsonKey() final  Step1BusinessData business;
@override@JsonKey() final  Step2DocumentsData documents;
@override@JsonKey() final  Step3ComplianceData compliance;
/// Sent for review at least once. The app then opens on the status
/// screen. The server's status is the source of truth; this only routes.
@override@JsonKey() final  bool submitted;

/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingDraftCopyWith<_OnboardingDraft> get copyWith => __$OnboardingDraftCopyWithImpl<_OnboardingDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingDraftToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingDraft&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.currentStep, currentStep) || other.currentStep == currentStep)&&(identical(other.business, business) || other.business == business)&&(identical(other.documents, documents) || other.documents == documents)&&(identical(other.compliance, compliance) || other.compliance == compliance)&&(identical(other.submitted, submitted) || other.submitted == submitted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,schemaVersion,currentStep,business,documents,compliance,submitted);

@override
String toString() {
  return 'OnboardingDraft(schemaVersion: $schemaVersion, currentStep: $currentStep, business: $business, documents: $documents, compliance: $compliance, submitted: $submitted)';
}


}

/// @nodoc
abstract mixin class _$OnboardingDraftCopyWith<$Res> implements $OnboardingDraftCopyWith<$Res> {
  factory _$OnboardingDraftCopyWith(_OnboardingDraft value, $Res Function(_OnboardingDraft) _then) = __$OnboardingDraftCopyWithImpl;
@override @useResult
$Res call({
 int schemaVersion, OnboardingStep currentStep, Step1BusinessData business, Step2DocumentsData documents, Step3ComplianceData compliance, bool submitted
});


@override $Step1BusinessDataCopyWith<$Res> get business;@override $Step2DocumentsDataCopyWith<$Res> get documents;@override $Step3ComplianceDataCopyWith<$Res> get compliance;

}
/// @nodoc
class __$OnboardingDraftCopyWithImpl<$Res>
    implements _$OnboardingDraftCopyWith<$Res> {
  __$OnboardingDraftCopyWithImpl(this._self, this._then);

  final _OnboardingDraft _self;
  final $Res Function(_OnboardingDraft) _then;

/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schemaVersion = null,Object? currentStep = null,Object? business = null,Object? documents = null,Object? compliance = null,Object? submitted = null,}) {
  return _then(_OnboardingDraft(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,currentStep: null == currentStep ? _self.currentStep : currentStep // ignore: cast_nullable_to_non_nullable
as OnboardingStep,business: null == business ? _self.business : business // ignore: cast_nullable_to_non_nullable
as Step1BusinessData,documents: null == documents ? _self.documents : documents // ignore: cast_nullable_to_non_nullable
as Step2DocumentsData,compliance: null == compliance ? _self.compliance : compliance // ignore: cast_nullable_to_non_nullable
as Step3ComplianceData,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$Step1BusinessDataCopyWith<$Res> get business {
  
  return $Step1BusinessDataCopyWith<$Res>(_self.business, (value) {
    return _then(_self.copyWith(business: value));
  });
}/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$Step2DocumentsDataCopyWith<$Res> get documents {
  
  return $Step2DocumentsDataCopyWith<$Res>(_self.documents, (value) {
    return _then(_self.copyWith(documents: value));
  });
}/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$Step3ComplianceDataCopyWith<$Res> get compliance {
  
  return $Step3ComplianceDataCopyWith<$Res>(_self.compliance, (value) {
    return _then(_self.copyWith(compliance: value));
  });
}
}

// dart format on
