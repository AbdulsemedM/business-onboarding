// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'status_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StatusState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StatusState()';
}


}

/// @nodoc
class $StatusStateCopyWith<$Res>  {
$StatusStateCopyWith(StatusState _, $Res Function(StatusState) __);
}


/// Adds pattern-matching-related methods to [StatusState].
extension StatusStatePatterns on StatusState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StatusLoading value)?  loading,TResult Function( StatusLoaded value)?  loaded,TResult Function( StatusFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StatusLoading() when loading != null:
return loading(_that);case StatusLoaded() when loaded != null:
return loaded(_that);case StatusFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StatusLoading value)  loading,required TResult Function( StatusLoaded value)  loaded,required TResult Function( StatusFailed value)  failed,}){
final _that = this;
switch (_that) {
case StatusLoading():
return loading(_that);case StatusLoaded():
return loaded(_that);case StatusFailed():
return failed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StatusLoading value)?  loading,TResult? Function( StatusLoaded value)?  loaded,TResult? Function( StatusFailed value)?  failed,}){
final _that = this;
switch (_that) {
case StatusLoading() when loading != null:
return loading(_that);case StatusLoaded() when loaded != null:
return loaded(_that);case StatusFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( ApplicationSnapshot snapshot,  Set<String> reuploaded,  bool isResubmitting,  AppFailure? resubmitFailure)?  loaded,TResult Function( AppFailure failure)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StatusLoading() when loading != null:
return loading();case StatusLoaded() when loaded != null:
return loaded(_that.snapshot,_that.reuploaded,_that.isResubmitting,_that.resubmitFailure);case StatusFailed() when failed != null:
return failed(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( ApplicationSnapshot snapshot,  Set<String> reuploaded,  bool isResubmitting,  AppFailure? resubmitFailure)  loaded,required TResult Function( AppFailure failure)  failed,}) {final _that = this;
switch (_that) {
case StatusLoading():
return loading();case StatusLoaded():
return loaded(_that.snapshot,_that.reuploaded,_that.isResubmitting,_that.resubmitFailure);case StatusFailed():
return failed(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( ApplicationSnapshot snapshot,  Set<String> reuploaded,  bool isResubmitting,  AppFailure? resubmitFailure)?  loaded,TResult? Function( AppFailure failure)?  failed,}) {final _that = this;
switch (_that) {
case StatusLoading() when loading != null:
return loading();case StatusLoaded() when loaded != null:
return loaded(_that.snapshot,_that.reuploaded,_that.isResubmitting,_that.resubmitFailure);case StatusFailed() when failed != null:
return failed(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class StatusLoading implements StatusState {
  const StatusLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'StatusState.loading()';
}


}




/// @nodoc


class StatusLoaded implements StatusState {
  const StatusLoaded({required this.snapshot, final  Set<String> reuploaded = const <String>{}, this.isResubmitting = false, this.resubmitFailure}): _reuploaded = reuploaded;
  

 final  ApplicationSnapshot snapshot;
 final  Set<String> _reuploaded;
@JsonKey() Set<String> get reuploaded {
  if (_reuploaded is EqualUnmodifiableSetView) return _reuploaded;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_reuploaded);
}

@JsonKey() final  bool isResubmitting;
 final  AppFailure? resubmitFailure;

/// Create a copy of StatusState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatusLoadedCopyWith<StatusLoaded> get copyWith => _$StatusLoadedCopyWithImpl<StatusLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusLoaded&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot)&&const DeepCollectionEquality().equals(other._reuploaded, _reuploaded)&&(identical(other.isResubmitting, isResubmitting) || other.isResubmitting == isResubmitting)&&(identical(other.resubmitFailure, resubmitFailure) || other.resubmitFailure == resubmitFailure));
}


@override
int get hashCode => Object.hash(runtimeType,snapshot,const DeepCollectionEquality().hash(_reuploaded),isResubmitting,resubmitFailure);

@override
String toString() {
  return 'StatusState.loaded(snapshot: $snapshot, reuploaded: $reuploaded, isResubmitting: $isResubmitting, resubmitFailure: $resubmitFailure)';
}


}

/// @nodoc
abstract mixin class $StatusLoadedCopyWith<$Res> implements $StatusStateCopyWith<$Res> {
  factory $StatusLoadedCopyWith(StatusLoaded value, $Res Function(StatusLoaded) _then) = _$StatusLoadedCopyWithImpl;
@useResult
$Res call({
 ApplicationSnapshot snapshot, Set<String> reuploaded, bool isResubmitting, AppFailure? resubmitFailure
});


$ApplicationSnapshotCopyWith<$Res> get snapshot;$AppFailureCopyWith<$Res>? get resubmitFailure;

}
/// @nodoc
class _$StatusLoadedCopyWithImpl<$Res>
    implements $StatusLoadedCopyWith<$Res> {
  _$StatusLoadedCopyWithImpl(this._self, this._then);

  final StatusLoaded _self;
  final $Res Function(StatusLoaded) _then;

/// Create a copy of StatusState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? snapshot = null,Object? reuploaded = null,Object? isResubmitting = null,Object? resubmitFailure = freezed,}) {
  return _then(StatusLoaded(
snapshot: null == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as ApplicationSnapshot,reuploaded: null == reuploaded ? _self._reuploaded : reuploaded // ignore: cast_nullable_to_non_nullable
as Set<String>,isResubmitting: null == isResubmitting ? _self.isResubmitting : isResubmitting // ignore: cast_nullable_to_non_nullable
as bool,resubmitFailure: freezed == resubmitFailure ? _self.resubmitFailure : resubmitFailure // ignore: cast_nullable_to_non_nullable
as AppFailure?,
  ));
}

/// Create a copy of StatusState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApplicationSnapshotCopyWith<$Res> get snapshot {
  
  return $ApplicationSnapshotCopyWith<$Res>(_self.snapshot, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}/// Create a copy of StatusState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppFailureCopyWith<$Res>? get resubmitFailure {
    if (_self.resubmitFailure == null) {
    return null;
  }

  return $AppFailureCopyWith<$Res>(_self.resubmitFailure!, (value) {
    return _then(_self.copyWith(resubmitFailure: value));
  });
}
}

/// @nodoc


class StatusFailed implements StatusState {
  const StatusFailed(this.failure);
  

 final  AppFailure failure;

/// Create a copy of StatusState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatusFailedCopyWith<StatusFailed> get copyWith => _$StatusFailedCopyWithImpl<StatusFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatusFailed&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'StatusState.failed(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $StatusFailedCopyWith<$Res> implements $StatusStateCopyWith<$Res> {
  factory $StatusFailedCopyWith(StatusFailed value, $Res Function(StatusFailed) _then) = _$StatusFailedCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$StatusFailedCopyWithImpl<$Res>
    implements $StatusFailedCopyWith<$Res> {
  _$StatusFailedCopyWithImpl(this._self, this._then);

  final StatusFailed _self;
  final $Res Function(StatusFailed) _then;

/// Create a copy of StatusState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(StatusFailed(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of StatusState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppFailureCopyWith<$Res> get failure {
  
  return $AppFailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
