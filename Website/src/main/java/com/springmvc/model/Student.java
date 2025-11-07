package com.springmvc.model;

import javax.persistence.*;

@Entity
@Table(name = "Student")
public class Student {

    @Id
    @Column(name = "student_id", length = 10)
    private String student_id;

    @Column(name = "firstname", length = 50, nullable = false)
    private String firstname;

    @Column(name = "lastname", length = 50, nullable = false)
    private String lastname;

    @Column(name = "major", length = 40, nullable = false)
    private String major;

    @Column(name = "faculty", length = 40, nullable = false)
    private String faculty;

    @Column(name = "student_score", nullable = false)
    private int student_score;

    @Column(name = "img_student")
    private String img_student;

    @Column(name = "email", length = 50, nullable = false)
    private String email;

    @Column(name = "password", length = 60, nullable = false)
    private String password;

    public Student() {
    }

    public Student(String student_id, String firstname, String lastname, String major, String faculty,
            int student_score, String img_student, String email, String password) {
        super();
        this.student_id = student_id;
        this.firstname = firstname;
        this.lastname = lastname;
        this.major = major;
        this.faculty = faculty;
        this.student_score = student_score;
        this.img_student = img_student;
        this.email = email;
        this.password = password;
    }

    public String getStudent_id() {
        return student_id;
    }

    public void setStudent_id(String student_id) {
        this.student_id = student_id;
    }

    public String getFirstname() {
        return firstname;
    }

    public void setFirstname(String firstname) {
        this.firstname = firstname;
    }

    public String getLastname() {
        return lastname;
    }

    public void setLastname(String lastname) {
        this.lastname = lastname;
    }

    public String getMajor() {
        return major;
    }

    public void setMajor(String major) {
        this.major = major;
    }

    public String getFaculty() {
        return faculty;
    }

    public void setFaculty(String faculty) {
        this.faculty = faculty;
    }

    public int getStudent_score() {
        return student_score;
    }

    public void setStudent_score(int student_score) {
        this.student_score = student_score;
    }

    public String getImg_student() {
        return img_student;
    }

    public void setImg_student(String img_student) {
        this.img_student = img_student;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}