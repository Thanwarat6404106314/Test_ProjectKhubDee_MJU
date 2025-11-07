package com.itsci.khubdeemju.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.*;
import java.util.concurrent.ThreadLocalRandom;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "notification")
@JsonIgnoreProperties({ "hibernateLazyInitializer", "handler" })
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

    // สำหรับ Generate ID อัตโนมัติ
    @PrePersist
    public void generateRecordId() {
        if (this.notification_id == null) {
            this.notification_id = generateCustomId();
        }
    }

    private String generateCustomId() {
        int randomNum = ThreadLocalRandom.current().nextInt(1000, 9999); // สุ่มเลข 4 หลัก (0000 - 9999)
        return String.format("NF" + randomNum);
    }

}
