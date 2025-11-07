class ViolationType {
  String? violation_id;
  String? violation_name;
  int? deduct_score;

  ViolationType({this.violation_id, this.violation_name, this.deduct_score});

  Map<String, dynamic> fromViolationTypeToJson() {
    return <String, dynamic>{
      'violation_id': violation_id,
      'violation_name': violation_name,
      'deduct_score': deduct_score,
    };
  }

  factory ViolationType.fromJsonToViolationType(Map<String, dynamic> json) =>
      ViolationType(
          violation_id: json['violation_id'],
          violation_name: json['violation_name'],
          deduct_score: json['deduct_score']);
}
