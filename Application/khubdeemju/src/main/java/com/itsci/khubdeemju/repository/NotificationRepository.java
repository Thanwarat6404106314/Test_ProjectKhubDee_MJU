package com.itsci.khubdeemju.repository;

import com.itsci.khubdeemju.model.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface NotificationRepository extends JpaRepository<Notification, String> {

//    @Transactional
//    @Modifying
//    @Query(value = "UPDATE Notification SET status_view = 'อ่านแล้ว' WHERE notification_id = :notification_id", nativeQuery = true)
//    void updateStatus(@Param("notification_id") String notification_id);

    @Query("FROM Notification n JOIN n.recordViolation r JOIN r.student s WHERE s.student_id = :student_id ORDER BY n.notification_date DESC ")
    List<Notification> findNotificationByStudentID(@Param("student_id") String student_id);

}
