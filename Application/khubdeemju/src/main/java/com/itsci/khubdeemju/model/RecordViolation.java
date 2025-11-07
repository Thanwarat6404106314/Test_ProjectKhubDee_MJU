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
@Table(name = "RecordViolation")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class RecordViolation {

    @Id
    @Column(name = "record_id", length = 10)
    private String record_id;
    @Column(name = "record_date", nullable = false)
    private Date record_date;
    @Column(name = "remaining_score", nullable = false)
    private int remaining_score;
    @Column(name = "picture_evidence")
    private String picture_evidence;
    @Column(name = "status_type", length = 50, nullable = false)
    private String status_type;
    @Column(name = "deduct_no", length = 2)
    private int deduct_no;
    @Column(name = "deduct_date")
    private Date deduc_date;

    @ManyToOne
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @ManyToOne
    @JoinColumn(name = "officer_id", nullable = false)
    private Officer officer;

    @ManyToOne
    @JoinColumn(name = "location_id", nullable = false)
    private Location location;

    @ManyToOne
    @JoinColumn(name = "violation_id", nullable = false)
    private ViolationType violationType;

//   สำหรับ Generate ID อัตโนมัติ
    @PrePersist
    public void generateRecordId() {
        if (this.record_id == null) {
            this.record_id = generateCustomId();
        }
    }

    private String generateCustomId() {
        int randomNum = ThreadLocalRandom.current().nextInt(1000, 9999); // สุ่มเลข 4 หลัก (0000 - 9999)
        return String.format("RC" + randomNum);
    }



}
