// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'step1_business_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Step1BusinessData {

/// Primary owner (backend `primaryOwner`, always `INDIVIDUAL`). They are
/// partner 1 in Step 2.
 String? get ownerFirstName; String? get ownerLastName;/// ISO weekdays: 1 = Monday ... 7 = Sunday.
 List<int> get openDays;/// Minutes since midnight.
 int? get opensAt; int? get closesAt;// Business location address. Backend requires line 1, city and country.
 String? get addressLine1; String? get addressLine2; String? get city; String? get region; String? get postalCode; String get countryCode;/// The business subleases its space (backend `subtenant`). Step 2 then
/// asks for the sublease agreement.
 bool get subtenant; int? get yearsAtLocation; int? get monthsAtLocation; PropertyStatus? get businessProperty; PropertyStatus? get residentialProperty;/// Optional (backend `monthsAtResidence`).
 int? get yearsAtResidence; int? get monthsAtResidence;// Landlords are only used while the matching property is leased. Kept
// (but hidden) if the user switches to "Own", so a mis-tap doesn't lose
// their input.
// TODO(review): leave them out of the submission when not leased.
 String? get businessLandlordName; String get businessLandlordPhoneCountry; String? get businessLandlordPhoneNumber; String? get residentialLandlordName; String get residentialLandlordPhoneCountry; String? get residentialLandlordPhoneNumber;// TODO(backend): switch to a searchable list if the API provides banks.
 String? get bankName; TaxDesignation? get taxDesignation;/// EIN or SSN digits only, no dashes. Which one depends on
/// [taxDesignation]. Cleared when that changes kind.
 String? get taxId;
/// Create a copy of Step1BusinessData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$Step1BusinessDataCopyWith<Step1BusinessData> get copyWith => _$Step1BusinessDataCopyWithImpl<Step1BusinessData>(this as Step1BusinessData, _$identity);

  /// Serializes this Step1BusinessData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Step1BusinessData&&(identical(other.ownerFirstName, ownerFirstName) || other.ownerFirstName == ownerFirstName)&&(identical(other.ownerLastName, ownerLastName) || other.ownerLastName == ownerLastName)&&const DeepCollectionEquality().equals(other.openDays, openDays)&&(identical(other.opensAt, opensAt) || other.opensAt == opensAt)&&(identical(other.closesAt, closesAt) || other.closesAt == closesAt)&&(identical(other.addressLine1, addressLine1) || other.addressLine1 == addressLine1)&&(identical(other.addressLine2, addressLine2) || other.addressLine2 == addressLine2)&&(identical(other.city, city) || other.city == city)&&(identical(other.region, region) || other.region == region)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.subtenant, subtenant) || other.subtenant == subtenant)&&(identical(other.yearsAtLocation, yearsAtLocation) || other.yearsAtLocation == yearsAtLocation)&&(identical(other.monthsAtLocation, monthsAtLocation) || other.monthsAtLocation == monthsAtLocation)&&(identical(other.businessProperty, businessProperty) || other.businessProperty == businessProperty)&&(identical(other.residentialProperty, residentialProperty) || other.residentialProperty == residentialProperty)&&(identical(other.yearsAtResidence, yearsAtResidence) || other.yearsAtResidence == yearsAtResidence)&&(identical(other.monthsAtResidence, monthsAtResidence) || other.monthsAtResidence == monthsAtResidence)&&(identical(other.businessLandlordName, businessLandlordName) || other.businessLandlordName == businessLandlordName)&&(identical(other.businessLandlordPhoneCountry, businessLandlordPhoneCountry) || other.businessLandlordPhoneCountry == businessLandlordPhoneCountry)&&(identical(other.businessLandlordPhoneNumber, businessLandlordPhoneNumber) || other.businessLandlordPhoneNumber == businessLandlordPhoneNumber)&&(identical(other.residentialLandlordName, residentialLandlordName) || other.residentialLandlordName == residentialLandlordName)&&(identical(other.residentialLandlordPhoneCountry, residentialLandlordPhoneCountry) || other.residentialLandlordPhoneCountry == residentialLandlordPhoneCountry)&&(identical(other.residentialLandlordPhoneNumber, residentialLandlordPhoneNumber) || other.residentialLandlordPhoneNumber == residentialLandlordPhoneNumber)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.taxDesignation, taxDesignation) || other.taxDesignation == taxDesignation)&&(identical(other.taxId, taxId) || other.taxId == taxId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,ownerFirstName,ownerLastName,const DeepCollectionEquality().hash(openDays),opensAt,closesAt,addressLine1,addressLine2,city,region,postalCode,countryCode,subtenant,yearsAtLocation,monthsAtLocation,businessProperty,residentialProperty,yearsAtResidence,monthsAtResidence,businessLandlordName,businessLandlordPhoneCountry,businessLandlordPhoneNumber,residentialLandlordName,residentialLandlordPhoneCountry,residentialLandlordPhoneNumber,bankName,taxDesignation,taxId]);

