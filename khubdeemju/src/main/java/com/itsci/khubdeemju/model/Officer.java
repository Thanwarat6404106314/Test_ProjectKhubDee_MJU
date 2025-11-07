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
@Table(name = "Officer")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Officer {

    @Id
    @Column(name = "officer_id", length = 10)
    private String officer_id;
    @Column(name = "firstname", length = 50, nullable = false)
    private String firstname;
    @Column(name = "lastname", length = 50, nullable = false)
    private String lastname;
    @Column(name = "position", length = 30, nullable = false)
    private String position;
    @Column(name = "signature", length = 255, nullable = false)
    private String signature;
    @Column(name = "img_officer")
    private String img_officer;
    @Column(name = "email", length = 50, nullable = false)
    private String email;
    @Column(name = "password", length = 20, nullable = false)
    private String password;

}
