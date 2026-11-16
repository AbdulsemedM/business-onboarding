// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DocumentError {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentError()';
}


}

/// @nodoc
class $DocumentErrorCopyWith<$Res>  {
$DocumentErrorCopyWith(DocumentError _, $Res Function(DocumentError) __);
}


/// Adds pattern-matching-related methods to [DocumentError].
extension DocumentErrorPatterns on DocumentError {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DocumentTooLarge value)?  tooLarge,TResult Function( DocumentUnsupportedType value)?  unsupportedType,TResult Function( DocumentUnreadable value)?  unreadable,TResult Function( DocumentPermissionDenied value)?  permissionDenied,TResult Function( DocumentUploadFailed value)?  upload,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DocumentTooLarge() when tooLarge != null:
return tooLarge(_that);case DocumentUnsupportedType() when unsupportedType != null:
return unsupportedType(_that);case DocumentUnreadable() when unreadable != null:
return unreadable(_that);case DocumentPermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case DocumentUploadFailed() when upload != null:
return upload(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DocumentTooLarge value)  tooLarge,required TResult Function( DocumentUnsupportedType value)  unsupportedType,required TResult Function( DocumentUnreadable value)  unreadable,required TResult Function( DocumentPermissionDenied value)  permissionDenied,required TResult Function( DocumentUploadFailed value)  upload,}){
final _that = this;
switch (_that) {
case DocumentTooLarge():
return tooLarge(_that);case DocumentUnsupportedType():
return unsupportedType(_that);case DocumentUnreadable():
return unreadable(_that);case DocumentPermissionDenied():
return permissionDenied(_that);case DocumentUploadFailed():
return upload(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DocumentTooLarge value)?  tooLarge,TResult? Function( DocumentUnsupportedType value)?  unsupportedType,TResult? Function( DocumentUnreadable value)?  unreadable,TResult? Function( DocumentPermissionDenied value)?  permissionDenied,TResult? Function( DocumentUploadFailed value)?  upload,}){
final _that = this;
switch (_that) {
case DocumentTooLarge() when tooLarge != null:
return tooLarge(_that);case DocumentUnsupportedType() when unsupportedType != null:
return unsupportedType(_that);case DocumentUnreadable() when unreadable != null:
return unreadable(_that);case DocumentPermissionDenied() when permissionDenied != null:
return permissionDenied(_that);case DocumentUploadFailed() when upload != null:
return upload(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int maxBytes)?  tooLarge,TResult Function()?  unsupportedType,TResult Function()?  unreadable,TResult Function()?  permissionDenied,TResult Function( AppFailure failure)?  upload,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DocumentTooLarge() when tooLarge != null:
return tooLarge(_that.maxBytes);case DocumentUnsupportedType() when unsupportedType != null:
return unsupportedType();case DocumentUnreadable() when unreadable != null:
return unreadable();case DocumentPermissionDenied() when permissionDenied != null:
return permissionDenied();case DocumentUploadFailed() when upload != null:
return upload(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int maxBytes)  tooLarge,required TResult Function()  unsupportedType,required TResult Function()  unreadable,required TResult Function()  permissionDenied,required TResult Function( AppFailure failure)  upload,}) {final _that = this;
switch (_that) {
case DocumentTooLarge():
return tooLarge(_that.maxBytes);case DocumentUnsupportedType():
return unsupportedType();case DocumentUnreadable():
return unreadable();case DocumentPermissionDenied():
return permissionDenied();case DocumentUploadFailed():
return upload(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int maxBytes)?  tooLarge,TResult? Function()?  unsupportedType,TResult? Function()?  unreadable,TResult? Function()?  permissionDenied,TResult? Function( AppFailure failure)?  upload,}) {final _that = this;
switch (_that) {
case DocumentTooLarge() when tooLarge != null:
return tooLarge(_that.maxBytes);case DocumentUnsupportedType() when unsupportedType != null:
return unsupportedType();case DocumentUnreadable() when unreadable != null:
return unreadable();case DocumentPermissionDenied() when permissionDenied != null:
return permissionDenied();case DocumentUploadFailed() when upload != null:
return upload(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class DocumentTooLarge implements DocumentError {
  const DocumentTooLarge({required this.maxBytes});
  

 final  int maxBytes;

/// Create a copy of DocumentError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentTooLargeCopyWith<DocumentTooLarge> get copyWith => _$DocumentTooLargeCopyWithImpl<DocumentTooLarge>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentTooLarge&&(identical(other.maxBytes, maxBytes) || other.maxBytes == maxBytes));
}


@override
int get hashCode => Object.hash(runtimeType,maxBytes);

@override
String toString() {
  return 'DocumentError.tooLarge(maxBytes: $maxBytes)';
}


}

/// @nodoc
abstract mixin class $DocumentTooLargeCopyWith<$Res> implements $DocumentErrorCopyWith<$Res> {
  factory $DocumentTooLargeCopyWith(DocumentTooLarge value, $Res Function(DocumentTooLarge) _then) = _$DocumentTooLargeCopyWithImpl;
@useResult
$Res call({
 int maxBytes
});




}
/// @nodoc
class _$DocumentTooLargeCopyWithImpl<$Res>
    implements $DocumentTooLargeCopyWith<$Res> {
  _$DocumentTooLargeCopyWithImpl(this._self, this._then);

  final DocumentTooLarge _self;
  final $Res Function(DocumentTooLarge) _then;

/// Create a copy of DocumentError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? maxBytes = null,}) {
  return _then(DocumentTooLarge(
maxBytes: null == maxBytes ? _self.maxBytes : maxBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class DocumentUnsupportedType implements DocumentError {
  const DocumentUnsupportedType();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentUnsupportedType);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentError.unsupportedType()';
}


}




/// @nodoc


class DocumentUnreadable implements DocumentError {
  const DocumentUnreadable();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentUnreadable);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentError.unreadable()';
}


}




/// @nodoc


class DocumentPermissionDenied implements DocumentError {
  const DocumentPermissionDenied();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentPermissionDenied);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentError.permissionDenied()';
}


}




/// @nodoc


class DocumentUploadFailed implements DocumentError {
  const DocumentUploadFailed(this.failure);
  

 final  AppFailure failure;

/// Create a copy of DocumentError
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentUploadFailedCopyWith<DocumentUploadFailed> get copyWith => _$DocumentUploadFailedCopyWithImpl<DocumentUploadFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentUploadFailed&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'DocumentError.upload(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DocumentUploadFailedCopyWith<$Res> implements $DocumentErrorCopyWith<$Res> {
  factory $DocumentUploadFailedCopyWith(DocumentUploadFailed value, $Res Function(DocumentUploadFailed) _then) = _$DocumentUploadFailedCopyWithImpl;
@useResult
$Res call({
 AppFailure failure
});


$AppFailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$DocumentUploadFailedCopyWithImpl<$Res>
    implements $DocumentUploadFailedCopyWith<$Res> {
  _$DocumentUploadFailedCopyWithImpl(this._self, this._then);

  final DocumentUploadFailed _self;
  final $Res Function(DocumentUploadFailed) _then;

/// Create a copy of DocumentError
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(DocumentUploadFailed(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AppFailure,
  ));
}

/// Create a copy of DocumentError
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
