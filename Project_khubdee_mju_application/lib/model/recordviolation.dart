import 'package:project_final/model/location.dart';
import 'package:project_final/model/officer.dart';
import 'package:project_final/model/student.dart';
import 'package:project_final/model/violationtype.dart';

class RecordViolation {
  String? record_id;
  Student? student;
  DateTime? record_date;
  Officer? officer;
  Location? location;
  ViolationType? violationType;
  int? remaining_score;
  String? picture_evidence;
  String? status_type;
  int? deduct_no;
  DateTime? deduct_date;

  RecordViolation(
      {this.record_id,
      this.student,
      this.record_date,
      this.officer,
      this.location,
      this.violationType,
      this.remaining_score,
      this.picture_evidence,
      this.status_type,
      this.deduct_no,
      this.deduct_date});

  Map<String, dynamic> fromRecordViolationToJson() {
    return <String, dynamic>{
      'record_id': record_id,
      'student': student?.fromStudentToJson(),
      'record_date': record_date!.toIso8601String(),
      'officer': officer?.fromOfficerToJson(),
      'location': location?.fromLocationToJson(),
      'violationType': violationType?.fromViolationTypeToJson(),
      'remaining_score': remaining_score,
      'picture_evidence': picture_evidence,
      'status_type': status_type,
      'deduct_no': deduct_no,
      'deduct_date': deduct_date!.toIso8601String(),
    };
  }

  factory RecordViolation.fromJsonToRecordViolation(
          Map<String, dynamic> json) =>
      RecordViolation(
        record_id: json['record_id'],
        student: Student.fromJsonToStudent(json["student"]),
        record_date: DateTime.parse(json["record_date"]).toLocal(),
        officer: Officer.fromJsonToOfficer(json["officer"]),
        location: Location.fromJsonToLocation(json['location']),
        violationType:
            ViolationType.fromJsonToViolationType(json["violationType"]),
        remaining_score: json['remaining_score'],
        picture_evidence: json['picture_evidence'],
        status_type: json['status_type'],
        deduct_no: json['deduct_no'],
        deduct_date: json['deduct_date'] != null
            ? DateTime.parse(json["deduct_date"]).toLocal()
            : null,
      );
}
