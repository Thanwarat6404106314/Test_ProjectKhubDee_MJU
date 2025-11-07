package com.itsci.khubdeemju.service;

import com.itsci.khubdeemju.model.Notification;
import com.itsci.khubdeemju.model.RecordViolation;

import com.itsci.khubdeemju.repository.NotificationRepository;
import com.itsci.khubdeemju.repository.RecordViolationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service
public class NotificationServiceImpl implements NotificationService {

    @Autowired
    private NotificationRepository notificationRepository;


    @Autowired
    private RecordViolationRepository  recordViolationRepository;

    @Override
    public RecordViolation getRecordViolationById(String record_id) {
        return recordViolationRepository.getReferenceById(record_id);
    }

    @Override
    public Notification getNotificationById(String notification_id) {
        return notificationRepository.getReferenceById(notification_id);
    }

    @Override
    public Notification addNotification(Map<String, String> map) throws ParseException {
        Date notification_date = new Date();
        String notification_status = "กำลังพิจารณา";
        String message = "แจ้งเตือนถูกลงบันทึกประจำวัน เนื่องจากการละเมิดกฎจราจรภายในมหาวิทยาลัยแม่โจ้";
        String status_view = "ยังไม่ได้อ่าน";
        String record_id = map.get("recordViolation");
        RecordViolation recordViolation = getRecordViolationById(record_id);

        Notification notification = new Notification(null, notification_date, notification_status, message, status_view, recordViolation);
        return notificationRepository.save(notification);
    }

    @Override
    public List<Notification> getListNotificationByStudentId(String student_id) {
        return notificationRepository.findNotificationByStudentID(student_id);
    }

    @Override
    public List<Notification> getListNotification() {
        return notificationRepository.findAll();
    }

    @Override
    public void deleteNotification(String notification_id) {
        Notification notification = notificationRepository.getReferenceById(notification_id);
        notificationRepository.delete(notification);
    }

    @Override
    public void updateStatus(String notification_id) {
//        notificationRepository.updateStatus(notification_id);
        Notification notification = notificationRepository.getReferenceById(notification_id);
        if (notification.getStatus_view().equals("ยังไม่ได้อ่าน")) {
            notification.setStatus_view("อ่านแล้ว");
        }
        notificationRepository.save(notification);
    }


}
