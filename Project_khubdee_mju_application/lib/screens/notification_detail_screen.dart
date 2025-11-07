import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_final/model/notifications.dart';
import 'package:project_final/constants/constant_value.dart';

class NotificationDetailScreen extends StatelessWidget {
  final Notifications notifications;

  const NotificationDetailScreen({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    final recordDate = notifications.recordViolation?.record_date != null
        ? DateFormat('dd/MM/yyyy').format(notifications.notification_date!)
        : "ไม่ทราบวันที่";
    final recordTime = notifications.recordViolation?.record_date != null
        ? DateFormat('HH:mm').format(notifications.notification_date!)
        : "ไม่ทราบเวลา";

    const String imageURL = baseURL + "/picture_evidence/";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รายละเอียดการแจ้งเตือน',
          style:
              TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Mitr'),
        ),
        backgroundColor: Color(0xFF006D0D),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shadowColor: Color.fromARGB(255, 4, 116, 0),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'รายละเอียด',
                        style: TextStyle(
                            fontFamily: 'Mitr',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Divider(height: 1, color: Color(0xFFCACACA)),
                      SizedBox(height: 8),
                      buildDetailRow('รหัสนักศึกษา :','${notifications.recordViolation!.student?.student_id}'),
                      SizedBox(height: 8),
                      buildDetailRow('ชื่อ :','${notifications.recordViolation!.student?.firstname} ${notifications.recordViolation!.student?.lastname}'),
                      SizedBox(height: 8),
                      buildDetailRow('คณะ :','${notifications.recordViolation!.student?.faculty}'),
                      SizedBox(height: 8),
                      buildDetailRow('สาขา :','${notifications.recordViolation!.student?.major}'),
                      SizedBox(height: 8),
                      buildDetailRow('วันที่ละเมิดกฎจราจร :', recordDate),
                      SizedBox(height: 8),
                      buildDetailRow('ช่วงเวลา :', '${recordTime} น.'),
                      SizedBox(height: 8),
                      buildDetailRow('สถานที่ :','${notifications.recordViolation!.location?.location_name}'),
                      SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildDetailRow(
                            'สถานะดำเนินการ :',
                            notifications.notification_status ==
                                    'อนุมัติหักคะแนนพฤติกรรม'
                                ? 'อนุมัติหักคะแนนพฤติกรรม'
                                : notifications.notification_status ??
                                    '',
                          ),
                          if (notifications.notification_status == 'อนุมัติหักคะแนนพฤติกรรม')
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildDetailRow('คะแนนที่ถูกหัก :',
                                      '${notifications.recordViolation?.violationType?.deduct_score} คะแนน'),
                                  SizedBox(height: 8),
                                  buildDetailRow('คะแนนคงเหลือ :',
                                      '${notifications.recordViolation!.student?.student_score} คะแนน'),
                                ],
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                          'รูปภาพหลักฐานการละเมิดกฎจราจร:',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Mitr',
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            '$imageURL${notifications.recordViolation?.picture_evidence}',
                            width: double.infinity,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
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
              fontSize: 13,
              fontFamily: 'Mitr',
              fontWeight: FontWeight.normal,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
