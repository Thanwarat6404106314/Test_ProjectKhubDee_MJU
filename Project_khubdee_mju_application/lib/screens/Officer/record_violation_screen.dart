import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_final/controller/LocationController.dart';
import 'package:project_final/controller/NotificationsController.dart';
import 'package:project_final/controller/OfficerController.dart';
import 'package:project_final/controller/RecordViolationController.dart';
import 'package:project_final/controller/StudentController.dart';
import 'package:project_final/controller/ViolationTypeController.dart';
import 'package:project_final/model/location.dart';
import 'package:project_final/model/officer.dart';
import 'package:project_final/model/student.dart';
import 'package:project_final/model/violationtype.dart';
import 'package:project_final/screens/Officer/record_violation_detail_screen.dart';
import 'package:project_final/screens/Officer/student_detail_screen.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class RecordViolationScreen extends StatefulWidget {
  final String student_id;

  const RecordViolationScreen({super.key, required this.student_id});

  @override
  State<RecordViolationScreen> createState() => _RecordViolationScreenState();
}

const List<String> listViolationType = <String>[
  'ขับขี่ไม่สวมหมวกกันน็อค',
  'ขับขี่ด้วยความเร็วเกินกำหนด',
  'ขับขี่ย้อนศร',
  'ขับขี่โดยประมาท'
];

const Map<String, String> violationTypeMap = {
  'ขับขี่ไม่สวมหมวกกันน็อค': 'V001',
  'ขับขี่ด้วยความเร็วเกินกำหนด': 'V002',
  'ขับขี่ย้อนศร': 'V003',
  'ขับขี่โดยประมาท': 'V004'
};

