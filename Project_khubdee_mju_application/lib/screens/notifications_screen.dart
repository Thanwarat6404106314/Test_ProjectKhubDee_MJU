import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:project_final/controller/NotificationsController.dart';
import 'package:project_final/controller/StudentController.dart';
import 'package:project_final/model/notifications.dart';
import 'package:project_final/model/student.dart';
import 'package:project_final/screens/home_screen.dart';
import 'package:project_final/screens/notification_detail_screen.dart';
import 'package:project_final/utils/event_bus.dart';
import 'package:project_final/utils/event_class.dart';

class NotificationScreen extends StatefulWidget {
  final Function(int) updateUnreadCount;
  NotificationScreen({Key? key, required this.updateUnreadCount})
      : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  StudentController studentController = StudentController();
  NotificationsController notificationsController = NotificationsController();

  List<Notifications>? notificationList;
  String? email;
  Student? student;
  bool? isLoaded;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var emailSession = await SessionManager().get("email");
    email = emailSession.toString();

    student = await studentController.getStudentByEmail(email ?? "");
    setState(() {
      isLoaded = true;
    });

    try {
      if (student != null) {
        List<Notifications> notifications = await notificationsController
            .getListNotificationsByStudentID(student!.student_id.toString());
        setState(() {
          notificationList = notifications;
          isLoaded = true;
        });
        int unreadCount = getUnreadNotificationCount();
        widget.updateUnreadCount(unreadCount);
      } else {
        setState(() {
          notificationList = [];
          isLoaded = true;
        });
        widget.updateUnreadCount(0);
      }
    } catch (e) {
      print('E: $e');
      setState(() {
        notificationList = [];
        isLoaded = true;
      });
      widget.updateUnreadCount(0);
    }
  }

  // ฟังก์ชันคำนวณจำนวนข้อความที่ยังไม่ได้อ่าน
  int getUnreadNotificationCount() {
    if (notificationList == null) return 0;
    return notificationList!
        .where((notification) => notification.status_view == 'ยังไม่ได้อ่าน')
        .toList()
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แจ้งเตือน',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontFamily: 'Mitr')),
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
      body: isLoaded == true
          ? notificationList != null && notificationList!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // แสดงจำนวนข้อความที่ยังไม่ได้อ่าน
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'ยังไม่ได้อ่าน: ${getUnreadNotificationCount()} ข้อความ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                                fontFamily: 'Mitr',
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: notificationList!.length,
                            itemBuilder: (context, index) {
                              final notifications = notificationList![index];
                              final notificationDate = DateFormat('dd-MM-yyyy')
                                  .format(notifications.notification_date ??
                                      DateTime.now());
                              final notificationTime = DateFormat('HH:mm')
                                  .format(notifications.notification_date ??
                                      DateTime.now());

                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 5.0,
                                          spreadRadius: 1.0,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        '${notifications.message}' ,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          fontFamily: 'Mitr',
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Text(
                                        'สถานะ: ${notifications.status_view == 'อ่านแล้ว' ? 'อ่านแล้ว' : 'ยังไม่ได้อ่าน'}\nวันที่: $notificationDate     เวลา: $notificationTime น.',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                            fontFamily: 'Mitr'),
                                      ),
                                      trailing: Icon(
                                        size: 22,
                                        notifications.status_view == 'อ่านแล้ว'
                                            ? Icons.notifications
                                            : Icons
                                                .notifications_active_rounded,
                                        color: notifications.status_view ==
                                                'อ่านแล้ว'
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      onTap: () async {
                                        try {
                                          await notificationsController
                                              .updateStatus(notifications
                                                  .notification_id
                                                  .toString());
                                          setState(() {
                                            notifications.status_view =
                                                'อ่านแล้ว';
                                          });
                                          
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  NotificationDetailScreen(
                                                      notifications:
                                                          notifications),
                                            ),
                                          ).then((value) => eventBus.fire(MyEvent("refresh notification")));
                                        } catch (e) {
                                          print("Failed to update status: $e");
                                        }
                                      },
                                    ),
                                  ),
                                  Divider(
                                    height: 0.5,
                                    color: Colors.grey,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off,
                        size: 50,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "ไม่พบข้อมูลการแจ้งเตือน",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                          fontFamily: 'Mitr',
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
