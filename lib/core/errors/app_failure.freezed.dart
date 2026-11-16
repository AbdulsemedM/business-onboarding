// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppFailure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppFailure()';
}


}

/// @nodoc
class $AppFailureCopyWith<$Res>  {
$AppFailureCopyWith(AppFailure _, $Res Function(AppFailure) __);
}


/// Adds pattern-matching-related methods to [AppFailure].
extension AppFailurePatterns on AppFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NetworkFailure value)?  network,TResult Function( TimeoutFailure value)?  timeout,TResult Function( UnauthorizedFailure value)?  unauthorized,TResult Function( ValidationFailure value)?  validation,TResult Function( ServerFailure value)?  server,TResult Function( UnknownFailure value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that);case TimeoutFailure() when timeout != null:
return timeout(_that);case UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that);case ValidationFailure() when validation != null:
return validation(_that);case ServerFailure() when server != null:
return server(_that);case UnknownFailure() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NetworkFailure value)  network,required TResult Function( TimeoutFailure value)  timeout,required TResult Function( UnauthorizedFailure value)  unauthorized,required TResult Function( ValidationFailure value)  validation,required TResult Function( ServerFailure value)  server,required TResult Function( UnknownFailure value)  unknown,}){
final _that = this;
switch (_that) {
case NetworkFailure():
return network(_that);case TimeoutFailure():
return timeout(_that);case UnauthorizedFailure():
return unauthorized(_that);case ValidationFailure():
return validation(_that);case ServerFailure():
return server(_that);case UnknownFailure():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NetworkFailure value)?  network,TResult? Function( TimeoutFailure value)?  timeout,TResult? Function( UnauthorizedFailure value)?  unauthorized,TResult? Function( ValidationFailure value)?  validation,TResult? Function( ServerFailure value)?  server,TResult? Function( UnknownFailure value)?  unknown,}){
final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network(_that);case TimeoutFailure() when timeout != null:
return timeout(_that);case UnauthorizedFailure() when unauthorized != null:
return unauthorized(_that);case ValidationFailure() when validation != null:
return validation(_that);case ServerFailure() when server != null:
return server(_that);case UnknownFailure() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  network,TResult Function()?  timeout,TResult Function()?  unauthorized,TResult Function( List<String> messages)?  validation,TResult Function( int? statusCode)?  server,TResult Function()?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network();case TimeoutFailure() when timeout != null:
return timeout();case UnauthorizedFailure() when unauthorized != null:
return unauthorized();case ValidationFailure() when validation != null:
return validation(_that.messages);case ServerFailure() when server != null:
return server(_that.statusCode);case UnknownFailure() when unknown != null:
return unknown();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  network,required TResult Function()  timeout,required TResult Function()  unauthorized,required TResult Function( List<String> messages)  validation,required TResult Function( int? statusCode)  server,required TResult Function()  unknown,}) {final _that = this;
switch (_that) {
case NetworkFailure():
return network();case TimeoutFailure():
return timeout();case UnauthorizedFailure():
return unauthorized();case ValidationFailure():
return validation(_that.messages);case ServerFailure():
return server(_that.statusCode);case UnknownFailure():
return unknown();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  network,TResult? Function()?  timeout,TResult? Function()?  unauthorized,TResult? Function( List<String> messages)?  validation,TResult? Function( int? statusCode)?  server,TResult? Function()?  unknown,}) {final _that = this;
switch (_that) {
case NetworkFailure() when network != null:
return network();case TimeoutFailure() when timeout != null:
return timeout();case UnauthorizedFailure() when unauthorized != null:
return unauthorized();case ValidationFailure() when validation != null:
return validation(_that.messages);case ServerFailure() when server != null:
return server(_that.statusCode);case UnknownFailure() when unknown != null:
return unknown();case _:
  return null;

}
}

}

/// @nodoc


class NetworkFailure implements AppFailure {
  const NetworkFailure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppFailure.network()';
}


}




/// @nodoc


class TimeoutFailure implements AppFailure {
  const TimeoutFailure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeoutFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppFailure.timeout()';
}


}




/// @nodoc


class UnauthorizedFailure implements AppFailure {
  const UnauthorizedFailure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnauthorizedFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppFailure.unauthorized()';
}


}




/// @nodoc


class ValidationFailure implements AppFailure {
  const ValidationFailure({final  List<String> messages = const <String>[]}): _messages = messages;
  

 final  List<String> _messages;
@JsonKey() List<String> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}


/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidationFailureCopyWith<ValidationFailure> get copyWith => _$ValidationFailureCopyWithImpl<ValidationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidationFailure&&const DeepCollectionEquality().equals(other._messages, _messages));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_messages));

@override
String toString() {
  return 'AppFailure.validation(messages: $messages)';
}


}

/// @nodoc
abstract mixin class $ValidationFailureCopyWith<$Res> implements $AppFailureCopyWith<$Res> {
  factory $ValidationFailureCopyWith(ValidationFailure value, $Res Function(ValidationFailure) _then) = _$ValidationFailureCopyWithImpl;
@useResult
$Res call({
 List<String> messages
});




}
/// @nodoc
class _$ValidationFailureCopyWithImpl<$Res>
    implements $ValidationFailureCopyWith<$Res> {
  _$ValidationFailureCopyWithImpl(this._self, this._then);

  final ValidationFailure _self;
  final $Res Function(ValidationFailure) _then;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? messages = null,}) {
  return _then(ValidationFailure(
messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc


class ServerFailure implements AppFailure {
  const ServerFailure({this.statusCode});
  

 final  int? statusCode;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServerFailureCopyWith<ServerFailure> get copyWith => _$ServerFailureCopyWithImpl<ServerFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServerFailure&&(identical(other.statusCode, statusCode) || other.statusCode == statusCode));
}


@override
int get hashCode => Object.hash(runtimeType,statusCode);

@override
String toString() {
  return 'AppFailure.server(statusCode: $statusCode)';
}


}

/// @nodoc
abstract mixin class $ServerFailureCopyWith<$Res> implements $AppFailureCopyWith<$Res> {
  factory $ServerFailureCopyWith(ServerFailure value, $Res Function(ServerFailure) _then) = _$ServerFailureCopyWithImpl;
@useResult
$Res call({
 int? statusCode
});




}
/// @nodoc
class _$ServerFailureCopyWithImpl<$Res>
    implements $ServerFailureCopyWith<$Res> {
  _$ServerFailureCopyWithImpl(this._self, this._then);

  final ServerFailure _self;
  final $Res Function(ServerFailure) _then;

/// Create a copy of AppFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? statusCode = freezed,}) {
  return _then(ServerFailure(
statusCode: freezed == statusCode ? _self.statusCode : statusCode // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc


class UnknownFailure implements AppFailure {
  const UnknownFailure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AppFailure.unknown()';
}


}




// dart format on
