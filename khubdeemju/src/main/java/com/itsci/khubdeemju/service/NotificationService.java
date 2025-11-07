package com.itsci.khubdeemju.service;

import com.itsci.khubdeemju.model.Notification;
import com.itsci.khubdeemju.model.RecordViolation;

import java.text.ParseException;
import java.util.List;
import java.util.Map;

public interface NotificationService {

//    Student getStudentById(String student_id);

    RecordViolation getRecordViolationById(String record_id);

    Notification getNotificationById(String notification_id);

    List<Notification> getListNotification();

    List<Notification> getListNotificationByStudentId(String student_id);

    Notification addNotification(Map<String,String> map) throws ParseException;

    void deleteNotification(String notification_id);

    void updateStatus(String notification_id);
}