@override
String toString() {
  return 'Step1BusinessData(ownerFirstName: $ownerFirstName, ownerLastName: $ownerLastName, openDays: $openDays, opensAt: $opensAt, closesAt: $closesAt, addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, region: $region, postalCode: $postalCode, countryCode: $countryCode, subtenant: $subtenant, yearsAtLocation: $yearsAtLocation, monthsAtLocation: $monthsAtLocation, businessProperty: $businessProperty, residentialProperty: $residentialProperty, yearsAtResidence: $yearsAtResidence, monthsAtResidence: $monthsAtResidence, businessLandlordName: $businessLandlordName, businessLandlordPhoneCountry: $businessLandlordPhoneCountry, businessLandlordPhoneNumber: $businessLandlordPhoneNumber, residentialLandlordName: $residentialLandlordName, residentialLandlordPhoneCountry: $residentialLandlordPhoneCountry, residentialLandlordPhoneNumber: $residentialLandlordPhoneNumber, bankName: $bankName, taxDesignation: $taxDesignation, taxId: $taxId)';
}


}

/// @nodoc
abstract mixin class $Step1BusinessDataCopyWith<$Res>  {
  factory $Step1BusinessDataCopyWith(Step1BusinessData value, $Res Function(Step1BusinessData) _then) = _$Step1BusinessDataCopyWithImpl;
@useResult
$Res call({
 String? ownerFirstName, String? ownerLastName, List<int> openDays, int? opensAt, int? closesAt, String? addressLine1, String? addressLine2, String? city, String? region, String? postalCode, String countryCode, bool subtenant, int? yearsAtLocation, int? monthsAtLocation, PropertyStatus? businessProperty, PropertyStatus? residentialProperty, int? yearsAtResidence, int? monthsAtResidence, String? businessLandlordName, String businessLandlordPhoneCountry, String? businessLandlordPhoneNumber, String? residentialLandlordName, String residentialLandlordPhoneCountry, String? residentialLandlordPhoneNumber, String? bankName, TaxDesignation? taxDesignation, String? taxId
});




}
/// @nodoc
class _$Step1BusinessDataCopyWithImpl<$Res>
    implements $Step1BusinessDataCopyWith<$Res> {
  _$Step1BusinessDataCopyWithImpl(this._self, this._then);

  final Step1BusinessData _self;
  final $Res Function(Step1BusinessData) _then;

/// Create a copy of Step1BusinessData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ownerFirstName = freezed,Object? ownerLastName = freezed,Object? openDays = null,Object? opensAt = freezed,Object? closesAt = freezed,Object? addressLine1 = freezed,Object? addressLine2 = freezed,Object? city = freezed,Object? region = freezed,Object? postalCode = freezed,Object? countryCode = null,Object? subtenant = null,Object? yearsAtLocation = freezed,Object? monthsAtLocation = freezed,Object? businessProperty = freezed,Object? residentialProperty = freezed,Object? yearsAtResidence = freezed,Object? monthsAtResidence = freezed,Object? businessLandlordName = freezed,Object? businessLandlordPhoneCountry = null,Object? businessLandlordPhoneNumber = freezed,Object? residentialLandlordName = freezed,Object? residentialLandlordPhoneCountry = null,Object? residentialLandlordPhoneNumber = freezed,Object? bankName = freezed,Object? taxDesignation = freezed,Object? taxId = freezed,}) {
  return _then(_self.copyWith(
ownerFirstName: freezed == ownerFirstName ? _self.ownerFirstName : ownerFirstName // ignore: cast_nullable_to_non_nullable
as String?,ownerLastName: freezed == ownerLastName ? _self.ownerLastName : ownerLastName // ignore: cast_nullable_to_non_nullable
as String?,openDays: null == openDays ? _self.openDays : openDays // ignore: cast_nullable_to_non_nullable
as List<int>,opensAt: freezed == opensAt ? _self.opensAt : opensAt // ignore: cast_nullable_to_non_nullable
as int?,closesAt: freezed == closesAt ? _self.closesAt : closesAt // ignore: cast_nullable_to_non_nullable
as int?,addressLine1: freezed == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String?,addressLine2: freezed == addressLine2 ? _self.addressLine2 : addressLine2 // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,subtenant: null == subtenant ? _self.subtenant : subtenant // ignore: cast_nullable_to_non_nullable
as bool,yearsAtLocation: freezed == yearsAtLocation ? _self.yearsAtLocation : yearsAtLocation // ignore: cast_nullable_to_non_nullable
as int?,monthsAtLocation: freezed == monthsAtLocation ? _self.monthsAtLocation : monthsAtLocation // ignore: cast_nullable_to_non_nullable
as int?,businessProperty: freezed == businessProperty ? _self.businessProperty : businessProperty // ignore: cast_nullable_to_non_nullable
as PropertyStatus?,residentialProperty: freezed == residentialProperty ? _self.residentialProperty : residentialProperty // ignore: cast_nullable_to_non_nullable
as PropertyStatus?,yearsAtResidence: freezed == yearsAtResidence ? _self.yearsAtResidence : yearsAtResidence // ignore: cast_nullable_to_non_nullable
as int?,monthsAtResidence: freezed == monthsAtResidence ? _self.monthsAtResidence : monthsAtResidence // ignore: cast_nullable_to_non_nullable
as int?,businessLandlordName: freezed == businessLandlordName ? _self.businessLandlordName : businessLandlordName // ignore: cast_nullable_to_non_nullable
as String?,businessLandlordPhoneCountry: null == businessLandlordPhoneCountry ? _self.businessLandlordPhoneCountry : businessLandlordPhoneCountry // ignore: cast_nullable_to_non_nullable
as String,businessLandlordPhoneNumber: freezed == businessLandlordPhoneNumber ? _self.businessLandlordPhoneNumber : businessLandlordPhoneNumber // ignore: cast_nullable_to_non_nullable
as String?,residentialLandlordName: freezed == residentialLandlordName ? _self.residentialLandlordName : residentialLandlordName // ignore: cast_nullable_to_non_nullable
as String?,residentialLandlordPhoneCountry: null == residentialLandlordPhoneCountry ? _self.residentialLandlordPhoneCountry : residentialLandlordPhoneCountry // ignore: cast_nullable_to_non_nullable
as String,residentialLandlordPhoneNumber: freezed == residentialLandlordPhoneNumber ? _self.residentialLandlordPhoneNumber : residentialLandlordPhoneNumber // ignore: cast_nullable_to_non_nullable
as String?,bankName: freezed == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String?,taxDesignation: freezed == taxDesignation ? _self.taxDesignation : taxDesignation // ignore: cast_nullable_to_non_nullable
as TaxDesignation?,taxId: freezed == taxId ? _self.taxId : taxId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Step1BusinessData].
extension Step1BusinessDataPatterns on Step1BusinessData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Step1BusinessData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Step1BusinessData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Step1BusinessData value)  $default,){
final _that = this;
switch (_that) {
case _Step1BusinessData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Step1BusinessData value)?  $default,){
final _that = this;
switch (_that) {
case _Step1BusinessData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? ownerFirstName,  String? ownerLastName,  List<int> openDays,  int? opensAt,  int? closesAt,  String? addressLine1,  String? addressLine2,  String? city,  String? region,  String? postalCode,  String countryCode,  bool subtenant,  int? yearsAtLocation,  int? monthsAtLocation,  PropertyStatus? businessProperty,  PropertyStatus? residentialProperty,  int? yearsAtResidence,  int? monthsAtResidence,  String? businessLandlordName,  String businessLandlordPhoneCountry,  String? businessLandlordPhoneNumber,  String? residentialLandlordName,  String residentialLandlordPhoneCountry,  String? residentialLandlordPhoneNumber,  String? bankName,  TaxDesignation? taxDesignation,  String? taxId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Step1BusinessData() when $default != null:
return $default(_that.ownerFirstName,_that.ownerLastName,_that.openDays,_that.opensAt,_that.closesAt,_that.addressLine1,_that.addressLine2,_that.city,_that.region,_that.postalCode,_that.countryCode,_that.subtenant,_that.yearsAtLocation,_that.monthsAtLocation,_that.businessProperty,_that.residentialProperty,_that.yearsAtResidence,_that.monthsAtResidence,_that.businessLandlordName,_that.businessLandlordPhoneCountry,_that.businessLandlordPhoneNumber,_that.residentialLandlordName,_that.residentialLandlordPhoneCountry,_that.residentialLandlordPhoneNumber,_that.bankName,_that.taxDesignation,_that.taxId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? ownerFirstName,  String? ownerLastName,  List<int> openDays,  int? opensAt,  int? closesAt,  String? addressLine1,  String? addressLine2,  String? city,  String? region,  String? postalCode,  String countryCode,  bool subtenant,  int? yearsAtLocation,  int? monthsAtLocation,  PropertyStatus? businessProperty,  PropertyStatus? residentialProperty,  int? yearsAtResidence,  int? monthsAtResidence,  String? businessLandlordName,  String businessLandlordPhoneCountry,  String? businessLandlordPhoneNumber,  String? residentialLandlordName,  String residentialLandlordPhoneCountry,  String? residentialLandlordPhoneNumber,  String? bankName,  TaxDesignation? taxDesignation,  String? taxId)  $default,) {final _that = this;
switch (_that) {
case _Step1BusinessData():
return $default(_that.ownerFirstName,_that.ownerLastName,_that.openDays,_that.opensAt,_that.closesAt,_that.addressLine1,_that.addressLine2,_that.city,_that.region,_that.postalCode,_that.countryCode,_that.subtenant,_that.yearsAtLocation,_that.monthsAtLocation,_that.businessProperty,_that.residentialProperty,_that.yearsAtResidence,_that.monthsAtResidence,_that.businessLandlordName,_that.businessLandlordPhoneCountry,_that.businessLandlordPhoneNumber,_that.residentialLandlordName,_that.residentialLandlordPhoneCountry,_that.residentialLandlordPhoneNumber,_that.bankName,_that.taxDesignation,_that.taxId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? ownerFirstName,  String? ownerLastName,  List<int> openDays,  int? opensAt,  int? closesAt,  String? addressLine1,  String? addressLine2,  String? city,  String? region,  String? postalCode,  String countryCode,  bool subtenant,  int? yearsAtLocation,  int? monthsAtLocation,  PropertyStatus? businessProperty,  PropertyStatus? residentialProperty,  int? yearsAtResidence,  int? monthsAtResidence,  String? businessLandlordName,  String businessLandlordPhoneCountry,  String? businessLandlordPhoneNumber,  String? residentialLandlordName,  String residentialLandlordPhoneCountry,  String? residentialLandlordPhoneNumber,  String? bankName,  TaxDesignation? taxDesignation,  String? taxId)?  $default,) {final _that = this;
switch (_that) {
case _Step1BusinessData() when $default != null:
return $default(_that.ownerFirstName,_that.ownerLastName,_that.openDays,_that.opensAt,_that.closesAt,_that.addressLine1,_that.addressLine2,_that.city,_that.region,_that.postalCode,_that.countryCode,_that.subtenant,_that.yearsAtLocation,_that.monthsAtLocation,_that.businessProperty,_that.residentialProperty,_that.yearsAtResidence,_that.monthsAtResidence,_that.businessLandlordName,_that.businessLandlordPhoneCountry,_that.businessLandlordPhoneNumber,_that.residentialLandlordName,_that.residentialLandlordPhoneCountry,_that.residentialLandlordPhoneNumber,_that.bankName,_that.taxDesignation,_that.taxId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Step1BusinessData extends Step1BusinessData {
  const _Step1BusinessData({this.ownerFirstName, this.ownerLastName, final  List<int> openDays = const <int>[], this.opensAt, this.closesAt, this.addressLine1, this.addressLine2, this.city, this.region, this.postalCode, this.countryCode = 'US', this.subtenant = false, this.yearsAtLocation, this.monthsAtLocation, this.businessProperty, this.residentialProperty, this.yearsAtResidence, this.monthsAtResidence, this.businessLandlordName, this.businessLandlordPhoneCountry = 'US', this.businessLandlordPhoneNumber, this.residentialLandlordName, this.residentialLandlordPhoneCountry = 'US', this.residentialLandlordPhoneNumber, this.bankName, this.taxDesignation, this.taxId}): _openDays = openDays,super._();
  factory _Step1BusinessData.fromJson(Map<String, dynamic> json) => _$Step1BusinessDataFromJson(json);

/// Primary owner (backend `primaryOwner`, always `INDIVIDUAL`). They are
/// partner 1 in Step 2.
@override final  String? ownerFirstName;
@override final  String? ownerLastName;
/// ISO weekdays: 1 = Monday ... 7 = Sunday.
 final  List<int> _openDays;
/// ISO weekdays: 1 = Monday ... 7 = Sunday.
@override@JsonKey() List<int> get openDays {
  if (_openDays is EqualUnmodifiableListView) return _openDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_openDays);
}

/// Minutes since midnight.
@override final  int? opensAt;
@override final  int? closesAt;
// Business location address. Backend requires line 1, city and country.
@override final  String? addressLine1;
@override final  String? addressLine2;
@override final  String? city;
@override final  String? region;
@override final  String? postalCode;
@override@JsonKey() final  String countryCode;
/// The business subleases its space (backend `subtenant`). Step 2 then
/// asks for the sublease agreement.
@override@JsonKey() final  bool subtenant;
@override final  int? yearsAtLocation;
@override final  int? monthsAtLocation;
@override final  PropertyStatus? businessProperty;
@override final  PropertyStatus? residentialProperty;
/// Optional (backend `monthsAtResidence`).
@override final  int? yearsAtResidence;
@override final  int? monthsAtResidence;
// Landlords are only used while the matching property is leased. Kept
// (but hidden) if the user switches to "Own", so a mis-tap doesn't lose
// their input.
// TODO(review): leave them out of the submission when not leased.
@override final  String? businessLandlordName;
@override@JsonKey() final  String businessLandlordPhoneCountry;
@override final  String? businessLandlordPhoneNumber;
@override final  String? residentialLandlordName;
@override@JsonKey() final  String residentialLandlordPhoneCountry;
@override final  String? residentialLandlordPhoneNumber;
// TODO(backend): switch to a searchable list if the API provides banks.
@override final  String? bankName;
@override final  TaxDesignation? taxDesignation;
/// EIN or SSN digits only, no dashes. Which one depends on
/// [taxDesignation]. Cleared when that changes kind.
@override final  String? taxId;

/// Create a copy of Step1BusinessData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$Step1BusinessDataCopyWith<_Step1BusinessData> get copyWith => __$Step1BusinessDataCopyWithImpl<_Step1BusinessData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$Step1BusinessDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Step1BusinessData&&(identical(other.ownerFirstName, ownerFirstName) || other.ownerFirstName == ownerFirstName)&&(identical(other.ownerLastName, ownerLastName) || other.ownerLastName == ownerLastName)&&const DeepCollectionEquality().equals(other._openDays, _openDays)&&(identical(other.opensAt, opensAt) || other.opensAt == opensAt)&&(identical(other.closesAt, closesAt) || other.closesAt == closesAt)&&(identical(other.addressLine1, addressLine1) || other.addressLine1 == addressLine1)&&(identical(other.addressLine2, addressLine2) || other.addressLine2 == addressLine2)&&(identical(other.city, city) || other.city == city)&&(identical(other.region, region) || other.region == region)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.countryCode, countryCode) || other.countryCode == countryCode)&&(identical(other.subtenant, subtenant) || other.subtenant == subtenant)&&(identical(other.yearsAtLocation, yearsAtLocation) || other.yearsAtLocation == yearsAtLocation)&&(identical(other.monthsAtLocation, monthsAtLocation) || other.monthsAtLocation == monthsAtLocation)&&(identical(other.businessProperty, businessProperty) || other.businessProperty == businessProperty)&&(identical(other.residentialProperty, residentialProperty) || other.residentialProperty == residentialProperty)&&(identical(other.yearsAtResidence, yearsAtResidence) || other.yearsAtResidence == yearsAtResidence)&&(identical(other.monthsAtResidence, monthsAtResidence) || other.monthsAtResidence == monthsAtResidence)&&(identical(other.businessLandlordName, businessLandlordName) || other.businessLandlordName == businessLandlordName)&&(identical(other.businessLandlordPhoneCountry, businessLandlordPhoneCountry) || other.businessLandlordPhoneCountry == businessLandlordPhoneCountry)&&(identical(other.businessLandlordPhoneNumber, businessLandlordPhoneNumber) || other.businessLandlordPhoneNumber == businessLandlordPhoneNumber)&&(identical(other.residentialLandlordName, residentialLandlordName) || other.residentialLandlordName == residentialLandlordName)&&(identical(other.residentialLandlordPhoneCountry, residentialLandlordPhoneCountry) || other.residentialLandlordPhoneCountry == residentialLandlordPhoneCountry)&&(identical(other.residentialLandlordPhoneNumber, residentialLandlordPhoneNumber) || other.residentialLandlordPhoneNumber == residentialLandlordPhoneNumber)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.taxDesignation, taxDesignation) || other.taxDesignation == taxDesignation)&&(identical(other.taxId, taxId) || other.taxId == taxId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,ownerFirstName,ownerLastName,const DeepCollectionEquality().hash(_openDays),opensAt,closesAt,addressLine1,addressLine2,city,region,postalCode,countryCode,subtenant,yearsAtLocation,monthsAtLocation,businessProperty,residentialProperty,yearsAtResidence,monthsAtResidence,businessLandlordName,businessLandlordPhoneCountry,businessLandlordPhoneNumber,residentialLandlordName,residentialLandlordPhoneCountry,residentialLandlordPhoneNumber,bankName,taxDesignation,taxId]);

@override
String toString() {
  return 'Step1BusinessData(ownerFirstName: $ownerFirstName, ownerLastName: $ownerLastName, openDays: $openDays, opensAt: $opensAt, closesAt: $closesAt, addressLine1: $addressLine1, addressLine2: $addressLine2, city: $city, region: $region, postalCode: $postalCode, countryCode: $countryCode, subtenant: $subtenant, yearsAtLocation: $yearsAtLocation, monthsAtLocation: $monthsAtLocation, businessProperty: $businessProperty, residentialProperty: $residentialProperty, yearsAtResidence: $yearsAtResidence, monthsAtResidence: $monthsAtResidence, businessLandlordName: $businessLandlordName, businessLandlordPhoneCountry: $businessLandlordPhoneCountry, businessLandlordPhoneNumber: $businessLandlordPhoneNumber, residentialLandlordName: $residentialLandlordName, residentialLandlordPhoneCountry: $residentialLandlordPhoneCountry, residentialLandlordPhoneNumber: $residentialLandlordPhoneNumber, bankName: $bankName, taxDesignation: $taxDesignation, taxId: $taxId)';
}


}

/// @nodoc
abstract mixin class _$Step1BusinessDataCopyWith<$Res> implements $Step1BusinessDataCopyWith<$Res> {
  factory _$Step1BusinessDataCopyWith(_Step1BusinessData value, $Res Function(_Step1BusinessData) _then) = __$Step1BusinessDataCopyWithImpl;
@override @useResult
$Res call({
 String? ownerFirstName, String? ownerLastName, List<int> openDays, int? opensAt, int? closesAt, String? addressLine1, String? addressLine2, String? city, String? region, String? postalCode, String countryCode, bool subtenant, int? yearsAtLocation, int? monthsAtLocation, PropertyStatus? businessProperty, PropertyStatus? residentialProperty, int? yearsAtResidence, int? monthsAtResidence, String? businessLandlordName, String businessLandlordPhoneCountry, String? businessLandlordPhoneNumber, String? residentialLandlordName, String residentialLandlordPhoneCountry, String? residentialLandlordPhoneNumber, String? bankName, TaxDesignation? taxDesignation, String? taxId
});




}
/// @nodoc
class __$Step1BusinessDataCopyWithImpl<$Res>
    implements _$Step1BusinessDataCopyWith<$Res> {
  __$Step1BusinessDataCopyWithImpl(this._self, this._then);

  final _Step1BusinessData _self;
  final $Res Function(_Step1BusinessData) _then;

/// Create a copy of Step1BusinessData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ownerFirstName = freezed,Object? ownerLastName = freezed,Object? openDays = null,Object? opensAt = freezed,Object? closesAt = freezed,Object? addressLine1 = freezed,Object? addressLine2 = freezed,Object? city = freezed,Object? region = freezed,Object? postalCode = freezed,Object? countryCode = null,Object? subtenant = null,Object? yearsAtLocation = freezed,Object? monthsAtLocation = freezed,Object? businessProperty = freezed,Object? residentialProperty = freezed,Object? yearsAtResidence = freezed,Object? monthsAtResidence = freezed,Object? businessLandlordName = freezed,Object? businessLandlordPhoneCountry = null,Object? businessLandlordPhoneNumber = freezed,Object? residentialLandlordName = freezed,Object? residentialLandlordPhoneCountry = null,Object? residentialLandlordPhoneNumber = freezed,Object? bankName = freezed,Object? taxDesignation = freezed,Object? taxId = freezed,}) {
  return _then(_Step1BusinessData(
ownerFirstName: freezed == ownerFirstName ? _self.ownerFirstName : ownerFirstName // ignore: cast_nullable_to_non_nullable
as String?,ownerLastName: freezed == ownerLastName ? _self.ownerLastName : ownerLastName // ignore: cast_nullable_to_non_nullable
as String?,openDays: null == openDays ? _self._openDays : openDays // ignore: cast_nullable_to_non_nullable
as List<int>,opensAt: freezed == opensAt ? _self.opensAt : opensAt // ignore: cast_nullable_to_non_nullable
as int?,closesAt: freezed == closesAt ? _self.closesAt : closesAt // ignore: cast_nullable_to_non_nullable
as int?,addressLine1: freezed == addressLine1 ? _self.addressLine1 : addressLine1 // ignore: cast_nullable_to_non_nullable
as String?,addressLine2: freezed == addressLine2 ? _self.addressLine2 : addressLine2 // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,countryCode: null == countryCode ? _self.countryCode : countryCode // ignore: cast_nullable_to_non_nullable
as String,subtenant: null == subtenant ? _self.subtenant : subtenant // ignore: cast_nullable_to_non_nullable
as bool,yearsAtLocation: freezed == yearsAtLocation ? _self.yearsAtLocation : yearsAtLocation // ignore: cast_nullable_to_non_nullable
as int?,monthsAtLocation: freezed == monthsAtLocation ? _self.monthsAtLocation : monthsAtLocation // ignore: cast_nullable_to_non_nullable
as int?,businessProperty: freezed == businessProperty ? _self.businessProperty : businessProperty // ignore: cast_nullable_to_non_nullable
as PropertyStatus?,residentialProperty: freezed == residentialProperty ? _self.residentialProperty : residentialProperty // ignore: cast_nullable_to_non_nullable
as PropertyStatus?,yearsAtResidence: freezed == yearsAtResidence ? _self.yearsAtResidence : yearsAtResidence // ignore: cast_nullable_to_non_nullable
as int?,monthsAtResidence: freezed == monthsAtResidence ? _self.monthsAtResidence : monthsAtResidence // ignore: cast_nullable_to_non_nullable
as int?,businessLandlordName: freezed == businessLandlordName ? _self.businessLandlordName : businessLandlordName // ignore: cast_nullable_to_non_nullable
as String?,businessLandlordPhoneCountry: null == businessLandlordPhoneCountry ? _self.businessLandlordPhoneCountry : businessLandlordPhoneCountry // ignore: cast_nullable_to_non_nullable
as String,businessLandlordPhoneNumber: freezed == businessLandlordPhoneNumber ? _self.businessLandlordPhoneNumber : businessLandlordPhoneNumber // ignore: cast_nullable_to_non_nullable
as String?,residentialLandlordName: freezed == residentialLandlordName ? _self.residentialLandlordName : residentialLandlordName // ignore: cast_nullable_to_non_nullable
as String?,residentialLandlordPhoneCountry: null == residentialLandlordPhoneCountry ? _self.residentialLandlordPhoneCountry : residentialLandlordPhoneCountry // ignore: cast_nullable_to_non_nullable
as String,residentialLandlordPhoneNumber: freezed == residentialLandlordPhoneNumber ? _self.residentialLandlordPhoneNumber : residentialLandlordPhoneNumber // ignore: cast_nullable_to_non_nullable
as String?,bankName: freezed == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String?,taxDesignation: freezed == taxDesignation ? _self.taxDesignation : taxDesignation // ignore: cast_nullable_to_non_nullable
as TaxDesignation?,taxId: freezed == taxId ? _self.taxId : taxId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
