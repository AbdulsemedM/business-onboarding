// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submit_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubmitState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubmitState()';
}


}

/// @nodoc
class $SubmitStateCopyWith<$Res>  {
$SubmitStateCopyWith(SubmitState _, $Res Function(SubmitState) __);
}


/// Adds pattern-matching-related methods to [SubmitState].
extension SubmitStatePatterns on SubmitState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SubmitIdle value)?  idle,TResult Function( SubmitInProgress value)?  submitting,TResult Function( SubmitSucceeded value)?  succeeded,TResult Function( SubmitFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SubmitIdle() when idle != null:
return idle(_that);case SubmitInProgress() when submitting != null:
return submitting(_that);case SubmitSucceeded() when succeeded != null:
return succeeded(_that);case SubmitFailed() when failed != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SubmitIdle value)  idle,required TResult Function( SubmitInProgress value)  submitting,required TResult Function( SubmitSucceeded value)  succeeded,required TResult Function( SubmitFailed value)  failed,}){
final _that = this;
switch (_that) {
case SubmitIdle():
return idle(_that);case SubmitInProgress():
return submitting(_that);case SubmitSucceeded():
return succeeded(_that);case SubmitFailed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SubmitIdle value)?  idle,TResult? Function( SubmitInProgress value)?  submitting,TResult? Function( SubmitSucceeded value)?  succeeded,TResult? Function( SubmitFailed value)?  failed,}){
final _that = this;
switch (_that) {
case SubmitIdle() when idle != null:
return idle(_that);case SubmitInProgress() when submitting != null:
return submitting(_that);case SubmitSucceeded() when succeeded != null:
return succeeded(_that);case SubmitFailed() when failed != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  submitting,TResult Function( ApplicationSnapshot snapshot)?  succeeded,TResult Function( AppFailure failure)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SubmitIdle() when idle != null:
return idle();case SubmitInProgress() when submitting != null:
return submitting();case SubmitSucceeded() when succeeded != null:
return succeeded(_that.snapshot);case SubmitFailed() when failed != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  submitting,required TResult Function( ApplicationSnapshot snapshot)  succeeded,required TResult Function( AppFailure failure)  failed,}) {final _that = this;
switch (_that) {
case SubmitIdle():
return idle();case SubmitInProgress():
return submitting();case SubmitSucceeded():
return succeeded(_that.snapshot);case SubmitFailed():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  submitting,TResult? Function( ApplicationSnapshot snapshot)?  succeeded,TResult? Function( AppFailure failure)?  failed,}) {final _that = this;
switch (_that) {
case SubmitIdle() when idle != null:
return idle();case SubmitInProgress() when submitting != null:
return submitting();case SubmitSucceeded() when succeeded != null:
return succeeded(_that.snapshot);case SubmitFailed() when failed != null:
return failed(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class SubmitIdle implements SubmitState {
  const SubmitIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubmitState.idle()';
}


}




/// @nodoc


class SubmitInProgress implements SubmitState {
  const SubmitInProgress();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitInProgress);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubmitState.submitting()';
}


}




/// @nodoc


class SubmitSucceeded implements SubmitState {
  const SubmitSucceeded(this.snapshot);
  

 final  ApplicationSnapshot snapshot;

/// Create a copy of SubmitState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmitSucceededCopyWith<SubmitSucceeded> get copyWith => _$SubmitSucceededCopyWithImpl<SubmitSucceeded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitSucceeded&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot));
}


@override
int get hashCode => Object.hash(runtimeType,snapshot);

@override
String toString() {
  return 'SubmitState.succeeded(snapshot: $snapshot)';
}


}

/// @nodoc
abstract mixin class $SubmitSucceededCopyWith<$Res> implements $SubmitStateCopyWith<$Res> {
  factory $SubmitSucceededCopyWith(SubmitSucceeded value, $Res Function(SubmitSucceeded) _then) = _$SubmitSucceededCopyWithImpl;
@useResult
$Res call({
 ApplicationSnapshot snapshot
});


$ApplicationSnapshotCopyWith<$Res> get snapshot;

}
/// @nodoc
class _$SubmitSucceededCopyWithImpl<$Res>
    implements $SubmitSucceededCopyWith<$Res> {
  _$SubmitSucceededCopyWithImpl(this._self, this._then);

  final SubmitSucceeded _self;
  final $Res Function(SubmitSucceeded) _then;

/// Create a copy of SubmitState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? snapshot = null,}) {
  return _then(SubmitSucceeded(
null == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as ApplicationSnapshot,
  ));
}

/// Create a copy of SubmitState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApplicationSnapshotCopyWith<$Res> get snapshot {
  
  return $ApplicationSnapshotCopyWith<$Res>(_self.snapshot, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}
}

/// @nodoc


class SubmitFailed implements SubmitState {
  const SubmitFailed(this.failure);
  

 final  AppFailure failure;

/// Create a copy of SubmitState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmitFailedCopyWith<SubmitFailed> get copyWith => _$SubmitFailedCopyWithImpl<SubmitFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitFailed&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'SubmitState.failed(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SubmitFailedCopyWith<$Res> implements $SubmitStateCopyWith<$Res> {
  factory $SubmitFailedCopyWith(SubmitFailed value, $Res Function(SubmitFailed) _then) = _$SubmitFailedCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$SubmitFailedCopyWithImpl<$Res>
    implements $SubmitFailedCopyWith<$Res> {
  _$SubmitFailedCopyWithImpl(this._self, this._then);

  final SubmitFailed _self;
  final $Res Function(SubmitFailed) _then;

/// Create a copy of SubmitState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(SubmitFailed(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of SubmitState
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
