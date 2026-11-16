// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'step2_documents_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PartnerDocuments {

/// Local id used to tell partners apart on the device. Not sent.
 String get id;/// Server owner id (backend `ownerId`) once this partner was saved.
/// Unused for the first partner: that is the Step 1 owner.
 String? get ownerId;/// Legal name, as on the ID. Personal data: never log it.
/// Not used for the first partner: that is the owner from Step 1.
 String? get firstName; String? get lastName; PersonalIdType? get idType; UploadedDocument? get idDocument;/// The ID lists a P.O. Box instead of a street address.
 bool get idShowsPoBox;// Only needed for a passport or a P.O. Box address. Kept (but hidden)
// otherwise, so a mis-tap doesn't lose the upload.
// TODO(review): leave these out of the submission when not required.
 UploadedDocument? get homeUtilityBill; DateTime? get homeUtilityBillDate;
/// Create a copy of PartnerDocuments
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartnerDocumentsCopyWith<PartnerDocuments> get copyWith => _$PartnerDocumentsCopyWithImpl<PartnerDocuments>(this as PartnerDocuments, _$identity);

  /// Serializes this PartnerDocuments to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartnerDocuments&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.idType, idType) || other.idType == idType)&&(identical(other.idDocument, idDocument) || other.idDocument == idDocument)&&(identical(other.idShowsPoBox, idShowsPoBox) || other.idShowsPoBox == idShowsPoBox)&&(identical(other.homeUtilityBill, homeUtilityBill) || other.homeUtilityBill == homeUtilityBill)&&(identical(other.homeUtilityBillDate, homeUtilityBillDate) || other.homeUtilityBillDate == homeUtilityBillDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,firstName,lastName,idType,idDocument,idShowsPoBox,homeUtilityBill,homeUtilityBillDate);

@override
String toString() {
  return 'PartnerDocuments(id: $id, ownerId: $ownerId, firstName: $firstName, lastName: $lastName, idType: $idType, idDocument: $idDocument, idShowsPoBox: $idShowsPoBox, homeUtilityBill: $homeUtilityBill, homeUtilityBillDate: $homeUtilityBillDate)';
}


}

/// @nodoc
abstract mixin class $PartnerDocumentsCopyWith<$Res>  {
  factory $PartnerDocumentsCopyWith(PartnerDocuments value, $Res Function(PartnerDocuments) _then) = _$PartnerDocumentsCopyWithImpl;
@useResult
$Res call({
 String id, String? ownerId, String? firstName, String? lastName, PersonalIdType? idType, UploadedDocument? idDocument, bool idShowsPoBox, UploadedDocument? homeUtilityBill, DateTime? homeUtilityBillDate
});


$UploadedDocumentCopyWith<$Res>? get idDocument;$UploadedDocumentCopyWith<$Res>? get homeUtilityBill;

}
/// @nodoc
class _$PartnerDocumentsCopyWithImpl<$Res>
    implements $PartnerDocumentsCopyWith<$Res> {
  _$PartnerDocumentsCopyWithImpl(this._self, this._then);

  final PartnerDocuments _self;
  final $Res Function(PartnerDocuments) _then;

/// Create a copy of PartnerDocuments
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? ownerId = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? idType = freezed,Object? idDocument = freezed,Object? idShowsPoBox = null,Object? homeUtilityBill = freezed,Object? homeUtilityBillDate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,idType: freezed == idType ? _self.idType : idType // ignore: cast_nullable_to_non_nullable
as PersonalIdType?,idDocument: freezed == idDocument ? _self.idDocument : idDocument // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,idShowsPoBox: null == idShowsPoBox ? _self.idShowsPoBox : idShowsPoBox // ignore: cast_nullable_to_non_nullable
as bool,homeUtilityBill: freezed == homeUtilityBill ? _self.homeUtilityBill : homeUtilityBill // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,homeUtilityBillDate: freezed == homeUtilityBillDate ? _self.homeUtilityBillDate : homeUtilityBillDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of PartnerDocuments
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get idDocument {
    if (_self.idDocument == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.idDocument!, (value) {
    return _then(_self.copyWith(idDocument: value));
  });
}/// Create a copy of PartnerDocuments
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get homeUtilityBill {
    if (_self.homeUtilityBill == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.homeUtilityBill!, (value) {
    return _then(_self.copyWith(homeUtilityBill: value));
  });
}
}


