package com.itsci.khubdeemju.model;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "Student")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
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
    @Column(name = "password", length = 20, nullable = false)
    private String password;

}