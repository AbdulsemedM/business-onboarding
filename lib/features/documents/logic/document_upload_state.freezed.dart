// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_upload_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DocumentUploadState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentUploadState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentUploadState()';
}


}

/// @nodoc
class $DocumentUploadStateCopyWith<$Res>  {
$DocumentUploadStateCopyWith(DocumentUploadState _, $Res Function(DocumentUploadState) __);
}


/// Adds pattern-matching-related methods to [DocumentUploadState].
extension DocumentUploadStatePatterns on DocumentUploadState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DocumentEmpty value)?  empty,TResult Function( DocumentPreparing value)?  preparing,TResult Function( DocumentUploading value)?  uploading,TResult Function( DocumentUploaded value)?  uploaded,TResult Function( DocumentFailed value)?  failed,TResult Function( DocumentRejected value)?  rejected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DocumentEmpty() when empty != null:
return empty(_that);case DocumentPreparing() when preparing != null:
return preparing(_that);case DocumentUploading() when uploading != null:
return uploading(_that);case DocumentUploaded() when uploaded != null:
return uploaded(_that);case DocumentFailed() when failed != null:
return failed(_that);case DocumentRejected() when rejected != null:
return rejected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DocumentEmpty value)  empty,required TResult Function( DocumentPreparing value)  preparing,required TResult Function( DocumentUploading value)  uploading,required TResult Function( DocumentUploaded value)  uploaded,required TResult Function( DocumentFailed value)  failed,required TResult Function( DocumentRejected value)  rejected,}){
final _that = this;
switch (_that) {
case DocumentEmpty():
return empty(_that);case DocumentPreparing():
return preparing(_that);case DocumentUploading():
return uploading(_that);case DocumentUploaded():
return uploaded(_that);case DocumentFailed():
return failed(_that);case DocumentRejected():
return rejected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DocumentEmpty value)?  empty,TResult? Function( DocumentPreparing value)?  preparing,TResult? Function( DocumentUploading value)?  uploading,TResult? Function( DocumentUploaded value)?  uploaded,TResult? Function( DocumentFailed value)?  failed,TResult? Function( DocumentRejected value)?  rejected,}){
final _that = this;
switch (_that) {
case DocumentEmpty() when empty != null:
return empty(_that);case DocumentPreparing() when preparing != null:
return preparing(_that);case DocumentUploading() when uploading != null:
return uploading(_that);case DocumentUploaded() when uploaded != null:
return uploaded(_that);case DocumentFailed() when failed != null:
return failed(_that);case DocumentRejected() when rejected != null:
return rejected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  empty,TResult Function( UploadedDocument? previous)?  preparing,TResult Function( LocalFile file,  double progress,  UploadedDocument? previous)?  uploading,TResult Function( UploadedDocument document)?  uploaded,TResult Function( DocumentError error,  LocalFile? file,  UploadedDocument? previous)?  failed,TResult Function( String reason,  UploadedDocument? document)?  rejected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DocumentEmpty() when empty != null:
return empty();case DocumentPreparing() when preparing != null:
return preparing(_that.previous);case DocumentUploading() when uploading != null:
return uploading(_that.file,_that.progress,_that.previous);case DocumentUploaded() when uploaded != null:
return uploaded(_that.document);case DocumentFailed() when failed != null:
return failed(_that.error,_that.file,_that.previous);case DocumentRejected() when rejected != null:
return rejected(_that.reason,_that.document);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  empty,required TResult Function( UploadedDocument? previous)  preparing,required TResult Function( LocalFile file,  double progress,  UploadedDocument? previous)  uploading,required TResult Function( UploadedDocument document)  uploaded,required TResult Function( DocumentError error,  LocalFile? file,  UploadedDocument? previous)  failed,required TResult Function( String reason,  UploadedDocument? document)  rejected,}) {final _that = this;
switch (_that) {
case DocumentEmpty():
return empty();case DocumentPreparing():
return preparing(_that.previous);case DocumentUploading():
return uploading(_that.file,_that.progress,_that.previous);case DocumentUploaded():
return uploaded(_that.document);case DocumentFailed():
return failed(_that.error,_that.file,_that.previous);case DocumentRejected():
return rejected(_that.reason,_that.document);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  empty,TResult? Function( UploadedDocument? previous)?  preparing,TResult? Function( LocalFile file,  double progress,  UploadedDocument? previous)?  uploading,TResult? Function( UploadedDocument document)?  uploaded,TResult? Function( DocumentError error,  LocalFile? file,  UploadedDocument? previous)?  failed,TResult? Function( String reason,  UploadedDocument? document)?  rejected,}) {final _that = this;
switch (_that) {
case DocumentEmpty() when empty != null:
return empty();case DocumentPreparing() when preparing != null:
return preparing(_that.previous);case DocumentUploading() when uploading != null:
return uploading(_that.file,_that.progress,_that.previous);case DocumentUploaded() when uploaded != null:
return uploaded(_that.document);case DocumentFailed() when failed != null:
return failed(_that.error,_that.file,_that.previous);case DocumentRejected() when rejected != null:
return rejected(_that.reason,_that.document);case _:
  return null;

}
}

}