/// Adds pattern-matching-related methods to [PartnerDocuments].
extension PartnerDocumentsPatterns on PartnerDocuments {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartnerDocuments value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartnerDocuments() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartnerDocuments value)  $default,){
final _that = this;
switch (_that) {
case _PartnerDocuments():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartnerDocuments value)?  $default,){
final _that = this;
switch (_that) {
case _PartnerDocuments() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? ownerId,  String? firstName,  String? lastName,  PersonalIdType? idType,  UploadedDocument? idDocument,  bool idShowsPoBox,  UploadedDocument? homeUtilityBill,  DateTime? homeUtilityBillDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartnerDocuments() when $default != null:
return $default(_that.id,_that.ownerId,_that.firstName,_that.lastName,_that.idType,_that.idDocument,_that.idShowsPoBox,_that.homeUtilityBill,_that.homeUtilityBillDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? ownerId,  String? firstName,  String? lastName,  PersonalIdType? idType,  UploadedDocument? idDocument,  bool idShowsPoBox,  UploadedDocument? homeUtilityBill,  DateTime? homeUtilityBillDate)  $default,) {final _that = this;
switch (_that) {
case _PartnerDocuments():
return $default(_that.id,_that.ownerId,_that.firstName,_that.lastName,_that.idType,_that.idDocument,_that.idShowsPoBox,_that.homeUtilityBill,_that.homeUtilityBillDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? ownerId,  String? firstName,  String? lastName,  PersonalIdType? idType,  UploadedDocument? idDocument,  bool idShowsPoBox,  UploadedDocument? homeUtilityBill,  DateTime? homeUtilityBillDate)?  $default,) {final _that = this;
switch (_that) {
case _PartnerDocuments() when $default != null:
return $default(_that.id,_that.ownerId,_that.firstName,_that.lastName,_that.idType,_that.idDocument,_that.idShowsPoBox,_that.homeUtilityBill,_that.homeUtilityBillDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PartnerDocuments extends PartnerDocuments {
  const _PartnerDocuments({required this.id, this.ownerId, this.firstName, this.lastName, this.idType, this.idDocument, this.idShowsPoBox = false, this.homeUtilityBill, this.homeUtilityBillDate}): super._();
  factory _PartnerDocuments.fromJson(Map<String, dynamic> json) => _$PartnerDocumentsFromJson(json);

/// Local id used to tell partners apart on the device. Not sent.
@override final  String id;
/// Server owner id (backend `ownerId`) once this partner was saved.
/// Unused for the first partner: that is the Step 1 owner.
@override final  String? ownerId;
/// Legal name, as on the ID. Personal data: never log it.
/// Not used for the first partner: that is the owner from Step 1.
@override final  String? firstName;
@override final  String? lastName;
@override final  PersonalIdType? idType;
@override final  UploadedDocument? idDocument;
/// The ID lists a P.O. Box instead of a street address.
@override@JsonKey() final  bool idShowsPoBox;
// Only needed for a passport or a P.O. Box address. Kept (but hidden)
// otherwise, so a mis-tap doesn't lose the upload.
// TODO(review): leave these out of the submission when not required.
@override final  UploadedDocument? homeUtilityBill;
@override final  DateTime? homeUtilityBillDate;

/// Create a copy of PartnerDocuments
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartnerDocumentsCopyWith<_PartnerDocuments> get copyWith => __$PartnerDocumentsCopyWithImpl<_PartnerDocuments>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PartnerDocumentsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartnerDocuments&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.idType, idType) || other.idType == idType)&&(identical(other.idDocument, idDocument) || other.idDocument == idDocument)&&(identical(other.idShowsPoBox, idShowsPoBox) || other.idShowsPoBox == idShowsPoBox)&&(identical(other.homeUtilityBill, homeUtilityBill) || other.homeUtilityBill == homeUtilityBill)&&(identical(other.homeUtilityBillDate, homeUtilityBillDate) || other.homeUtilityBillDate == homeUtilityBillDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerId,firstName,lastName,idType,idDocument,idShowsPoBox,homeUtilityBill,homeUtilityBillDate);

@override
String toString() {
  return 'PartnerDocuments(id: $id, ownerId: $ownerId, firstName: $firstName, lastName: $lastName, idType: $idType, idDocument: $idDocument, idShowsPoBox: $idShowsPoBox, homeUtilityBill: $homeUtilityBill, homeUtilityBillDate: $homeUtilityBillDate)';
}


}

/// @nodoc
abstract mixin class _$PartnerDocumentsCopyWith<$Res> implements $PartnerDocumentsCopyWith<$Res> {
  factory _$PartnerDocumentsCopyWith(_PartnerDocuments value, $Res Function(_PartnerDocuments) _then) = __$PartnerDocumentsCopyWithImpl;
@override @useResult
$Res call({
 String id, String? ownerId, String? firstName, String? lastName, PersonalIdType? idType, UploadedDocument? idDocument, bool idShowsPoBox, UploadedDocument? homeUtilityBill, DateTime? homeUtilityBillDate
});


@override $UploadedDocumentCopyWith<$Res>? get idDocument;@override $UploadedDocumentCopyWith<$Res>? get homeUtilityBill;

}
/// @nodoc
class __$PartnerDocumentsCopyWithImpl<$Res>
    implements _$PartnerDocumentsCopyWith<$Res> {
  __$PartnerDocumentsCopyWithImpl(this._self, this._then);

  final _PartnerDocuments _self;
  final $Res Function(_PartnerDocuments) _then;

/// Create a copy of PartnerDocuments
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? ownerId = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? idType = freezed,Object? idDocument = freezed,Object? idShowsPoBox = null,Object? homeUtilityBill = freezed,Object? homeUtilityBillDate = freezed,}) {
  return _then(_PartnerDocuments(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,ownerId: freezed == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,idType: freezed == idType ? _self.idType : idType // ignore: cast_nullable_to_non_nullable
as PersonalIdType?,idDocument: freezed == idDocument ? _self.idDocument : idDocument // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,idShowsPoBox: null == idShowsPoBox ? _self.idShowsPoBox : idShowsPoBox // ignore: cast_nullable_to_non_nullable
as bool,homeUtilityBill: freezed == homeUtilityBill ? _self.homeUtilityBill : homeUtilityBill // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,homeUtilityBillDate: freezed == homeUtilityBillDate ? _self.homeUtilityBillDate : homeUtilityBillDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of PartnerDocuments
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get idDocument {
    if (_self.idDocument == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.idDocument!, (value) {
    return _then(_self.copyWith(idDocument: value));
  });
}/// Create a copy of PartnerDocuments
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get homeUtilityBill {
    if (_self.homeUtilityBill == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.homeUtilityBill!, (value) {
    return _then(_self.copyWith(homeUtilityBill: value));
  });
}
}


/// @nodoc
mixin _$Step2DocumentsData {

/// At least one. The first partner is the Step 1 owner (also "Same as
/// owner" in Step 3) and can't be removed.
 List<PartnerDocuments> get partners; RegistrationDocType? get registrationType; UploadedDocument? get businessRegistration; IrsDocType? get irsType; UploadedDocument? get irsRegistration;/// Narrows the [licenseType] list. Changing it clears [licenseType] but
/// keeps the file.
 LicenseCategory? get licenseCategory; LicenseType? get licenseType; UploadedDocument? get license; UploadedDocument? get businessUtilityBill; DateTime? get businessUtilityBillDate; UploadedDocument? get exteriorPhoto; UploadedDocument? get interiorLayoutPhoto; UploadedDocument? get checkoutPhoto;/// Optional fourth photo.
 UploadedDocument? get additionalPhoto;/// The business uses a trade name (DBA). The backend verifies it from the
/// photos; DBA documentation is optional.
 bool get usesTradeName;// Kept (but hidden) if the DBA toggle is turned off.
// TODO(review): leave them out of the submission when not using a DBA.
// TODO(backend): no partner endpoint sets the trade name yet.
 String? get tradeName; UploadedDocument? get dbaDocument;/// Required while Step 1 says the business is a subtenant. Kept (but
/// hidden) if that is turned off.
// TODO(review): leave it out of the submission when not subleasing.
 UploadedDocument? get subleaseAgreement;
/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Step2DocumentsDataCopyWith<Step2DocumentsData> get copyWith => _$Step2DocumentsDataCopyWithImpl<Step2DocumentsData>(this as Step2DocumentsData, _$identity);

  /// Serializes this Step2DocumentsData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Step2DocumentsData&&const DeepCollectionEquality().equals(other.partners, partners)&&(identical(other.registrationType, registrationType) || other.registrationType == registrationType)&&(identical(other.businessRegistration, businessRegistration) || other.businessRegistration == businessRegistration)&&(identical(other.irsType, irsType) || other.irsType == irsType)&&(identical(other.irsRegistration, irsRegistration) || other.irsRegistration == irsRegistration)&&(identical(other.licenseCategory, licenseCategory) || other.licenseCategory == licenseCategory)&&(identical(other.licenseType, licenseType) || other.licenseType == licenseType)&&(identical(other.license, license) || other.license == license)&&(identical(other.businessUtilityBill, businessUtilityBill) || other.businessUtilityBill == businessUtilityBill)&&(identical(other.businessUtilityBillDate, businessUtilityBillDate) || other.businessUtilityBillDate == businessUtilityBillDate)&&(identical(other.exteriorPhoto, exteriorPhoto) || other.exteriorPhoto == exteriorPhoto)&&(identical(other.interiorLayoutPhoto, interiorLayoutPhoto) || other.interiorLayoutPhoto == interiorLayoutPhoto)&&(identical(other.checkoutPhoto, checkoutPhoto) || other.checkoutPhoto == checkoutPhoto)&&(identical(other.additionalPhoto, additionalPhoto) || other.additionalPhoto == additionalPhoto)&&(identical(other.usesTradeName, usesTradeName) || other.usesTradeName == usesTradeName)&&(identical(other.tradeName, tradeName) || other.tradeName == tradeName)&&(identical(other.dbaDocument, dbaDocument) || other.dbaDocument == dbaDocument)&&(identical(other.subleaseAgreement, subleaseAgreement) || other.subleaseAgreement == subleaseAgreement));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(partners),registrationType,businessRegistration,irsType,irsRegistration,licenseCategory,licenseType,license,businessUtilityBill,businessUtilityBillDate,exteriorPhoto,interiorLayoutPhoto,checkoutPhoto,additionalPhoto,usesTradeName,tradeName,dbaDocument,subleaseAgreement);

@override
String toString() {
  return 'Step2DocumentsData(partners: $partners, registrationType: $registrationType, businessRegistration: $businessRegistration, irsType: $irsType, irsRegistration: $irsRegistration, licenseCategory: $licenseCategory, licenseType: $licenseType, license: $license, businessUtilityBill: $businessUtilityBill, businessUtilityBillDate: $businessUtilityBillDate, exteriorPhoto: $exteriorPhoto, interiorLayoutPhoto: $interiorLayoutPhoto, checkoutPhoto: $checkoutPhoto, additionalPhoto: $additionalPhoto, usesTradeName: $usesTradeName, tradeName: $tradeName, dbaDocument: $dbaDocument, subleaseAgreement: $subleaseAgreement)';
}


}

/// @nodoc
abstract mixin class $Step2DocumentsDataCopyWith<$Res>  {
  factory $Step2DocumentsDataCopyWith(Step2DocumentsData value, $Res Function(Step2DocumentsData) _then) = _$Step2DocumentsDataCopyWithImpl;
@useResult
$Res call({
 List<PartnerDocuments> partners, RegistrationDocType? registrationType, UploadedDocument? businessRegistration, IrsDocType? irsType, UploadedDocument? irsRegistration, LicenseCategory? licenseCategory, LicenseType? licenseType, UploadedDocument? license, UploadedDocument? businessUtilityBill, DateTime? businessUtilityBillDate, UploadedDocument? exteriorPhoto, UploadedDocument? interiorLayoutPhoto, UploadedDocument? checkoutPhoto, UploadedDocument? additionalPhoto, bool usesTradeName, String? tradeName, UploadedDocument? dbaDocument, UploadedDocument? subleaseAgreement
});


$UploadedDocumentCopyWith<$Res>? get businessRegistration;$UploadedDocumentCopyWith<$Res>? get irsRegistration;$UploadedDocumentCopyWith<$Res>? get license;$UploadedDocumentCopyWith<$Res>? get businessUtilityBill;$UploadedDocumentCopyWith<$Res>? get exteriorPhoto;$UploadedDocumentCopyWith<$Res>? get interiorLayoutPhoto;$UploadedDocumentCopyWith<$Res>? get checkoutPhoto;$UploadedDocumentCopyWith<$Res>? get additionalPhoto;$UploadedDocumentCopyWith<$Res>? get dbaDocument;$UploadedDocumentCopyWith<$Res>? get subleaseAgreement;

}
/// @nodoc
class _$Step2DocumentsDataCopyWithImpl<$Res>
    implements $Step2DocumentsDataCopyWith<$Res> {
  _$Step2DocumentsDataCopyWithImpl(this._self, this._then);

  final Step2DocumentsData _self;
  final $Res Function(Step2DocumentsData) _then;

/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? partners = null,Object? registrationType = freezed,Object? businessRegistration = freezed,Object? irsType = freezed,Object? irsRegistration = freezed,Object? licenseCategory = freezed,Object? licenseType = freezed,Object? license = freezed,Object? businessUtilityBill = freezed,Object? businessUtilityBillDate = freezed,Object? exteriorPhoto = freezed,Object? interiorLayoutPhoto = freezed,Object? checkoutPhoto = freezed,Object? additionalPhoto = freezed,Object? usesTradeName = null,Object? tradeName = freezed,Object? dbaDocument = freezed,Object? subleaseAgreement = freezed,}) {
  return _then(_self.copyWith(
partners: null == partners ? _self.partners : partners // ignore: cast_nullable_to_non_nullable
as List<PartnerDocuments>,registrationType: freezed == registrationType ? _self.registrationType : registrationType // ignore: cast_nullable_to_non_nullable
as RegistrationDocType?,businessRegistration: freezed == businessRegistration ? _self.businessRegistration : businessRegistration // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,irsType: freezed == irsType ? _self.irsType : irsType // ignore: cast_nullable_to_non_nullable
as IrsDocType?,irsRegistration: freezed == irsRegistration ? _self.irsRegistration : irsRegistration // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,licenseCategory: freezed == licenseCategory ? _self.licenseCategory : licenseCategory // ignore: cast_nullable_to_non_nullable
as LicenseCategory?,licenseType: freezed == licenseType ? _self.licenseType : licenseType // ignore: cast_nullable_to_non_nullable
as LicenseType?,license: freezed == license ? _self.license : license // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,businessUtilityBill: freezed == businessUtilityBill ? _self.businessUtilityBill : businessUtilityBill // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,businessUtilityBillDate: freezed == businessUtilityBillDate ? _self.businessUtilityBillDate : businessUtilityBillDate // ignore: cast_nullable_to_non_nullable
as DateTime?,exteriorPhoto: freezed == exteriorPhoto ? _self.exteriorPhoto : exteriorPhoto // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,interiorLayoutPhoto: freezed == interiorLayoutPhoto ? _self.interiorLayoutPhoto : interiorLayoutPhoto // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,checkoutPhoto: freezed == checkoutPhoto ? _self.checkoutPhoto : checkoutPhoto // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,additionalPhoto: freezed == additionalPhoto ? _self.additionalPhoto : additionalPhoto // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,usesTradeName: null == usesTradeName ? _self.usesTradeName : usesTradeName // ignore: cast_nullable_to_non_nullable
as bool,tradeName: freezed == tradeName ? _self.tradeName : tradeName // ignore: cast_nullable_to_non_nullable
as String?,dbaDocument: freezed == dbaDocument ? _self.dbaDocument : dbaDocument // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,subleaseAgreement: freezed == subleaseAgreement ? _self.subleaseAgreement : subleaseAgreement // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,
  ));
}
/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get businessRegistration {
    if (_self.businessRegistration == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.businessRegistration!, (value) {
    return _then(_self.copyWith(businessRegistration: value));
  });
}/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get irsRegistration {
    if (_self.irsRegistration == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.irsRegistration!, (value) {
    return _then(_self.copyWith(irsRegistration: value));
  });
}/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get license {
    if (_self.license == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.license!, (value) {
    return _then(_self.copyWith(license: value));
  });
}/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get businessUtilityBill {
    if (_self.businessUtilityBill == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.businessUtilityBill!, (value) {
    return _then(_self.copyWith(businessUtilityBill: value));
  });
}/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get exteriorPhoto {
    if (_self.exteriorPhoto == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.exteriorPhoto!, (value) {
    return _then(_self.copyWith(exteriorPhoto: value));
  });
}/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get interiorLayoutPhoto {
    if (_self.interiorLayoutPhoto == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.interiorLayoutPhoto!, (value) {
    return _then(_self.copyWith(interiorLayoutPhoto: value));
  });
}/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get checkoutPhoto {
    if (_self.checkoutPhoto == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.checkoutPhoto!, (value) {
    return _then(_self.copyWith(checkoutPhoto: value));
  });
}/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get additionalPhoto {
    if (_self.additionalPhoto == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.additionalPhoto!, (value) {
    return _then(_self.copyWith(additionalPhoto: value));
  });
}/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get dbaDocument {
    if (_self.dbaDocument == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.dbaDocument!, (value) {
    return _then(_self.copyWith(dbaDocument: value));
  });
}/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get subleaseAgreement {
    if (_self.subleaseAgreement == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.subleaseAgreement!, (value) {
    return _then(_self.copyWith(subleaseAgreement: value));
  });
}
}


/// Adds pattern-matching-related methods to [Step2DocumentsData].
extension Step2DocumentsDataPatterns on Step2DocumentsData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Step2DocumentsData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Step2DocumentsData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Step2DocumentsData value)  $default,){
final _that = this;
switch (_that) {
case _Step2DocumentsData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Step2DocumentsData value)?  $default,){
final _that = this;
switch (_that) {
case _Step2DocumentsData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PartnerDocuments> partners,  RegistrationDocType? registrationType,  UploadedDocument? businessRegistration,  IrsDocType? irsType,  UploadedDocument? irsRegistration,  LicenseCategory? licenseCategory,  LicenseType? licenseType,  UploadedDocument? license,  UploadedDocument? businessUtilityBill,  DateTime? businessUtilityBillDate,  UploadedDocument? exteriorPhoto,  UploadedDocument? interiorLayoutPhoto,  UploadedDocument? checkoutPhoto,  UploadedDocument? additionalPhoto,  bool usesTradeName,  String? tradeName,  UploadedDocument? dbaDocument,  UploadedDocument? subleaseAgreement)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Step2DocumentsData() when $default != null:
return $default(_that.partners,_that.registrationType,_that.businessRegistration,_that.irsType,_that.irsRegistration,_that.licenseCategory,_that.licenseType,_that.license,_that.businessUtilityBill,_that.businessUtilityBillDate,_that.exteriorPhoto,_that.interiorLayoutPhoto,_that.checkoutPhoto,_that.additionalPhoto,_that.usesTradeName,_that.tradeName,_that.dbaDocument,_that.subleaseAgreement);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PartnerDocuments> partners,  RegistrationDocType? registrationType,  UploadedDocument? businessRegistration,  IrsDocType? irsType,  UploadedDocument? irsRegistration,  LicenseCategory? licenseCategory,  LicenseType? licenseType,  UploadedDocument? license,  UploadedDocument? businessUtilityBill,  DateTime? businessUtilityBillDate,  UploadedDocument? exteriorPhoto,  UploadedDocument? interiorLayoutPhoto,  UploadedDocument? checkoutPhoto,  UploadedDocument? additionalPhoto,  bool usesTradeName,  String? tradeName,  UploadedDocument? dbaDocument,  UploadedDocument? subleaseAgreement)  $default,) {final _that = this;
switch (_that) {
case _Step2DocumentsData():
return $default(_that.partners,_that.registrationType,_that.businessRegistration,_that.irsType,_that.irsRegistration,_that.licenseCategory,_that.licenseType,_that.license,_that.businessUtilityBill,_that.businessUtilityBillDate,_that.exteriorPhoto,_that.interiorLayoutPhoto,_that.checkoutPhoto,_that.additionalPhoto,_that.usesTradeName,_that.tradeName,_that.dbaDocument,_that.subleaseAgreement);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PartnerDocuments> partners,  RegistrationDocType? registrationType,  UploadedDocument? businessRegistration,  IrsDocType? irsType,  UploadedDocument? irsRegistration,  LicenseCategory? licenseCategory,  LicenseType? licenseType,  UploadedDocument? license,  UploadedDocument? businessUtilityBill,  DateTime? businessUtilityBillDate,  UploadedDocument? exteriorPhoto,  UploadedDocument? interiorLayoutPhoto,  UploadedDocument? checkoutPhoto,  UploadedDocument? additionalPhoto,  bool usesTradeName,  String? tradeName,  UploadedDocument? dbaDocument,  UploadedDocument? subleaseAgreement)?  $default,) {final _that = this;
switch (_that) {
case _Step2DocumentsData() when $default != null:
return $default(_that.partners,_that.registrationType,_that.businessRegistration,_that.irsType,_that.irsRegistration,_that.licenseCategory,_that.licenseType,_that.license,_that.businessUtilityBill,_that.businessUtilityBillDate,_that.exteriorPhoto,_that.interiorLayoutPhoto,_that.checkoutPhoto,_that.additionalPhoto,_that.usesTradeName,_that.tradeName,_that.dbaDocument,_that.subleaseAgreement);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Step2DocumentsData extends Step2DocumentsData {
  const _Step2DocumentsData({final  List<PartnerDocuments> partners = const [PartnerDocuments(id: Step2DocumentsData.firstPartnerId)], this.registrationType, this.businessRegistration, this.irsType, this.irsRegistration, this.licenseCategory, this.licenseType, this.license, this.businessUtilityBill, this.businessUtilityBillDate, this.exteriorPhoto, this.interiorLayoutPhoto, this.checkoutPhoto, this.additionalPhoto, this.usesTradeName = false, this.tradeName, this.dbaDocument, this.subleaseAgreement}): _partners = partners,super._();
  factory _Step2DocumentsData.fromJson(Map<String, dynamic> json) => _$Step2DocumentsDataFromJson(json);

/// At least one. The first partner is the Step 1 owner (also "Same as
/// owner" in Step 3) and can't be removed.
 final  List<PartnerDocuments> _partners;
/// At least one. The first partner is the Step 1 owner (also "Same as
/// owner" in Step 3) and can't be removed.
@override@JsonKey() List<PartnerDocuments> get partners {
  if (_partners is EqualUnmodifiableListView) return _partners;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_partners);
}

@override final  RegistrationDocType? registrationType;
@override final  UploadedDocument? businessRegistration;
@override final  IrsDocType? irsType;
@override final  UploadedDocument? irsRegistration;
/// Narrows the [licenseType] list. Changing it clears [licenseType] but
/// keeps the file.
@override final  LicenseCategory? licenseCategory;
@override final  LicenseType? licenseType;
@override final  UploadedDocument? license;
@override final  UploadedDocument? businessUtilityBill;
@override final  DateTime? businessUtilityBillDate;
@override final  UploadedDocument? exteriorPhoto;
@override final  UploadedDocument? interiorLayoutPhoto;
@override final  UploadedDocument? checkoutPhoto;
/// Optional fourth photo.
@override final  UploadedDocument? additionalPhoto;
/// The business uses a trade name (DBA). The backend verifies it from the
/// photos; DBA documentation is optional.
@override@JsonKey() final  bool usesTradeName;
// Kept (but hidden) if the DBA toggle is turned off.
// TODO(review): leave them out of the submission when not using a DBA.
// TODO(backend): no partner endpoint sets the trade name yet.
@override final  String? tradeName;
@override final  UploadedDocument? dbaDocument;
/// Required while Step 1 says the business is a subtenant. Kept (but
/// hidden) if that is turned off.
// TODO(review): leave it out of the submission when not subleasing.
@override final  UploadedDocument? subleaseAgreement;

/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$Step2DocumentsDataCopyWith<_Step2DocumentsData> get copyWith => __$Step2DocumentsDataCopyWithImpl<_Step2DocumentsData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$Step2DocumentsDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Step2DocumentsData&&const DeepCollectionEquality().equals(other._partners, _partners)&&(identical(other.registrationType, registrationType) || other.registrationType == registrationType)&&(identical(other.businessRegistration, businessRegistration) || other.businessRegistration == businessRegistration)&&(identical(other.irsType, irsType) || other.irsType == irsType)&&(identical(other.irsRegistration, irsRegistration) || other.irsRegistration == irsRegistration)&&(identical(other.licenseCategory, licenseCategory) || other.licenseCategory == licenseCategory)&&(identical(other.licenseType, licenseType) || other.licenseType == licenseType)&&(identical(other.license, license) || other.license == license)&&(identical(other.businessUtilityBill, businessUtilityBill) || other.businessUtilityBill == businessUtilityBill)&&(identical(other.businessUtilityBillDate, businessUtilityBillDate) || other.businessUtilityBillDate == businessUtilityBillDate)&&(identical(other.exteriorPhoto, exteriorPhoto) || other.exteriorPhoto == exteriorPhoto)&&(identical(other.interiorLayoutPhoto, interiorLayoutPhoto) || other.interiorLayoutPhoto == interiorLayoutPhoto)&&(identical(other.checkoutPhoto, checkoutPhoto) || other.checkoutPhoto == checkoutPhoto)&&(identical(other.additionalPhoto, additionalPhoto) || other.additionalPhoto == additionalPhoto)&&(identical(other.usesTradeName, usesTradeName) || other.usesTradeName == usesTradeName)&&(identical(other.tradeName, tradeName) || other.tradeName == tradeName)&&(identical(other.dbaDocument, dbaDocument) || other.dbaDocument == dbaDocument)&&(identical(other.subleaseAgreement, subleaseAgreement) || other.subleaseAgreement == subleaseAgreement));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_partners),registrationType,businessRegistration,irsType,irsRegistration,licenseCategory,licenseType,license,businessUtilityBill,businessUtilityBillDate,exteriorPhoto,interiorLayoutPhoto,checkoutPhoto,additionalPhoto,usesTradeName,tradeName,dbaDocument,subleaseAgreement);

