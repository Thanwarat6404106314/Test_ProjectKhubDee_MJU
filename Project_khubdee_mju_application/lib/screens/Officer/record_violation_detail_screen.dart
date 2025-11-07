import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_final/model/officer.dart';
import 'package:project_final/model/student.dart';
import 'package:project_final/screens/home_screen.dart';

class RecordViolationDetailScreen extends StatelessWidget {
  final Student student;
  final String recordViolationId;
  final String location;
  final String recordDate;
  final File pictureEvidence;
  final String violationType;

  const RecordViolationDetailScreen({
    super.key,
    required this.student,
    required this.recordViolationId,
    required this.location,
    required this.recordDate,
    required this.pictureEvidence,
    required this.violationType, 
    Officer? officer,
  });

  @override
  Widget build(BuildContext context) {
    // แปลงวันที่ที่ส่งมาเป็น DateTime
    final DateTime parsedDateTime =
        DateFormat('dd/MM/yyyy HH:mm:ss').parse(recordDate);

    // แยกวันที่และเวลาในรูปแบบที่ต้องการ
    final String formetRecDate =
        DateFormat('dd/MM/yyyy').format(parsedDateTime);
    final String formetRecTime = DateFormat('HH:mm').format(parsedDateTime);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายละเอียดการละเมิด',
          style:
              TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Mitr'),
        ),
        backgroundColor: Color(0xFF006D0D),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'บันทึกการละเมิดกฎจราจรสำเร็จ',
              style: TextStyle(
                  fontFamily: 'Mitr',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Divider(
              height: 1,
              color: Color(0xFFCACACA),
            ),
            SizedBox(height: 8),
            buildDetailRow('รหัสนักศึกษา :', '${student.student_id}'),
            buildDetailRow(
                'ชื่อ-นามสกุล :', '${student.firstname} ${student.lastname}'),
            buildDetailRow('คณะ :', '${student.major}'),
            buildDetailRow('สาขา :', '${student.faculty}'),
            buildDetailRow('วันที่ละเมิด :', formetRecDate),
            buildDetailRow('เวลา :', formetRecTime+' น.'),
            buildDetailRow('สถานที่ :', '${location}'),
            buildDetailRow('ประเภทการละเมิด :', '${violationType}'),
            Text('รูปภาพหลักฐาน :',
                style: TextStyle(
                    fontFamily: 'Mitr',
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Container(
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  pictureEvidence,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 18),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false,
                );
              },
              child: Text(
                'กลับสู่หน้าหลัก',
                style: TextStyle(fontFamily: 'Mitr'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF006D0D),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
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
          Expanded(
            flex: 2,
            child: Text(label,
                style: TextStyle(
                    fontFamily: 'Mitr',
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child:
                Text(value, style: TextStyle(fontFamily: 'Mitr', fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
