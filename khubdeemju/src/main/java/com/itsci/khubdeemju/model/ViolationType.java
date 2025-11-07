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
@Table(name = "violationtype")
@JsonIgnoreProperties({ "hibernateLazyInitializer", "handler" })
public class ViolationType {

    @Id
    @Column(name = "violation_id", length = 4)
    private String violation_id;
    @Column(name = "violation_name", length = 50, nullable = false)
    private String violation_name;
    @Column(name = "deduct_score", nullable = false)
    private int deduct_score;

}