@override
String toString() {
  return 'Step2DocumentsData(partners: $partners, registrationType: $registrationType, businessRegistration: $businessRegistration, irsType: $irsType, irsRegistration: $irsRegistration, licenseCategory: $licenseCategory, licenseType: $licenseType, license: $license, businessUtilityBill: $businessUtilityBill, businessUtilityBillDate: $businessUtilityBillDate, exteriorPhoto: $exteriorPhoto, interiorLayoutPhoto: $interiorLayoutPhoto, checkoutPhoto: $checkoutPhoto, additionalPhoto: $additionalPhoto, usesTradeName: $usesTradeName, tradeName: $tradeName, dbaDocument: $dbaDocument, subleaseAgreement: $subleaseAgreement)';
}


}

/// @nodoc
abstract mixin class _$Step2DocumentsDataCopyWith<$Res> implements $Step2DocumentsDataCopyWith<$Res> {
  factory _$Step2DocumentsDataCopyWith(_Step2DocumentsData value, $Res Function(_Step2DocumentsData) _then) = __$Step2DocumentsDataCopyWithImpl;
@override @useResult
$Res call({
 List<PartnerDocuments> partners, RegistrationDocType? registrationType, UploadedDocument? businessRegistration, IrsDocType? irsType, UploadedDocument? irsRegistration, LicenseCategory? licenseCategory, LicenseType? licenseType, UploadedDocument? license, UploadedDocument? businessUtilityBill, DateTime? businessUtilityBillDate, UploadedDocument? exteriorPhoto, UploadedDocument? interiorLayoutPhoto, UploadedDocument? checkoutPhoto, UploadedDocument? additionalPhoto, bool usesTradeName, String? tradeName, UploadedDocument? dbaDocument, UploadedDocument? subleaseAgreement
});


@override $UploadedDocumentCopyWith<$Res>? get businessRegistration;@override $UploadedDocumentCopyWith<$Res>? get irsRegistration;@override $UploadedDocumentCopyWith<$Res>? get license;@override $UploadedDocumentCopyWith<$Res>? get businessUtilityBill;@override $UploadedDocumentCopyWith<$Res>? get exteriorPhoto;@override $UploadedDocumentCopyWith<$Res>? get interiorLayoutPhoto;@override $UploadedDocumentCopyWith<$Res>? get checkoutPhoto;@override $UploadedDocumentCopyWith<$Res>? get additionalPhoto;@override $UploadedDocumentCopyWith<$Res>? get dbaDocument;@override $UploadedDocumentCopyWith<$Res>? get subleaseAgreement;

}
/// @nodoc
class __$Step2DocumentsDataCopyWithImpl<$Res>
    implements _$Step2DocumentsDataCopyWith<$Res> {
  __$Step2DocumentsDataCopyWithImpl(this._self, this._then);

  final _Step2DocumentsData _self;
  final $Res Function(_Step2DocumentsData) _then;

/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? partners = null,Object? registrationType = freezed,Object? businessRegistration = freezed,Object? irsType = freezed,Object? irsRegistration = freezed,Object? licenseCategory = freezed,Object? licenseType = freezed,Object? license = freezed,Object? businessUtilityBill = freezed,Object? businessUtilityBillDate = freezed,Object? exteriorPhoto = freezed,Object? interiorLayoutPhoto = freezed,Object? checkoutPhoto = freezed,Object? additionalPhoto = freezed,Object? usesTradeName = null,Object? tradeName = freezed,Object? dbaDocument = freezed,Object? subleaseAgreement = freezed,}) {
  return _then(_Step2DocumentsData(
partners: null == partners ? _self._partners : partners // ignore: cast_nullable_to_non_nullable
as List<PartnerDocuments>,registrationType: freezed == registrationType ? _self.registrationType : registrationType // ignore: cast_nullable_to_non_nullable
as RegistrationDocType?,businessRegistration: freezed == businessRegistration ? _self.businessRegistration : businessRegistration // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,irsType: freezed == irsType ? _self.irsType : irsType // ignore: cast_nullable_to_non_nullable
as IrsDocType?,irsRegistration: freezed == irsRegistration ? _self.irsRegistration : irsRegistration // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,licenseCategory: freezed == licenseCategory ? _self.licenseCategory : licenseCategory // ignore: cast_nullable_to_non_nullable
as LicenseCategory?,licenseType: freezed == licenseType ? _self.licenseType : licenseType // ignore: cast_nullable_to_non_nullable
as LicenseType?,license: freezed == license ? _self.license : license // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,businessUtilityBill: freezed == businessUtilityBill ? _self.businessUtilityBill : businessUtilityBill // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,businessUtilityBillDate: freezed == businessUtilityBillDate ? _self.businessUtilityBillDate : businessUtilityBillDate // ignore: cast_nullable_to_non_nullable
as DateTime?,exteriorPhoto: freezed == exteriorPhoto ? _self.exteriorPhoto : exteriorPhoto // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,interiorLayoutPhoto: freezed == interiorLayoutPhoto ? _self.interiorLayoutPhoto : interiorLayoutPhoto // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,checkoutPhoto: freezed == checkoutPhoto ? _self.checkoutPhoto : checkoutPhoto // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,additionalPhoto: freezed == additionalPhoto ? _self.additionalPhoto : additionalPhoto // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,usesTradeName: null == usesTradeName ? _self.usesTradeName : usesTradeName // ignore: cast_nullable_to_non_nullable
as bool,tradeName: freezed == tradeName ? _self.tradeName : tradeName // ignore: cast_nullable_to_non_nullable
as String?,dbaDocument: freezed == dbaDocument ? _self.dbaDocument : dbaDocument // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,subleaseAgreement: freezed == subleaseAgreement ? _self.subleaseAgreement : subleaseAgreement // ignore: cast_nullable_to_non_nullable
as UploadedDocument?,
  ));
}

