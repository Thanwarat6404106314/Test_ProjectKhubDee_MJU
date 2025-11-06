package com.springmvc.model;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.concurrent.ThreadLocalRandom;

@Entity
@Table(name = "Notification")
public class Notification {

    @Id
    @Column(name = "notification_id", length = 6)
    private String notification_id;

    @Column(name = "notification_date", nullable = false)
    private Date notification_date;
    
    @Column(name = "notification_status", length = 50, nullable = false)
    private String notification_status;
    
    @Column(name = "message", columnDefinition = "TEXT")
    private String message;

    @Column(name = "status_view", nullable = false)
    private String status_view;

    @ManyToOne
    @JoinColumn(name = "record_id", nullable = false)
    private RecordViolation recordViolation;

    private String generateCustomId() {
        int randomNum = ThreadLocalRandom.current().nextInt(0001, 9999); // สุ่มเลข 4 หลัก (0000 - 9999)
        return String.format("NF%04d", randomNum);
    }

    // Getter และ Setter
    public String getNotification_id() {
        return notification_id;
    }

    public void setNotification_id(String notification_id) {
        this.notification_id = notification_id;
    }

    public Date getNotification_date() {
        return notification_date;
    }

    public void setNotification_date(Date notification_date) {
        this.notification_date = notification_date;
    }

    public String getNotification_status() {
		return notification_status;
	}

	public void setNotification_status(String notification_status) {
		this.notification_status = notification_status;
	}

	public String getStatus_view() {
        return status_view;
    }

    public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public void setStatus_view(String status_view) {
        this.status_view = status_view;
    }


    public RecordViolation getRecordViolation() {
        return recordViolation;
    }

    public void setRecordViolation(RecordViolation recordViolation) {
        this.recordViolation = recordViolation;
    }
    
    @PrePersist
    public void generateRecordId() {
        if (this.notification_id == null) {
            this.notification_id = generateCustomId();
        }
    }
}
