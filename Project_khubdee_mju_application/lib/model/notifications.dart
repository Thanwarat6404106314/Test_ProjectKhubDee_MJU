import 'package:project_final/model/recordviolation.dart';

class Notifications {
  String? notification_id;
  DateTime? notification_date;
  String? notification_status;
  String? message;
  String? status_view;
  RecordViolation? recordViolation;

  Notifications({
    this.notification_id,
    this.notification_date,
    this.notification_status,
    this.message,
    this.status_view,
    this.recordViolation,
  });

  Map<String, dynamic> fromNotificationToJson() {
    return <String, dynamic>{
      'notification_id': notification_id,
      'notification_date': notification_date!.toIso8601String(),
      'notification_status': notification_status,
      'message': message,
      'status_view': status_view,
      'record_id': recordViolation?.fromRecordViolationToJson(),
    };
  }

  factory Notifications.fromJsonToNotification(Map<String, dynamic> json) =>
      Notifications(
        notification_id: json['notification_id'],
        notification_date: DateTime.parse(json["notification_date"]).toLocal(),
        notification_status: json['notification_status'],
        message: json['message'],
        status_view: json['status_view'],
        recordViolation:
            RecordViolation.fromJsonToRecordViolation(json["recordViolation"]),
      );
}