/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get businessRegistration {
    if (_self.businessRegistration == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.businessRegistration!, (value) {
    return _then(_self.copyWith(businessRegistration: value));
  });
}/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get irsRegistration {
    if (_self.irsRegistration == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.irsRegistration!, (value) {
    return _then(_self.copyWith(irsRegistration: value));
  });
}/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get license {
    if (_self.license == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.license!, (value) {
    return _then(_self.copyWith(license: value));
  });
}/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get businessUtilityBill {
    if (_self.businessUtilityBill == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.businessUtilityBill!, (value) {
    return _then(_self.copyWith(businessUtilityBill: value));
  });
}/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get exteriorPhoto {
    if (_self.exteriorPhoto == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.exteriorPhoto!, (value) {
    return _then(_self.copyWith(exteriorPhoto: value));
  });
}/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get interiorLayoutPhoto {
    if (_self.interiorLayoutPhoto == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.interiorLayoutPhoto!, (value) {
    return _then(_self.copyWith(interiorLayoutPhoto: value));
  });
}/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get checkoutPhoto {
    if (_self.checkoutPhoto == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.checkoutPhoto!, (value) {
    return _then(_self.copyWith(checkoutPhoto: value));
  });
}/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get additionalPhoto {
    if (_self.additionalPhoto == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.additionalPhoto!, (value) {
    return _then(_self.copyWith(additionalPhoto: value));
  });
}/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get dbaDocument {
    if (_self.dbaDocument == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.dbaDocument!, (value) {
    return _then(_self.copyWith(dbaDocument: value));
  });
}/// Create a copy of Step2DocumentsData
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UploadedDocumentCopyWith<$Res>? get subleaseAgreement {
    if (_self.subleaseAgreement == null) {
    return null;
  }

  return $UploadedDocumentCopyWith<$Res>(_self.subleaseAgreement!, (value) {
    return _then(_self.copyWith(subleaseAgreement: value));
  });
}
}

// dart format on