class _RecordViolationScreenState extends State<RecordViolationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RecordViolationController recordViolationController =
      RecordViolationController();
  final StudentController studentController = StudentController();
  final NotificationsController notificationsController =
      NotificationsController();
  final OfficerController officerController = OfficerController();
  final LocationController locationController = LocationController();
  final ViolationTypeController violationTypeController =
      ViolationTypeController();

  TextEditingController student_idController = TextEditingController();
  TextEditingController record_dateController = TextEditingController();

  File? _pictureEvidence;

  List<Location> locationList = [];
  String? selectedLocationId;

  List<ViolationType> violationTypeList = [];
  String? selectedViolationTypeId;

  String? email;
  Student? student;
  Officer? officer;

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchLocation();
    fetchVioaltionType();
  }

  void setData() async {
    student_idController.text = widget.student_id;
  }

  void fetchData() async {
    student = await studentController.getStudentById(widget.student_id);
    setState(() {
      setData();
    });

    var emailSession = await SessionManager().get("email");
    print("Email Storage: " + emailSession.toString());
    email = emailSession.toString();
    officer = await officerController.getOfficerByEmail(email ?? "");
    print('Officer ID: ${officer?.officer_id}');
    setState(() {});
  }

  Future<void> fetchLocation() async {
    try {
      List<Location> locations = await locationController.getListLocation();
      setState(() {
        locationList = locations;
        selectedLocationId = locations.isNotEmpty ? locations.first.location_id : null;
      });
    } catch (e) {
      print("Error fetching locations: $e");
    }
  }

  Future<void> fetchVioaltionType() async {
    try {
      List<ViolationType> violationtypes = await violationTypeController.getListViolationType();
      setState(() {
        violationTypeList = violationtypes;
        selectedViolationTypeId = violationtypes.isNotEmpty ? violationtypes.first.violation_id : null;
      });
    } catch (e) {
      print("Error fetching violationtype: $e");
    }
  }

  Future getPicture_Evidence() async {
    final picker = ImagePicker();
    var pictureEvidence = await picker.pickImage(source: ImageSource.gallery);
    if (pictureEvidence != null) {
      File imageFile = File(pictureEvidence.path);
      int fileSize = await imageFile.length();

      if (fileSize < (1 * 1024 * 1024)) {
        setState(() {
          _pictureEvidence = File(pictureEvidence.path);
        });
      } else {
        showFailToUploadImgAlert();
      }
    }
  }

  void showFailToUploadImgAlert() {
    QuickAlert.show(
      context: context,
      title: "เกิดข้อผิดพลาด",
      text: "ไม่สามารถใช้รูปที่มีขนาดมากกว่า 1 MB ได้",
      type: QuickAlertType.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลการละเมิดกฎจราจร',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontFamily: 'Mitr')),
        backgroundColor: Color(0xFF006D0D),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
                return StudentDetaillScreen(student_id: widget.student_id);
              }),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // สถานที่
                buildDropdownLocation(),
                SizedBox(height: 8),
                // วันที่ละเมิดกฎจราจร
                buildRecordDate(),
                SizedBox(height: 8),
                // ประเภทการละเมิด
                buildDropdownViolationType(),
                SizedBox(height: 8),
                // เพิ่มรูปภาพหลักฐาน
                buildEvidenceImage(),
                SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_pictureEvidence == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'กรุณาเพิ่มรูปภาพ',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Mitr'),
                            ),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      } else {
                        if (_formKey.currentState!.validate()) {
                          String recordViolation =
                              await recordViolationController
                                  .addRecordViolation(
                            record_dateController.text,
                            _pictureEvidence!,
                            student_idController.text,
                            officer!.officer_id.toString(),
                            selectedLocationId.toString(),
                            selectedViolationTypeId.toString(),
                          );

                          if (recordViolation.isNotEmpty) {
                            await notificationsController
                                .addNotification(recordViolation);

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    RecordViolationDetailScreen(
                                  student: student!,
                                  recordViolationId: recordViolation,
                                  officer: officer!,
                                  recordDate: record_dateController.text,
                                  pictureEvidence: _pictureEvidence!,
                                  location: locationList
                                      .firstWhere((location) =>
                                          location.location_id ==
                                          selectedLocationId)
                                      .location_name
                                      .toString(),
                                  violationType: violationTypeList
                                      .firstWhere((violationType) =>
                                          violationType.violation_id ==
                                          selectedViolationTypeId)
                                      .violation_name
                                      .toString(),
                                ),
                              ),
                            );
                          }
                        }
                      }
                    },
                    child: Text('ยืนยันข้อมูล'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF006D0D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // วันที่ละเมิดกฎจราจร
  buildRecordDate() {
    record_dateController.text =
        DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('วันที่ละเมิดกฎจราจร', style: TextStyle(fontFamily: 'Mitr')),
        SizedBox(height: 6),
        TextFormField(
          controller: record_dateController,
          readOnly: true, // ป้องกันการแก้ไขข้อมูล
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 14,
            ),
            suffixIcon: Icon(
              Icons.date_range_outlined,
              size: 25.0,
              color: Color(0xFF757575),
            ),
          ),
          style: TextStyle(
              color: Color(0xFF363636), fontSize: 14, fontFamily: 'Mitr'),
        ),
      ],
    );
  }

  // สถานที่
  buildDropdownLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('สถานที่', style: TextStyle(fontFamily: 'Mitr')),
        SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: selectedLocationId,
          onChanged: (String? newValue) {
            setState(() {
              selectedLocationId = newValue!;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณาเลือกสถานที่';
            }
            return null;
          },
          items:
              locationList.map<DropdownMenuItem<String>>((Location location) {
            return DropdownMenuItem<String>(
              value: location.location_id,
              child: Text('${location.location_name}',
                  style: TextStyle(fontSize: 14, fontFamily: 'Mitr')),
            );
          }).toList(),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          ),
        ),
      ],
    );
  }

  // ประเภทการละเมิด
  buildDropdownViolationType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ประเภทการละเมิดกฏจราจร', style: TextStyle(fontFamily: 'Mitr')),
        SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: selectedViolationTypeId,
          onChanged: (String? newValue) {
            setState(() {
              selectedViolationTypeId = newValue!;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'กรุณาเลือกประเภทการละเมิดกฎจราจร';
            }
            return null;
          },
          items:
              violationTypeList.map<DropdownMenuItem<String>>((ViolationType violationType) {
            return DropdownMenuItem<String>(
              value: violationType.violation_id,
              child: Text('${violationType.violation_name}',
                  style: TextStyle(fontSize: 14, fontFamily: 'Mitr')),
            );
          }).toList(),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          ),
        ),
      ],
    );
  }

  // เพิ่มรูปภาพหลักฐาน
  buildEvidenceImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('อัพโหลดหลักฐาน', style: TextStyle(fontFamily: 'Mitr')),
        SizedBox(height: 6),
        GestureDetector(
          onTap: getPicture_Evidence, // คลิกที่ Container เพื่อเลือกรูปภาพ
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20), // กำหนดขอบโค้ง
            ),
            child: _pictureEvidence == null
                ? Center(
                    child: Text('เพิ่มรูปภาพ',
                        style: TextStyle(fontFamily: 'Mitr')))
                : ClipRRect(
                    borderRadius:
                        BorderRadius.circular(20), // ทำให้รูปมีมุมโค้ง
                    child: Image.file(
                      _pictureEvidence!,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
        SizedBox(height: 6),
      ],
    );
  }
}
