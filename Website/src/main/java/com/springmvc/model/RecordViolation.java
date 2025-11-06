package com.springmvc.model;

import javax.persistence.*;

import java.util.Date;
import java.util.concurrent.ThreadLocalRandom;

@Entity
@Table(name = "recordviolation")
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
    private Date deduct_date;

    @ManyToOne
    @JoinColumn(name = "student_id", nullable = false)
    private Student student;

    @ManyToOne
    @JoinColumn(name = "officer_id", nullable = false)
    private Officer officer;

    @ManyToOne
    @JoinColumn(name = "violation_id", nullable = false)
    private ViolationType violationType;

    @ManyToOne
    @JoinColumn(name = "location_id", nullable = false)
    private Location location;

    public RecordViolation() {
    }

    public RecordViolation(String record_id, Date record_date, int remaining_score,
            String picture_evidence, String status_type, int deduct_no, Date deduct_date, Student student,
            Officer officer, ViolationType violationType, Location location) {
        super();
        this.record_id = record_id;
        this.record_date = record_date;
        this.remaining_score = remaining_score;
        this.picture_evidence = picture_evidence;
        this.status_type = status_type;
        this.deduct_no = deduct_no;
        this.deduct_date = deduct_date;
        this.student = student;
        this.officer = officer;
        this.violationType = violationType;
        this.location = location;
    }

    // Getter และ Setter (อาจสร้างขึ้นโดยอัตโนมัติด้วย Lombok)
    public String getRecord_id() {
        return record_id;
    }

    public void setRecord_id(String record_id) {
        this.record_id = record_id;
    }

    public Date getRecord_date() {
        return record_date;
    }

    public void setRecord_date(Date record_date) {
        this.record_date = record_date;
    }

    public int getRemaining_score() {
        return remaining_score;
    }

    public void setRemaining_score(int remaining_score) {
        this.remaining_score = remaining_score;
    }

    public String getPicture_evidence() {
        return picture_evidence;
    }

    public void setPicture_evidence(String picture_evidence) {
        this.picture_evidence = picture_evidence;
    }

    public String getStatus_type() {
        return status_type;
    }

    public void setStatus_type(String status_type) {
        this.status_type = status_type;
    }

    public int getDeduct_no() {
        return deduct_no;
    }

    public void setDeduct_no(int deduct_no) {
        this.deduct_no = deduct_no;
    }

    public Date getDeduct_date() {
        return deduct_date;
    }

    public void setDeduct_date(Date deduct_date) {
        this.deduct_date = deduct_date;
    }

    public Student getStudent() {
        return student;
    }

    public void setStudent(Student student) {
        this.student = student;
    }

    public Officer getOfficer() {
        return officer;
    }

    public void setOfficer(Officer officer) {
        this.officer = officer;
    }

    public ViolationType getViolationType() {
        return violationType;
    }

    public void setViolationType(ViolationType violationType) {
        this.violationType = violationType;
    }

    public Location getLocation() {
        return location;
    }

    public void setLocation(Location location) {
        this.location = location;
    }

    // สำหรับ Generate ID อัตโนมัติ
    @PrePersist
    public void generateRecordId() {
        if (this.record_id == null) {
            this.record_id = generateCustomId();
        }
    }

    private String generateCustomId() {
        int randomNum = ThreadLocalRandom.current().nextInt(0001, 9999);
        return String.format("RC%04d", randomNum);
    }
}
