import 'package:flutter/material.dart';
import 'package:project_final/controller/StudentController.dart';
import 'package:project_final/screens/home_screen.dart';
import 'package:project_final/screens/Officer/student_detail_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanStudentIdScreen extends StatefulWidget {
  const ScanStudentIdScreen({super.key});

  @override
  State<ScanStudentIdScreen> createState() => _ScanStudentIdScreenState();
}

class _ScanStudentIdScreenState extends State<ScanStudentIdScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final StudentController studentController = StudentController();
  TextEditingController student_idController = TextEditingController();
  MobileScannerController cameraController = MobileScannerController();
  String scannedCode = '';
  int _selectedIndex = 0;
  bool isNavigating = false; // เพื่อป้องกันการนำทางซ้ำ

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    cameraController.dispose(); // ปิดกล้องเมื่อหน้าจอถูกปิด
    super.dispose();
  }

  void _onDetect(BarcodeCapture barcodeCapture) async {
    if (isNavigating) return; // ป้องกันการนำทางซ้ำ

    final List<Barcode> barcodes = barcodeCapture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null && barcode.rawValue!.isNotEmpty) {
        setState(() {
          scannedCode = barcode.rawValue!;
          isNavigating = true;
        });

        await cameraController.stop();
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentDetaillScreen(
              student_id: scannedCode,
            ),
          ),
        );

        setState(() {
          isNavigating = false;
        });
        await cameraController.start();
        break;
      }
    }
  }

  Widget buildQrView(BuildContext context) {
    return MobileScanner(
      controller: cameraController,
      onDetect: _onDetect,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'บันทึกรหัสนักศึกษา',
          style:
              TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'Mitr'),
        ),
        backgroundColor: Color(0xFF006D0D),
        centerTitle: true,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
                return HomeScreen();
              }),
            );
          },
        ),
      ),
      body:
          _selectedIndex == 0 ? scanStudentIdScreen() : fieldStudentIdScreen(),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle:
            TextStyle(color: Colors.grey[400], fontFamily: 'Mitr'),
        unselectedLabelStyle: TextStyle(color: Colors.grey, fontFamily: 'Mitr'),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'สแกน',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recent_actors_rounded),
            label: 'กรอกรหัส',
          ),
        ],
        backgroundColor: Colors.grey[350],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF006D0D),
        unselectedItemColor: Color(0xFF008910),
        onTap: _onItemTapped,
      ),
    );
  }

  // หน้าจอสแกนรหัสนักศึกษา
  scanStudentIdScreen() {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: buildQrView(context),
          ),
        ],
      ),
    );
  }

  // หน้าจอกรอกรหัสนักศึกษา
  fieldStudentIdScreen() {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildStudentID(),
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // ตรวจสอบข้อมูลในฐานข้อมูล
                      var response = await studentController
                          .getStudentById(student_idController.text);
                      if (response == null) {
                        // แสดง AlertDialog เมื่อไม่พบข้อมูลนักศึกษา
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('ไม่พบข้อมูลนักศึกษา',
                                  style: TextStyle(fontFamily: 'Mitr')),
                              content: Text('กรุณาตรวจสอบรหัสนักศึกษาอีกครั้ง',
                                  style: TextStyle(fontFamily: 'Mitr')),
                              actions: [
                                TextButton(
                                  child: Text('ตกลง',
                                      style: TextStyle(fontFamily: 'Mitr')),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // นำทางไปยัง StudentDetailScreen พร้อมรหัสนักศึกษา
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) {
                            return StudentDetaillScreen(
                              student_id: student_idController.text,
                            );
                          },
                        ));
                      }
                    }
                  },
                  child: Text('ตรวจสอบข้อมูล',
                      style: TextStyle(fontFamily: 'Mitr')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF006D0D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ช่องกรอกรหัสนักศึกษา
  buildStudentID() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('รหัสนักศึกษา', style: TextStyle(fontFamily: 'Mitr')),
        SizedBox(height: 6),
        Container(
          child: TextFormField(
            controller: student_idController,
            keyboardType: TextInputType.number, // เป็นตัวเลขเท่านั้น
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'กรุณากรอกรหัสนักศึกษา';
              }
              // ตรวจสอบว่าเป็นตัวเลข
              else if (!RegExp(r'^\d+$').hasMatch(value)) {
                return 'รหัสนักศึกษาต้องเป็นตัวเลขเท่านั้น';
              }
              // ตรวจสอบความยาว
              else if (value.length < 10 || value.length > 10) {
                return 'รหัสนักศึกษาต้องมีความยาว 10 หลักเท่านั้น';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 14),
            ),
            style: TextStyle(
                color: Color(0xFF363636), fontSize: 13, fontFamily: 'Mitr'),
          ),
        ),
      ],
    );
  }
}
