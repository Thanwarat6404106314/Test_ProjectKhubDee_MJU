import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:project_final/controller/NotificationsController.dart';
import 'package:project_final/controller/StudentController.dart';
import 'package:project_final/model/notifications.dart';
import 'package:project_final/model/student.dart';
import 'package:project_final/screens/notifications_screen.dart';
import 'package:project_final/screens/home_detail_screen.dart';
import 'package:project_final/screens/Officer/officer_profile_screen.dart';
import 'package:project_final/screens/Officer/scan_studentId_screen.dart';
import 'package:project_final/screens/Student/student_profile_screen.dart';
import 'package:project_final/screens/Student/qrcode_screen.dart';
import 'package:project_final/utils/event_bus.dart';
import 'package:project_final/utils/event_class.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? _userType;
  bool _hideBottomNavigationBar = false;
  int unreadCountHome = 0;

  StudentController studentController = StudentController();
  NotificationsController notificationsController = NotificationsController();

  List<Notifications>? notificationList;
  String? email;
  Student? student;
  bool? isLoaded;

  late StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    _loadUserType();
    fetchData();

    
    subscription = eventBus.on<MyEvent>().listen((event) {
      if (event.message == "refresh notification") {
        fetchData();
      }
    });
  }

  Future<void> _loadUserType() async {
    _userType = await SessionManager().get("userType");
    setState(() {
      isLoaded = true;
    });
  }

  void fetchData() async {
    var emailSession = await SessionManager().get("email");
    email = emailSession.toString();

    try {
      if (_userType == 'Student') {
        student = await studentController.getStudentByEmail(email ?? "");
        setState(() {
          isLoaded = true;
        });

        if (student != null) {
          List<Notifications> notifications = await notificationsController
              .getListNotificationsByStudentID(student!.student_id.toString());
          setState(() {
            notificationList = notifications;
            unreadCountHome = getUnreadNotificationCount();
            isLoaded = true;
          });
        } else {
          setState(() {
            notificationList = [];
            unreadCountHome = 0;
            isLoaded = true;
          });
        }
      } else if (_userType == 'Officer') {
        setState(() {
          isLoaded = true;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoaded = true;
      });
    }
  }

  int getUnreadNotificationCount() {
    if (notificationList == null) return 0;
    return notificationList!
        .where((notification) => notification.status_view == 'ยังไม่ได้อ่าน')
        .toList()
        .length;
  }

  List<Widget> _getOfficerOptions() => <Widget>[
        HomeDetailScreen(),
        ScanStudentIdScreen(),
        OfficerProfileScreen(),
      ];

  List<Widget> _getStudentOptions() => <Widget>[
        HomeDetailScreen(),
        QRCodeScreen(),
        NotificationScreen(updateUnreadCount: (int unreadCount) {
          setState(() {
            this.unreadCountHome = unreadCount;
          });
        }),
        StudentProfileScreen(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      _hideBottomNavigationBar = (_userType == 'Officer' && index == 1) ||
          (_userType == 'Student' && index == 1);
    });
  }

  @override
  void dispose() {
    subscription.cancel(); // Cancel the subscription when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_userType == null) {
      return Center(child: CircularProgressIndicator());
    }

    final isOfficer = _userType == 'Officer';
    final widgetOptions =
        isOfficer ? _getOfficerOptions() : _getStudentOptions();

    return Scaffold(
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: !_hideBottomNavigationBar
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle:
                  TextStyle(color: Colors.grey[400], fontFamily: 'Mitr'),
              unselectedLabelStyle:
                  TextStyle(color: Colors.grey, fontFamily: 'Mitr'),
              items: isOfficer
                  ? <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: 'หน้าหลัก'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.qr_code_scanner_outlined),
                          label: 'สแกน'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.account_circle_outlined),
                          label: 'บัญชีผู้ใช้'),
                    ]
                  : <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: 'หน้าหลัก'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.qr_code_scanner_outlined),
                          label: 'คิวอาร์โค้ด'),
                      BottomNavigationBarItem(
                        icon: Stack(
                          children: [
                            Icon(Icons.notifications),
                            if (unreadCountHome > 0)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  height: 13, // เพิ่มขนาดให้เหมาะสม
                                  width: 13, // เพิ่มขนาดให้เหมาะสม
                                  padding: EdgeInsets.symmetric(horizontal: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$unreadCountHome',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 9),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        label: 'แจ้งเตือน',
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.account_circle_outlined),
                          label: 'บัญชีผู้ใช้'),
                    ],
              backgroundColor: Colors.grey[350],
              currentIndex: _selectedIndex,
              selectedItemColor: Color(0xFF006D0D),
              unselectedItemColor: Color(0xFF008910),
              onTap: (index) {
                _onItemTapped(index);
              },
            )
          : null,
    );
  }
}
