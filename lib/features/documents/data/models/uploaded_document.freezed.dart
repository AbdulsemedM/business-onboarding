// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'uploaded_document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UploadedDocument {

/// Server-side id.
// TODO(backend): confirm what the upload endpoint returns.
 String get id; String get fileName; String get mimeType; int get sizeBytes;
/// Create a copy of UploadedDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<UploadedDocument> get copyWith => _$UploadedDocumentCopyWithImpl<UploadedDocument>(this as UploadedDocument, _$identity);

  /// Serializes this UploadedDocument to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UploadedDocument&&(identical(other.id, id) || other.id == id)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fileName,mimeType,sizeBytes);

@override
String toString() {
  return 'UploadedDocument(id: $id, fileName: $fileName, mimeType: $mimeType, sizeBytes: $sizeBytes)';
}


}

/// @nodoc
abstract mixin class $UploadedDocumentCopyWith<$Res>  {
  factory $UploadedDocumentCopyWith(UploadedDocument value, $Res Function(UploadedDocument) _then) = _$UploadedDocumentCopyWithImpl;
@useResult
$Res call({
 String id, String fileName, String mimeType, int sizeBytes
});




}
/// @nodoc
class _$UploadedDocumentCopyWithImpl<$Res>
    implements $UploadedDocumentCopyWith<$Res> {
  _$UploadedDocumentCopyWithImpl(this._self, this._then);

  final UploadedDocument _self;
  final $Res Function(UploadedDocument) _then;

/// Create a copy of UploadedDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fileName = null,Object? mimeType = null,Object? sizeBytes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UploadedDocument].
extension UploadedDocumentPatterns on UploadedDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UploadedDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UploadedDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UploadedDocument value)  $default,){
final _that = this;
switch (_that) {
case _UploadedDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UploadedDocument value)?  $default,){
final _that = this;
switch (_that) {
case _UploadedDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fileName,  String mimeType,  int sizeBytes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UploadedDocument() when $default != null:
return $default(_that.id,_that.fileName,_that.mimeType,_that.sizeBytes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fileName,  String mimeType,  int sizeBytes)  $default,) {final _that = this;
switch (_that) {
case _UploadedDocument():
return $default(_that.id,_that.fileName,_that.mimeType,_that.sizeBytes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fileName,  String mimeType,  int sizeBytes)?  $default,) {final _that = this;
switch (_that) {
case _UploadedDocument() when $default != null:
return $default(_that.id,_that.fileName,_that.mimeType,_that.sizeBytes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UploadedDocument implements UploadedDocument {
  const _UploadedDocument({required this.id, required this.fileName, required this.mimeType, required this.sizeBytes});
  factory _UploadedDocument.fromJson(Map<String, dynamic> json) => _$UploadedDocumentFromJson(json);

/// Server-side id.
// TODO(backend): confirm what the upload endpoint returns.
@override final  String id;
@override final  String fileName;
@override final  String mimeType;
@override final  int sizeBytes;

/// Create a copy of UploadedDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UploadedDocumentCopyWith<_UploadedDocument> get copyWith => __$UploadedDocumentCopyWithImpl<_UploadedDocument>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UploadedDocumentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UploadedDocument&&(identical(other.id, id) || other.id == id)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fileName,mimeType,sizeBytes);

@override
String toString() {
  return 'UploadedDocument(id: $id, fileName: $fileName, mimeType: $mimeType, sizeBytes: $sizeBytes)';
}


}

/// @nodoc
abstract mixin class _$UploadedDocumentCopyWith<$Res> implements $UploadedDocumentCopyWith<$Res> {
  factory _$UploadedDocumentCopyWith(_UploadedDocument value, $Res Function(_UploadedDocument) _then) = __$UploadedDocumentCopyWithImpl;
@override @useResult
$Res call({
 String id, String fileName, String mimeType, int sizeBytes
});




}
/// @nodoc
class __$UploadedDocumentCopyWithImpl<$Res>
    implements _$UploadedDocumentCopyWith<$Res> {
  __$UploadedDocumentCopyWithImpl(this._self, this._then);

  final _UploadedDocument _self;
  final $Res Function(_UploadedDocument) _then;

/// Create a copy of UploadedDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fileName = null,Object? mimeType = null,Object? sizeBytes = null,}) {
  return _then(_UploadedDocument(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,sizeBytes: null == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