/// @nodoc


class DocumentEmpty implements DocumentUploadState {
  const DocumentEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DocumentUploadState.empty()';
}


}




/// @nodoc


class DocumentPreparing implements DocumentUploadState {
  const DocumentPreparing({this.previous});
  

 final  UploadedDocument? previous;

/// Create a copy of DocumentUploadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentPreparingCopyWith<DocumentPreparing> get copyWith => _$DocumentPreparingCopyWithImpl<DocumentPreparing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentPreparing&&(identical(other.previous, previous) || other.previous == previous));
}


@override
int get hashCode => Object.hash(runtimeType,previous);

@override
String toString() {
  return 'DocumentUploadState.preparing(previous: $previous)';
}


}

/// @nodoc
abstract mixin class $DocumentPreparingCopyWith<$Res> implements $DocumentUploadStateCopyWith<$Res> {
  factory $DocumentPreparingCopyWith(DocumentPreparing value, $Res Function(DocumentPreparing) _then) = _$DocumentPreparingCopyWithImpl;
@useResult
$Res call({
 UploadedDocument? previous
});


$UploadedDocumentCopyWith<$Res>? get previous;

}
/// @nodoc
class _$DocumentPreparingCopyWithImpl<$Res>
    implements $DocumentPreparingCopyWith<$Res> {
  _$DocumentPreparingCopyWithImpl(this._self, this._then);

  final DocumentPreparing _self;
  final $Res Function(DocumentPreparing) _then;

/// Create a copy of DocumentUploadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? previous = freezed,}) {
  return _then(DocumentPreparing(
previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,
  ));
}

/// Create a copy of DocumentUploadState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get previous {
    if (_self.previous == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.previous!, (value) {
    return _then(_self.copyWith(previous: value));
  });
}
}

/// @nodoc


class DocumentUploading implements DocumentUploadState {
  const DocumentUploading({required this.file, required this.progress, this.previous});
  

 final  LocalFile file;
 final  double progress;
 final  UploadedDocument? previous;

/// Create a copy of DocumentUploadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentUploadingCopyWith<DocumentUploading> get copyWith => _$DocumentUploadingCopyWithImpl<DocumentUploading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentUploading&&(identical(other.file, file) || other.file == file)&&(identical(other.progress, progress) || other.progress == progress)&&(identical(other.previous, previous) || other.previous == previous));
}


@override
int get hashCode => Object.hash(runtimeType,file,progress,previous);

@override
String toString() {
  return 'DocumentUploadState.uploading(file: $file, progress: $progress, previous: $previous)';
}


}

/// @nodoc
abstract mixin class $DocumentUploadingCopyWith<$Res> implements $DocumentUploadStateCopyWith<$Res> {
  factory $DocumentUploadingCopyWith(DocumentUploading value, $Res Function(DocumentUploading) _then) = _$DocumentUploadingCopyWithImpl;
@useResult
$Res call({
 LocalFile file, double progress, UploadedDocument? previous
});


$UploadedDocumentCopyWith<$Res>? get previous;

}
/// @nodoc
class _$DocumentUploadingCopyWithImpl<$Res>
    implements $DocumentUploadingCopyWith<$Res> {
  _$DocumentUploadingCopyWithImpl(this._self, this._then);

  final DocumentUploading _self;
  final $Res Function(DocumentUploading) _then;

/// Create a copy of DocumentUploadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? file = null,Object? progress = null,Object? previous = freezed,}) {
  return _then(DocumentUploading(
file: null == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as LocalFile,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,
  ));
}

/// Create a copy of DocumentUploadState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get previous {
    if (_self.previous == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.previous!, (value) {
    return _then(_self.copyWith(previous: value));
  });
}
}

/// @nodoc


class DocumentUploaded implements DocumentUploadState {
  const DocumentUploaded(this.document);
  

 final  UploadedDocument document;

/// Create a copy of DocumentUploadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentUploadedCopyWith<DocumentUploaded> get copyWith => _$DocumentUploadedCopyWithImpl<DocumentUploaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentUploaded&&(identical(other.document, document) || other.document == document));
}


@override
int get hashCode => Object.hash(runtimeType,document);

@override
String toString() {
  return 'DocumentUploadState.uploaded(document: $document)';
}


}

