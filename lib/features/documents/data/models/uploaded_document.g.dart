// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uploaded_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UploadedDocument _$UploadedDocumentFromJson(Map<String, dynamic> json) =>
    _UploadedDocument(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      mimeType: json['mimeType'] as String,
      sizeBytes: (json['sizeBytes'] as num).toInt(),
    );

Map<String, dynamic> _$UploadedDocumentToJson(_UploadedDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fileName': instance.fileName,
      'mimeType': instance.mimeType,
      'sizeBytes': instance.sizeBytes,
    };
