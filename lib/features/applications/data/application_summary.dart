import '../../onboarding/data/models/application_status.dart';

/// One row of the account's application list (backend
/// `GET /api/v1/partner/applications`).
class ApplicationSummary {
  const ApplicationSummary({
    required this.id,
    required this.businessName,
    this.applicationNumber,
    this.status,
    this.createdAt,
  });

  /// Reads a list item. The list returns the status as a display label
  /// ("Action Required"), and `hasOpenCorrections` also means action needed.
  factory ApplicationSummary.fromJson(Map<String, dynamic> json) {
    final corrections = json['hasOpenCorrections'] == true;
    return ApplicationSummary(
      id: json['id'] as String,
      businessName: (json['businessName'] as String?) ?? '',
      applicationNumber: json['applicationNumber'] as String?,
      status: corrections
          ? ApplicationStatus.actionRequired
          : ApplicationStatus.fromApi(json['status'] as String?),
      createdAt: DateTime.tryParse('${json['createdAt'] ?? ''}'),
    );
  }

  final String id;
  final String businessName;
  final String? applicationNumber;

  /// Null when the backend sends a status this app doesn't know.
  final ApplicationStatus? status;
  final DateTime? createdAt;

  /// Sent for review (or decided): opening it shows the status screen,
  /// not the wizard.
  bool get isSubmitted => switch (status) {
    ApplicationStatus.draft || ApplicationStatus.inProgress || null => false,
    _ => true,
  };
}
