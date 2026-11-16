import 'package:freezed_annotation/freezed_annotation.dart';

part 'step3_compliance_data.freezed.dart';
part 'step3_compliance_data.g.dart';

/// A person who will process transactions. Used for system user setup,
/// passwords, and compliance training. Backend staff role
/// `TRANSACTION_PROCESSOR` (email and phone are optional there; not asked).
@freezed
abstract class TransactionProcessor with _$TransactionProcessor {
  const factory TransactionProcessor({
    /// Local id used to tell entries apart on the device. Not sent.
    required String id,

    /// Personal data: never log it.
    String? firstName,
    String? lastName,
  }) = _TransactionProcessor;

  factory TransactionProcessor.fromJson(Map<String, dynamic> json) =>
      _$TransactionProcessorFromJson(json);
}

/// Step 3 answers. Everything is nullable because the draft is saved while
/// the user is still filling it in.
@freezed
abstract class Step3ComplianceData with _$Step3ComplianceData {
  const factory Step3ComplianceData({
    /// At least one.
    @Default([TransactionProcessor(id: Step3ComplianceData.firstProcessorId)])
    List<TransactionProcessor> processors,

    /// The Step 1 owner is the Compliance Officer (sent with their
    /// `businessOwnerId`).
    @Default(true) bool complianceOfficerIsOwner,

    // Kept (but hidden) if the toggle is turned back on.
    // TODO(review): leave them out of the submission when the owner is the
    // officer, and send the owner instead.
    String? complianceOfficerFirstName,
    String? complianceOfficerLastName,
  }) = _Step3ComplianceData;

  const Step3ComplianceData._();

  factory Step3ComplianceData.fromJson(Map<String, dynamic> json) =>
      _$Step3ComplianceDataFromJson(json);

  static const firstProcessorId = 'processor-1';

  Step3ComplianceData withProcessorAdded(String id) => copyWith(
    processors: [
      ...processors,
      TransactionProcessor(id: id),
    ],
  );

  Step3ComplianceData withProcessorRemoved(String id) =>
      copyWith(processors: [...processors.where((p) => p.id != id)]);

  Step3ComplianceData withProcessorUpdated(
    String id,
    TransactionProcessor Function(TransactionProcessor processor) change,
  ) => copyWith(
    processors: [for (final p in processors) p.id == id ? change(p) : p],
  );
}