/// @nodoc
abstract mixin class $DocumentUploadedCopyWith<$Res> implements $DocumentUploadStateCopyWith<$Res> {
  factory $DocumentUploadedCopyWith(DocumentUploaded value, $Res Function(DocumentUploaded) _then) = _$DocumentUploadedCopyWithImpl;
@useResult
$Res call({
 UploadedDocument document
});


$UploadedDocumentCopyWith<$Res> get document;

}
/// @nodoc
class _$DocumentUploadedCopyWithImpl<$Res>
    implements $DocumentUploadedCopyWith<$Res> {
  _$DocumentUploadedCopyWithImpl(this._self, this._then);

  final DocumentUploaded _self;
  final $Res Function(DocumentUploaded) _then;

/// Create a copy of DocumentUploadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? document = null,}) {
  return _then(DocumentUploaded(
null == document ? _self.document : document // ignore: cast_nullable_to_non_nullable
as UploadedDocument,
  ));
}

/// Create a copy of DocumentUploadState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res> get document {
  
  return $UploadedDocumentCopyWith<$Res>(_self.document, (value) {
    return _then(_self.copyWith(document: value));
  });
}
}

/// @nodoc


class DocumentFailed implements DocumentUploadState {
  const DocumentFailed({required this.error, this.file, this.previous});
  

 final  DocumentError error;
 final  LocalFile? file;
 final  UploadedDocument? previous;

/// Create a copy of DocumentUploadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentFailedCopyWith<DocumentFailed> get copyWith => _$DocumentFailedCopyWithImpl<DocumentFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentFailed&&(identical(other.error, error) || other.error == error)&&(identical(other.file, file) || other.file == file)&&(identical(other.previous, previous) || other.previous == previous));
}


@override
int get hashCode => Object.hash(runtimeType,error,file,previous);

@override
String toString() {
  return 'DocumentUploadState.failed(error: $error, file: $file, previous: $previous)';
}


}

/// @nodoc
abstract mixin class $DocumentFailedCopyWith<$Res> implements $DocumentUploadStateCopyWith<$Res> {
  factory $DocumentFailedCopyWith(DocumentFailed value, $Res Function(DocumentFailed) _then) = _$DocumentFailedCopyWithImpl;
@useResult
$Res call({
 DocumentError error, LocalFile? file, UploadedDocument? previous
});


$DocumentErrorCopyWith<$Res> get error;$UploadedDocumentCopyWith<$Res>? get previous;

}
/// @nodoc
class _$DocumentFailedCopyWithImpl<$Res>
    implements $DocumentFailedCopyWith<$Res> {
  _$DocumentFailedCopyWithImpl(this._self, this._then);

  final DocumentFailed _self;
  final $Res Function(DocumentFailed) _then;

/// Create a copy of DocumentUploadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,Object? file = freezed,Object? previous = freezed,}) {
  return _then(DocumentFailed(
error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as DocumentError,file: freezed == file ? _self.file : file // ignore: cast_nullable_to_non_nullable
as LocalFile?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,
  ));
}

/// Create a copy of DocumentUploadState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DocumentErrorCopyWith<$Res> get error {
  
  return $DocumentErrorCopyWith<$Res>(_self.error, (value) {
    return _then(_self.copyWith(error: value));
  });
}/// Create a copy of DocumentUploadState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get previous {
    if (_self.previous == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.previous!, (value) {
    return _then(_self.copyWith(previous: value));
  });
}
}

/// @nodoc


class DocumentRejected implements DocumentUploadState {
  const DocumentRejected({required this.reason, this.document});
  

 final  String reason;
 final  UploadedDocument? document;

/// Create a copy of DocumentUploadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentRejectedCopyWith<DocumentRejected> get copyWith => _$DocumentRejectedCopyWithImpl<DocumentRejected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentRejected&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.document, document) || other.document == document));
}


@override
int get hashCode => Object.hash(runtimeType,reason,document);

@override
String toString() {
  return 'DocumentUploadState.rejected(reason: $reason, document: $document)';
}


}

/// @nodoc
abstract mixin class $DocumentRejectedCopyWith<$Res> implements $DocumentUploadStateCopyWith<$Res> {
  factory $DocumentRejectedCopyWith(DocumentRejected value, $Res Function(DocumentRejected) _then) = _$DocumentRejectedCopyWithImpl;
@useResult
$Res call({
 String reason, UploadedDocument? document
});


$UploadedDocumentCopyWith<$Res>? get document;

}
/// @nodoc
class _$DocumentRejectedCopyWithImpl<$Res>
    implements $DocumentRejectedCopyWith<$Res> {
  _$DocumentRejectedCopyWithImpl(this._self, this._then);

  final DocumentRejected _self;
  final $Res Function(DocumentRejected) _then;

/// Create a copy of DocumentUploadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,Object? document = freezed,}) {
  return _then(DocumentRejected(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,document: freezed == document ? _self.document : document // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,
  ));
}

/// Create a copy of DocumentUploadState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get document {
    if (_self.document == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.document!, (value) {
    return _then(_self.copyWith(document: value));
  });
}
}

// dart format on
