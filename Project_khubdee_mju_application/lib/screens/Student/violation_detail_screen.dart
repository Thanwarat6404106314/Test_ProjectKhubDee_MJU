import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_final/constants/constant_value.dart';
import 'package:project_final/model/recordviolation.dart';

class ViolationDetailScreen extends StatelessWidget {
  final RecordViolation recordViolation;

  const ViolationDetailScreen({super.key, required this.recordViolation});

  @override
  Widget build(BuildContext context) {
    final recordDate = DateFormat('dd/MM/yyyy')
        .format(recordViolation.record_date ?? DateTime.now());
    final recordTime = DateFormat('HH:mm')
        .format(recordViolation.record_date ?? DateTime.now());
    final deductDate = DateFormat('dd/MM/yyyy')
        .format(recordViolation.deduct_date ?? DateTime.now());

    const String imageURL = baseURL + "/picture_evidence/";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายละเอียดการละเมิดกฎจราจร',
          style:
              TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Mitr'),
        ),
        backgroundColor: Color(0xFF006D0D),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shadowColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'ข้อมูลการละเมิดกฎจราจร',
                    style: TextStyle(
                      fontFamily: 'Mitr',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Divider(height: 1, color: Colors.grey[300]),
                SizedBox(height: 16),
                buildDetailRow('ชื่อ:',
                    '${recordViolation.student?.firstname} ${recordViolation.student?.lastname}'),
                buildDetailRow(
                    'รหัสนักศึกษา:', '${recordViolation.student?.student_id}'),
                buildDetailRow('วันที่ละเมิด:', recordDate),
                buildDetailRow('เวลา:', recordTime + ' น.'),
                buildDetailRow('สถานที่:', '${recordViolation.location?.location_name}'),
                buildDetailRow('การละเมิด:',
                    '${recordViolation.violationType?.violation_name}'),
                if (recordViolation.status_type != null)
                  buildDetailRow('สถานะ:', '${recordViolation.status_type}'),
                // เงื่อนไข: หากสถานะเป็น "อนุมัติหักคะแนนพฤติกรรม" ให้แสดง deduct_date
                if (recordViolation.status_type == 'อนุมัติหักคะแนนพฤติกรรม')
                  buildDetailRow('วันที่หักคะแนน:', deductDate),
                if (recordViolation.picture_evidence != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'รูปภาพหลักฐาน:',
                        style: TextStyle(
                          fontFamily: 'Mitr',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          '$imageURL${recordViolation.picture_evidence}',
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Mitr',
            fontWeight: FontWeight.bold,
            color: Colors.green[800],
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Mitr',
              color: Colors.black87,
            ),
            softWrap: true, // อนุญาตให้ข้อความลงบรรทัดใหม่
          ),
        ),
      ],
    ),
  );
}

}
