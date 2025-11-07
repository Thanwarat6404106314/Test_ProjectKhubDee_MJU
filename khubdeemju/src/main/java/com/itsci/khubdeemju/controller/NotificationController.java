package com.itsci.khubdeemju.controller;

import com.itsci.khubdeemju.model.Notification;
import com.itsci.khubdeemju.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/notification")
public class NotificationController {

    @Autowired
    private NotificationService notificationService;

    @GetMapping("/getbyid/{notification_id}")
    public ResponseEntity getNotificationById(@PathVariable("notification_id") String notification_id) throws IllegalStateException{
        try{
            Notification notification = notificationService.getNotificationById(notification_id);
            return new ResponseEntity<>(notification, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>("รหัสแจ้งเตือนไม่ถูกต้อง!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/list")
    public ResponseEntity getListNotification(){
        try{
            List<Notification> notification =  notificationService.getListNotification();
            return new ResponseEntity<>(notification, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>("ไม่พบข้อมูลรายการแจ้งเตือน", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/list/{student_id}")
    public ResponseEntity getListNotificationByStudentId(@PathVariable("student_id") String student_id){
        try {
            List<Notification> notification = notificationService.getListNotificationByStudentId(student_id);
            return new ResponseEntity<>(notification, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("ไม่พบข้อมูลรายการแจ้งเตือนสำหรับนักศึกษารหัส " + student_id, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/add")
    public ResponseEntity addNotification(@RequestBody Map<String,String> map){
        try{
            Notification notification = notificationService.addNotification(map);
            return new ResponseEntity<>(notification, HttpStatus.OK);
        }catch (Exception e){
            e.printStackTrace();
            return new ResponseEntity<>("ไม่สามารถเพิ่มข้อมูลการแจ้งเตือนได้!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @DeleteMapping("/delete/{notification_id}")
    public ResponseEntity deleteNotification(@PathVariable("notification_id") String notification_id) {
        try {
            notificationService.deleteNotification(notification_id);
            return new ResponseEntity<>("notification ID " + notification_id + " was deleted!", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Failed to delete!", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping("/updateStatus/{notification_id}")
    public ResponseEntity<String> updateStatus(@PathVariable("notification_id") String notification_id) {
        try {
            notificationService.updateStatus(notification_id);
            return new ResponseEntity<>("สถานะการแจ้งเตือนถูกอัปเดตแล้ว", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("ไม่สามารถอัปเดตสถานะได้", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }


}
